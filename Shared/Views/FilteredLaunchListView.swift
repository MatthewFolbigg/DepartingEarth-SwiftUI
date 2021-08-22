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
    @Namespace private var launchesNameSpace
    
    var fetchRequest: FetchRequest<Launch>
    var launches: FetchedResults<Launch> { fetchRequest.wrappedValue }
    
    @State var selectedLaunch: Launch? = nil
    @State var presentingLaunch: Bool = false
    
    @Binding var providerFilter: String?
    @Binding var orbitFilter: String?
    @Binding var statusFilter: String?
    @Binding var showingPinned: Bool
    var isFiltered: Bool { providerFilter != nil || orbitFilter != nil || statusFilter != nil}
    
    var body: some View {
        ZStack {
            List {
                ForEach(launches, id: \.self) { launch in
                    ZStack {
                        LaunchListItemView(launch: launch, isPinned: pinned.isPinned(launch))
                        //For` iPad// NavigationLink(destination: LaunchDetailView(launch: launch)) { EmptyView() }.hidden() //Will be the method for iPad
                    }
                    .onTapGesture {
                        self.selectedLaunch = launch
                    }
                }
            }
            .sheet(item: $selectedLaunch) { launch in
                NavigationView { LaunchDetailView(launch: launch).environmentObject(pinned) }
            }
            .listStyle(PlainListStyle())
//            .animation(nil) //Removed animation due to glitches with long lists whilst looking for work arounds
            if launches.isEmpty { emptyListIndicator.zIndex(1).animation(.easeInOut) }
        }
    }
    
    init(pinnedIDs: [String] = [], showPinned: Binding<Bool> = .constant(false), providerFilter: Binding<String?> = .constant(nil), statusFilter: Binding<String?> = .constant(nil), orbitFilter: Binding<String?> = .constant(nil), sortAscending: Bool = true) {
        
        _showingPinned = showPinned
        _providerFilter = providerFilter
        _statusFilter = statusFilter
        _orbitFilter = orbitFilter
        
        var predicates: [NSPredicate] = []
        if showPinned.wrappedValue {
            predicates.append(NSPredicate(format: "launchID IN %@", pinnedIDs))
        }
        
        if let providerFilter = providerFilter.wrappedValue {
            predicates.append(NSPredicate(format: "provider.name == %@", providerFilter))
        }
        
        if let statusFilter = statusFilter.wrappedValue {
            predicates.append(NSPredicate(format: "status_.name == %@", statusFilter))
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
                        Label("Clear Filters", systemImage: "x.circle")
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
//        FilteredLaunchListView(providerFilter: .constant("SpaceX"), statusFilter: .constant(nil), orbitFilter: .constant(nil), sortAscending: true)
//    }
//}
