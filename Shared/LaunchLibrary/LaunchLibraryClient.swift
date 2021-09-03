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
    @Published var lastSuccessfulFetch = Date() //Used as an ID for a launch list. Will refresh the list when changed to make sure all data is updated on currently displayed launches
    
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
                            self.handleFetchError(.apiRateLimit, printDescription: "Request Throttled, Too Many requests made.")
                            return
                        case 200:
                            print("API Success")
                            break
                        default:
                            self.handleFetchError(.apiUnknownError, printDescription: "Got a response but not a handled error code. Code: \(response.statusCode)")
                            return
                    }
                }
            
                if response.statusCode == 200 {
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
                                self.lastSuccessfulFetch = Date()
                            }
                            return
                        } else {
                            DispatchQueue.main.async {
                                self.handleFetchError(.dataDecodeError, printDescription: "Unable to decode data returned from request")
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.handleFetchError(.dataNilError, printDescription: "No data returned from request")
                        }
                    }
                }
                //TODO: No Response as HTTPURLResponse
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
        Launch.removeStale(from: self.context)
    }
    
}


//MARK: Errors
extension LaunchLibraryApiClient {
    
    enum LaunchLibraryError: String, Identifiable {
        case networkFailure
        case apiRateLimit
        case apiUnknownError
        case dataNilError
        case dataDecodeError
        
        var id: String { self.rawValue }
        
        var alert: Alert {
            switch self {
            case .networkFailure:
                return Alert(
                    title: Text("Network Failure"),
                    message: Text("Unable to fetch launches. Check your internet connection and try again")
                )
            case .apiRateLimit:
                return Alert(
                    title: Text("API Throttled"),
                    message: Text("Too many update requests have been made, please try again later")
                )
            case .apiUnknownError:
                return Alert(
                    title: Text("Unknow Error"),
                    message: Text("Something went wrong with the upcoming launch list. Please try again.")
                )
            case .dataNilError:
                return Alert(
                    title: Text("No Data"),
                    message: Text("No data was received, check your network connection and try again.")
                )
            case .dataDecodeError:
                return Alert(
                    title: Text("Unable to Decode Data"),
                    message: Text("Something went wrong with the upcoming launch data, please try again.")
                )
            }
        }
    }
    
    
}
