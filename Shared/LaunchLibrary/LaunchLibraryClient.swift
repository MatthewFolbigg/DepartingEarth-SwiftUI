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
    private static var developerMode: Bool = true
    
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
    //MARK: - Requests
    private var launchDataFetchCancellable: AnyCancellable?
    
    enum FetchStatus {
        case idle
        case fetching
    }

    func fetchData(_ endpoint: Endpoint) {
        print(endpoint.url)
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
                for info in data.results {
                    Launch.create(from: info, context: self!.context)
                    try? self?.context.save()
                }
            })
    }
    
    func fetchImageData(url: URL?, cancellable: Binding<AnyCancellable?>, completion: @escaping (UIImage?) -> Void) {
        if let url = url {
            cancellable.wrappedValue?.cancel()
            let session = URLSession.shared
            let publisher = session.dataTaskPublisher(for: url)
                .map { (data, urlResponse) in UIImage(data: data) }
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
            cancellable.wrappedValue = publisher
                .sink(receiveValue: { image in
                    completion(image)
                }
            )
        }
    }
}
