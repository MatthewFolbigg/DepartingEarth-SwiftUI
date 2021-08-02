//
//  LaunchLibraryClient.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 02/08/2021.
//

import Foundation
import Combine
import CoreData

class LaunchLibraryApiClient: ObservableObject {
    //API Documentation: https://thespacedevs.com/llapi
    private static var developerMode: Bool = false
    //MARK: -
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    //MARK: - Published
    @Published var fetchStatus: FetchStatus = .idle
    
    //MARK: - Endpoints
    enum Endpoint {
        case upcomingLaunches
        
        var url: URL {
            switch self {
            case .upcomingLaunches: return URL(string: upcomingLaunchesURL)!
            }
        }
    }
    
    private static var baseUrl: String { developerMode ?
        "https://lldev.thespacedevs.com/2.0.0/" :
        "https://ll.thespacedevs.com/2.0.0/"  //Provides acctual data but throttled.
    }
    private static let inJson = "?format=json"
    private static let detailed = "?mode=detailed"
    private static let upcomingLaunches = "launch/upcoming/"
    private static let agencies = "agencies/"
    private static let first30 = "&limit=80&offset=0"
    private static var upcomingLaunchesURL: String { baseUrl + upcomingLaunches + detailed + "&" + inJson + first30 }
    
    //MARK: - Requests
    enum FetchStatus {
        case idle
        case fetching
    }
    
    private var launchDataFetchCancellable: AnyCancellable?
    
    func fetchData(_ endpoint: Endpoint) {
        fetchStatus = .fetching
        launchDataFetchCancellable?.cancel()
        let session = URLSession.shared
        let publisher = session.dataTaskPublisher(for: endpoint.url)
            .map(\.data)
            .decode(type: UpcomingLaunchApiResponse.self, decoder: JSONDecoder())
            .replaceError(with: UpcomingLaunchApiResponse(results: []))
            .receive(on: DispatchQueue.main)
        launchDataFetchCancellable = publisher
            .sink(receiveValue: { [weak self] data in
                self?.fetchStatus = .idle
                //TODO: Refactor creation of launches to somewhere else
                for info in data.results {
                    print(info.name)
                    let newLaunch = Launch(context: self!.context)
                    newLaunch.name = info.name
                    newLaunch.provider = info.launchServiceProvider.name
                    try? self?.context.save()
                    //Create Core Data Object
                }
                //Completion, set coredata object?
            })
    }
}
