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
    
    var body: some View {
        List(launches, id: \.self) { launch in
            ZStack {
                LaunchListItemView(launch: launch)
                NavigationLink(destination: LaunchDetailView(launch: launch)) { EmptyView() }.hidden()
            }
        }
//        .listStyle(PlainListStyle())
        .transition(.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .top)))
    }
    
    init(providerFilter: String? = nil, statusFilter: String?, orbitFilter: String? = nil, sortAscending: Bool = true) {
        var predicates: [NSPredicate] = []
        
        if let providerFilter = providerFilter {
            predicates.append(NSPredicate(format: "provider.name == %@", providerFilter))
        }
        
        if let statusFilter = statusFilter {
            predicates.append(NSPredicate(format: "status.name == %@", statusFilter))
        }
        
        if let orbitFilter = orbitFilter {
            predicates.append(NSPredicate(format: "mission.orbit.name == %@", orbitFilter))
        }
        
        let request = FetchRequest(
            fetchRequest: Launch.requestForAll(sortBy: .date, ascending: sortAscending, predicates: predicates),
            animation: .default)
        fetchRequest = request
    }
    
}

struct FilteredLaunchList_Previews: PreviewProvider {
    static var previews: some View {
        FilteredLaunchList(providerFilter: "SpaceX", statusFilter: nil, orbitFilter: nil, sortAscending: true)
    }
}
