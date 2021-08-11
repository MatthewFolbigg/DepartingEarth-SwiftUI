//
//  UpcomingLaunchList.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 05/08/2021.
//

import Foundation
import CoreData

class UpcomingLaunchList: ObservableObject {
    
    @Published var sortAscending: Bool = true
    @Published var providerFilter: Provider? = nil
    @Published var statusFilter: Status? = nil
    @Published var orbitFilter: Orbit? = nil
    
    var isFiltered: Bool { providerFilter != nil || statusFilter != nil || orbitFilter != nil }
        
    init() {
        
    }
    
    func removeAllFilters() {
        providerFilter = nil
        statusFilter = nil
        orbitFilter = nil
    }
    
    func filteredLaunchRequest() -> NSFetchRequest<Launch> {
        let launchRequest = Launch.requestForAll(sortBy: .date, ascending: sortAscending)
        var predicates: [NSPredicate] = []
        
        if let providerFilter = providerFilter {
            let providerPredicate = NSPredicate(format: "provider.name == %@", providerFilter.name ?? "")
            predicates.append(providerPredicate)
        }
        if let statusFilter = statusFilter {
            let statusPredicate = NSPredicate(format: "status.name == %@", statusFilter.name ?? "")
            predicates.append(statusPredicate)
        }
        if let orbitFilter = orbitFilter {
            let orbitPredicate = NSPredicate(format: "mission.orbit.abbreviation == %@", orbitFilter.abbreviation ?? "")
            predicates.append(orbitPredicate)
        }
        launchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        return launchRequest
    }
    
    
}
