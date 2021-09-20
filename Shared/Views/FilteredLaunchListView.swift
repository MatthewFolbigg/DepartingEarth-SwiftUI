//
//  FilteredLaunchListView.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 14/08/2021.
//

import SwiftUI
import CoreData

struct FilteredLaunchListView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var pinned: PinnedLaunches
    @Namespace private var launchesNameSpace
    
    var fetchRequest: FetchRequest<Launch>
    var launches: FetchedResults<Launch> { fetchRequest.wrappedValue }
    
    @Binding var providerFilter: String?
    @Binding var orbitFilter: String?
    @Binding var statusFilter: String?
    @Binding var showingPinned: Bool
    var isFiltered: Bool { providerFilter != nil || orbitFilter != nil || statusFilter != nil}
    
    var body: some View {
        ZStack {
        List {
            ForEach(launches, id: \.self.launchID) { launch in
                ZStack {
                    NavigationLink(destination: LaunchDetailView(launch: launch)) { EmptyView() }.opacity(0.0)
                    LaunchListItemView(launch: launch)
                }
                .padding(.vertical, 10)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button {
                        withAnimation(.easeInOut) { pinned.togglePin(for: launch) }
                    } label: {
                        Image(systemName: "pin")
                    }
                    .tint(.app.tracked)
                }
            }
//            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        emptyListIndicator.animation(.easeInOut, value: launches.isEmpty)
        }
    }
        
    init(pinnedIDs: [String] = [], showPinned: Binding<Bool> = .constant(false), providerFilter: Binding<String?> = .constant(nil), statusFilter: Binding<String?> = .constant(nil), orbitFilter: Binding<String?> = .constant(nil), sortAscending: Bool = true) {
        
//        UITableView.appearance().backgroundColor =  // Not available on MacOS
        
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
            if let filter = Status.Filter(rawValue: statusFilter) {
                predicates.append(Status.predicateFor(filter: filter))
            }
        }
        
        if let orbitFilter = orbitFilter.wrappedValue {
            predicates.append(NSPredicate(format: "mission.orbit.name == %@", orbitFilter))
        }
        
        let request = FetchRequest(
            fetchRequest: Launch.requestForAll(sortBy: .date, ascending: sortAscending, predicates: predicates),
            animation: .default)
        fetchRequest = request

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
