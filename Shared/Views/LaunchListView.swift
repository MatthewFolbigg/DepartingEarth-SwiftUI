//
//  LaunchListView.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 03/08/2021.
//

import SwiftUI

struct LaunchListView: View {
    
    @FetchRequest var launches: FetchedResults<Launch>
    @ObservedObject var launchLibrary = LaunchLibraryApiClient.shared
    
    init(provider: Provider? = nil, status: Status? = nil, sortAscending: Bool = true) {
        let launchRequest = Launch.requestForAll(sortBy: .date, ascending: sortAscending)
        var predicates: [NSPredicate] = []
        if let provider = provider {
            let providerPredicate = NSPredicate(format: "provider.name == %@", provider.name ?? "")
            predicates.append(providerPredicate)
        }
        if let status = status {
            let statusPredicate = NSPredicate(format: "status.name == %@", status.name ?? "")
            predicates.append(statusPredicate)
        }
        launchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        _launches = FetchRequest(fetchRequest: launchRequest)
    }
    
    var body: some View {
        List(launches) { launch in
            NavigationLink(destination: LaunchDetailView(launch: launch)) {
                LaunchListItemView(launch: launch)
            }
        }
        .listStyle(PlainListStyle())
        .onAppear {
            if launches.isEmpty {
                print("Data Downloaded")
                launchLibrary.fetchData(.upcomingLaunches)
            } else {
                //TODO: Check for stale Date
                print("Data Loaded")
            }
        }
    }
}

struct LaunchListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        LaunchListView().environment(\.managedObjectContext, context)
    }
}
