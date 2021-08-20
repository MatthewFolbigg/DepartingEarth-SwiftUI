//
//  FilteredLaunchListView.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 14/08/2021.
//

import SwiftUI
import CoreData

struct FilteredLaunchListView: View {
    
    @EnvironmentObject var pinned: PinnedLaunches
    
    var fetchRequest: FetchRequest<Launch>
    var launches: FetchedResults<Launch> { fetchRequest.wrappedValue }
    
    @Binding var providerFilter: String?
    @Binding var orbitFilter: String?
    @Binding var statusFilter: String?
    var isFiltered: Bool { providerFilter != nil || orbitFilter != nil || statusFilter != nil}
    
    var body: some View {
        List { //This list should be directly within a navigation view to prevent issues. Not wrapped in any stacks
            if launches.isEmpty { emptyListIndicator }
            ForEach(launches, id: \.self) { launch in
                ZStack {
                    LaunchListItemView(launch: launch, isPinned: pinned.isPinned(launch))
                    NavigationLink(destination: LaunchDetailView(launch: launch)) { EmptyView() }.hidden()
                }
            }
        }
        .id(UUID()) //This fixes as crash when swapping between pinned and all several times by preventing list animations.
        .listStyle(PlainListStyle())
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
            Spacer()
            HStack {
                Spacer()
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
                Spacer()
            }
            Spacer()
        }
    }
    
}

//struct FilteredLaunchList_Previews: PreviewProvider {
//    static var previews: some View {
//        FilteredLaunchListView(providerFilter: .constant("SpaceX"), statusFilter: .constant(nil), orbitFilter: .constant(nil), sortAscending: true)
//    }
//}
