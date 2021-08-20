//
//  FilteredLaunchList.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 14/08/2021.
//

import SwiftUI
import CoreData

struct FilteredLaunchList: View {
    
    var fetchRequest: FetchRequest<Launch>
    var launches: FetchedResults<Launch> { fetchRequest.wrappedValue }
    
    @EnvironmentObject var pinned: PinnedLaunches
    @Binding var providerFilter: String?
    @Binding var orbitFilter: String?
    @Binding var statusFilter: String?
    var isFiltered: Bool { providerFilter != nil || orbitFilter != nil || statusFilter != nil}
    
    var body: some View {
        ZStack {
            List(launches, id: \.self) { launch in
                ZStack {
                    LaunchListItemView(launch: launch, isPinned: pinned.isPinned(launch))
                    NavigationLink(destination: LaunchDetailView(launch: launch)) { EmptyView() }.hidden()
                }
            }
            .listStyle(PlainListStyle())
            //This transition current doesnt function when .listStyle is set
            .transition(.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .top)))
        
            emptyListIndicator
        }
    }
    
    init(pinnedIDs: [String] = [], showPinned: Bool = false, providerFilter: Binding<String?> = .constant(nil), statusFilter: Binding<String?> = .constant(nil), orbitFilter: Binding<String?> = .constant(nil), sortAscending: Bool = true) {
        
        //TODO: Find a more controled place for these haptics. Aimed to tigger only on filter set/remove
        let filterSetHaptic = UIImpactFeedbackGenerator(style: .medium)
        filterSetHaptic.impactOccurred()
        //---
        
        _providerFilter = providerFilter
        _statusFilter = statusFilter
        _orbitFilter = orbitFilter
        
        var predicates: [NSPredicate] = []
        
        if showPinned {
            predicates.append(NSPredicate(format: "launchID IN %@", pinnedIDs))
        }
        
        if let providerFilter = providerFilter.wrappedValue {
            predicates.append(NSPredicate(format: "provider.name == %@", providerFilter))
        }
        
        if let statusFilter = statusFilter.wrappedValue {
            predicates.append(NSPredicate(format: "status.name == %@", statusFilter))
        }
        
        if let orbitFilter = orbitFilter.wrappedValue {
            predicates.append(NSPredicate(format: "mission.orbit.name == %@", orbitFilter))
        }
        
        let request = FetchRequest(
            fetchRequest: Launch.requestForAll(sortBy: .date, ascending: sortAscending, predicates: predicates),
            animation: .default)
        fetchRequest = request
        
        let launches = request.wrappedValue.map( {$0} )
        if Launch.checkIsStale(launches: launches) {
            LaunchLibraryApiClient.shared.fetchAndUpdateData(.upcomingLaunches)
        }
        
    }
    
    func clearFilters() {
        withAnimation {
            providerFilter = nil
            statusFilter = nil
            orbitFilter = nil
        }
    }
    
    var emptyListIndicator: some View {
        VStack(alignment: .center, spacing: 10) {
            if launches.count == 0 && isFiltered {
                Text("No Launches")
                Button(
                    action: { clearFilters() },
                    label: {
                        Label(
                            title: { Text("Clear Filters") },
                            icon: { Image(systemName: "x.circle") }
                        )
                        .foregroundColor(.red)
                    }
                )
            } else if launches.count == 0 && !isFiltered {
                Text("No Launches")
            }
        }
    }
    
}

//struct FilteredLaunchList_Previews: PreviewProvider {
//    static var previews: some View {
//        FilteredLaunchList(providerFilter: .constant("SpaceX"), statusFilter: .constant(nil), orbitFilter: .constant(nil), sortAscending: true)
//    }
//}
