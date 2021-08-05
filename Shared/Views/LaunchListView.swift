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
    @Binding var orbit: Orbit?
    var isFiltered: Bool { provider != nil || status != nil || orbit != nil }
    
    init(provider: Binding<Provider?>, status: Binding<Status?>, orbit: Binding<Orbit?>, sortAscending: Bool = true) {
        self._provider = provider
        self._status = status
        self._orbit = orbit
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
        if orbit.wrappedValue != nil {
            let orbitPredicate = NSPredicate(format: "mission.orbit.abbreviation == %@", orbit.wrappedValue?.abbreviation ?? "")
            predicates.append(orbitPredicate)
        }
        launchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        _launches = FetchRequest(fetchRequest: launchRequest)
    }
    
    var body: some View {
        List {
            if launches.count == 0 && isFiltered {
                HStack {
                    Spacer()
                    VStack(alignment: .center) {
                        Text("No Launches")
                            .font(.system(.caption, design: .monospaced))
                        Button(
                            action: { orbit = nil; status = nil; provider = nil },
                            label: { Label("Clear Filters", systemImage: "arrow.clockwise.circle") }
                        )
                    }
                    Spacer()
                }
            }
            ForEach(launches) { launch in
                ZStack {
                    LaunchListItemView(launch: launch)
                    NavigationLink(destination: LaunchDetailView(launch: launch)) { EmptyView() }.hidden()
                }
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
