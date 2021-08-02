//
//  Launch.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 02/08/2021.
//

import Foundation
import CoreData

extension Launch {
    
    static func create(from info: LaunchInfo, context: NSManagedObjectContext) {
        let launch = Launch(context: context)
        launch.launchID = info.id
        launch.name = info.name
        launch.provider = info.launchServiceProvider.name
        try? context.save()
    }
    
    static func deleteAll(from context: NSManagedObjectContext) {
        PersistenceController.deleteAll(entityName: "Launch", from: context)
    }
    
}
