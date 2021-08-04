//
//  Launch.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 02/08/2021.
//

import Foundation
import CoreData

extension Launch {
    
    //MARK: - Convienience Varibales
    var name: String {
        get { self.name_ ?? "" }
        set { self.name_ = newValue }
    }
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
    
    //MARK: - Helper Methods
    enum SortOption: String {
        case name = "name_"
        case date = "dateISO"
    }
    
    static func create(from info: LaunchInfo, context: NSManagedObjectContext) {
        let launch = Launch(context: context)
        launch.launchID = info.id
        launch.name_ = info.name
        launch.dateISO = info.noEarlierThan
        launch.windowStart = info.windowStart
        launch.windowEnd = info.windowEnd
        launch.weatherProbability = Int16(info.probability ?? -1)
        launch.hold = info.inhold
        launch.holdReason = info.holdreason
        launch.tbdTime = info.tbdtime
        launch.tbdDate = info.tbddate
        
        launch.provider = Provider.create(from: info.launchServiceProvider, context: context)
        launch.rocket = Rocket.create(from: info.rocket, context: context)
        launch.status = Status.create(from: info.launchStatus, context: context)
    }
    
    static func deleteAll(from context: NSManagedObjectContext) {
        PersistenceController.deleteAll(entityName: "Launch", from: context)
    }
    
    static func requestForAll(sortBy: SortOption, ascending: Bool = true) -> NSFetchRequest<Launch> {
        let request = NSFetchRequest<Launch>(entityName: "Launch")
        request.sortDescriptors = [NSSortDescriptor(key: sortBy.rawValue, ascending: ascending)]
        return request
    }
    
    static func requestForLaunch(withID id: String) -> NSFetchRequest<Launch> {
        let request = NSFetchRequest<Launch>(entityName: "Launch")
        request.sortDescriptors = [NSSortDescriptor(key: SortOption.name.rawValue, ascending: true)]
        request.predicate = NSPredicate(format: "launchID == %@", id)
        return request
    }
    
}
