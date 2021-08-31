//
//  LaunchLibraryClient.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 02/08/2021.
//

import SwiftUI
import Combine
import CoreData

class LaunchLibraryApiClient: ObservableObject {
    //API Documentation: https://thespacedevs.com/llapi
    static var shared = LaunchLibraryApiClient(context: PersistenceController.shared.container.viewContext)
    
    @Published var fetchStatus: FetchStatus = .idle
    @Published var fetchError: LaunchLibraryError? = nil
    
    private var context: NSManagedObjectContext
    private static var developerMode: Bool = false
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }
    
    //MARK: - Endpoints
    private static var baseUrl: String { developerMode ?
        "https://lldev.thespacedevs.com/2.2.0/" : "https://ll.thespacedevs.com/2.2.0/"
    }
    private static let inJson = "?format=json"
    private static let detailed = "?mode=detailed"
    private static let upcomingLaunches = "launch/upcoming/"
    private static let agencies = "agencies/"
    private static let first30 = "&limit=80&offset=0"
    
    private static var upcomingLaunchesURL: String { baseUrl + upcomingLaunches + detailed + "&" + inJson + first30 }
    enum Endpoint {
        case upcomingLaunches
        
        var url: URL {
            switch self {
            case .upcomingLaunches: return URL(string: upcomingLaunchesURL)!
            }
        }
    }
    
    //MARK: - Data Request
    private var launchDataFetchCancellable: AnyCancellable?
    
    enum FetchStatus {
        case idle
        case fetching
    }

    func fetchData(_ endpoint: Endpoint) {
        //TODO: Update to be cancellable to prevent overlapping requests
        let url = endpoint.url
        let request = URLRequest(url: url)
        let decoder = JSONDecoder()
        
        self.fetchStatus = .fetching
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            //MARK: - API Error Cases
            if let response = response as? HTTPURLResponse {
                DispatchQueue.main.async {
                    switch response.statusCode {
                        case 429:
                            self.handleFetchError(.apiThrottle, printDescription: "Request Throttled, Too Many requests made.")
                            return
                        case 200:
                            print("API Success")
                        default: return
                    }
                }
                
            }
            
            //MARK: - Handle Success
            if let data = data {
                if let decoded = try? decoder.decode(UpcomingLaunchApiResponse.self, from: data) {
                    let launches = decoded.results
                    
                    //MARK: Successful resquest but no launches
                    DispatchQueue.main.async {
                        if launches.isEmpty {
                            print("Success but no lanches returned")
                        }
                    }
                    
                    //MARK: Successful resquest with launches
                    DispatchQueue.main.async {
                        self.store(results: launches, in: self.context)
                        self.fetchStatus = .idle
                    }
                    return
                } else {
                    //TODO: Unable to decode Error
                }
            } else {
                //TODO: No Data Error
            }
        }.resume()
        
    }
    
    //MARK: Helper Methods
    func handleFetchError(_ error : LaunchLibraryError, printDescription: String?) {
        if let description = printDescription { print(description) }
        self.fetchError = error
        self.fetchStatus = .idle
    }
    
    func store(results: [LaunchInfo], in context: NSManagedObjectContext) {
        for info in results {
            Launch.create(from: info, context: self.context)
            try? self.context.save()
        }
    }
    
}


//MARK: Errors
extension LaunchLibraryApiClient {
    
    enum LaunchLibraryError: String, Identifiable {
        case networkFailure
        case apiThrottle
        
        var id: String { self.rawValue }
        
        var alert: Alert {
            switch self {
            case .networkFailure:
                return Alert(
                    title: Text("Network Failure"),
                    message: Text("Unable to fetch launches. Check your internet connection and try again")
                )
            case .apiThrottle:
                return Alert(
                    title: Text("API Throttled"),
                    message: Text("Too many update requests have been made, please try again later")
                )
            }
        }
    }
    
    
}
