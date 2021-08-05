//
//  Orbit+.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 05/08/2021.
//

import Foundation
import CoreData

extension Orbit {
    static func create(from info: OrbitInfo, context: NSManagedObjectContext) -> Orbit {
        let orbit = Orbit(context: context)
        orbit.orbitID = Int16(info.id)
        orbit.name = info.name
        orbit.abbreviation = info.abbrev
        return orbit
    }
    
    static func requestForAll(ascending: Bool = true) -> NSFetchRequest<Orbit> {
        let request = NSFetchRequest<Orbit>(entityName: "Orbit")
        request.sortDescriptors = [NSSortDescriptor(key: "orbitID", ascending: ascending)]
        return request
    }
}
