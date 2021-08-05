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
    @Binding var provider: Provider?
    @Binding var status: Status?
    
    init(provider: Binding<Provider?>, status: Binding<Status?>, sortAscending: Bool = true) {
        self._provider = provider
        self._status = status
        let launchRequest = Launch.requestForAll(sortBy: .date, ascending: sortAscending)
        var predicates: [NSPredicate] = []
        if provider.wrappedValue != nil {
            let providerPredicate = NSPredicate(format: "provider.name == %@", provider.wrappedValue?.name ?? "")
            predicates.append(providerPredicate)
        }
        if status.wrappedValue != nil {
            let statusPredicate = NSPredicate(format: "status.name == %@", status.wrappedValue?.name ?? "")
            predicates.append(statusPredicate)
        }
        launchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        _launches = FetchRequest(fetchRequest: launchRequest)
    }
    
    var body: some View {
        List(launches) { launch in
            ZStack {
                LaunchListItemView(launch: launch)
                NavigationLink(destination: LaunchDetailView(launch: launch)) { EmptyView() }.hidden()
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






//struct LaunchListView_Previews: PreviewProvider {
//    static var previews: some View {
//        let context = PersistenceController.shared.container.viewContext
//        LaunchListView().environment(\.managedObjectContext, context)
//    }
//}
