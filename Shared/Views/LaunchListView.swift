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
    
    init(filter: Provider? = nil) {
        let launchRequest = Launch.requestForAll(sortBy: .date)
        if let filter = filter {
            let predicate = NSPredicate(format: "provider.name == %@", filter.name ?? "")
            launchRequest.predicate = predicate
        }
        _launches = FetchRequest(fetchRequest: launchRequest)
    }
    
    var body: some View {
        List(launches) { launch in
            LaunchListItem(launch: launch)
        }
        .listStyle(PlainListStyle())
        .onAppear {
            if launches.isEmpty {
                print("Data Downloaded")
                launchLibrary.fetchData(.upcomingLaunches)
            } else {
                //Check for stale Date
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
