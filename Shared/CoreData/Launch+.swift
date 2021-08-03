//
//  Launch.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 02/08/2021.
//

import Foundation
import CoreData

extension Launch {
    
    var date: Date {
        get {
            let dateFormatter = ISO8601DateFormatter()
            let date = dateFormatter.date(from: self.dateISO!)
            //TODO: Remove force unwrap
            return date!
        }
        set {
            let dateFormatter = ISO8601DateFormatter()
            let newDate = dateFormatter.string(from: newValue)
            self.dateISO = newDate
            try? self.managedObjectContext?.save()
        }
    }
    
    
    enum SortOption: String {
        case name = "name"
        case date = "dateISO"
    }
    
    static func create(from info: LaunchInfo, context: NSManagedObjectContext) {
        let launch = Launch(context: context)
        launch.launchID = info.id
        launch.name = info.name
        launch.dateISO = info.noEarlierThan
        launch.provider = info.launchServiceProvider.name
        try? context.save()
    }
    
    static func deleteAll(from context: NSManagedObjectContext) {
        PersistenceController.deleteAll(entityName: "Launch", from: context)
    }
    
    static func requestForAll(sortBy: SortOption, ascending: Bool = true) -> NSFetchRequest<Launch> {
        let request = NSFetchRequest<Launch>(entityName: "Launch")
        request.sortDescriptors = [NSSortDescriptor(key: sortBy.rawValue, ascending: ascending)]
        return request
    }
    
}
