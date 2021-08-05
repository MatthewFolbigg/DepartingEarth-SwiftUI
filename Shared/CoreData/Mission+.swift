//
//  Mission+.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 05/08/2021.
//

import Foundation
import CoreData

extension Mission {
    static func create(from info: MissionInfo, context: NSManagedObjectContext) -> Mission {
        let mission = Mission(context: context)
        mission.missionID = Int16(info.id)
        mission.name = info.name
        mission.infoText = info.description
        mission.type = info.type
        if let orbitInfo = info.orbit {
            mission.orbit = Orbit.create(from: orbitInfo, context: context)
        }
        return mission
    }
}
