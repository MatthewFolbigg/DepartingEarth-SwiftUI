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
        let url = endpoint.url
        let request = URLRequest(url: url)
        let decoder = JSONDecoder()
        
        self.fetchStatus = .fetching
        URLSession.shared.dataTask(with: request) { data, response, error in
        
            if let data = data {
                if let decoded = try? decoder.decode(UpcomingLaunchApiResponse.self, from: data) {
                    //MARK: - Success Cases
                    let launches = decoded.results
                    
                    //MARK: Successful resquest but no launches
                    DispatchQueue.main.async {
                        if launches.isEmpty {
                            print("Success but no lanches returned")
                        }
                    }
                    
                    //MARK: Successful resquest with launches
                    DispatchQueue.main.async {
                        for info in decoded.results {
                            Launch.create(from: info, context: self.context)
                            try? self.context.save()
                        }
                        self.fetchStatus = .idle
                    }
                    return
                }
            }
            //MARK: - Error Cases
            DispatchQueue.main.async {
                print(error?.localizedDescription ?? "Unknown Error")
                self.fetchStatus = .idle
            }
        }.resume()
        
    }
    
}

