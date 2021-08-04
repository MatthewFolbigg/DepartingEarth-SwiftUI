//
//  Status+.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 04/08/2021.
//

import Foundation
import CoreData

extension Status {
    static func create(from info: LaunchStatus, context: NSManagedObjectContext) -> Status {
        let status = Status(context: context)
        status.statusID = Int16(info.id)
        status.name = info.name
        status.abbreviation = info.abbrev
        status.infoText = info.description
        return status
    }
    
    static func requestForAll(ascending: Bool = true) -> NSFetchRequest<Status> {
        let request = NSFetchRequest<Status>(entityName: "Status")
        request.sortDescriptors = [NSSortDescriptor(key: "statusID", ascending: ascending)]
        return request
    }
}
