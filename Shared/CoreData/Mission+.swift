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
    
    //TODO: Confirm Icons
    var symbolForType: String {
        switch self.type {
        //Utility
        case "Resupply": return "shippingbox.fill"
        //Deployment
        case "Communications": return "antenna.radiowaves.left.and.right"
        case "Dedicated Rideshare": return "square.stack.3d.up.fill"
        //Science
        case "Earth Science": return "cloud.drizzle.fill"
        case "Planetary Science": return "binoculars.fill"
        case "Heliophysics": return "sun.max.fill"
        case "Astrophysics": return "sun.max.fill"
        //Exploration
        case "Human Exploration": return "person.2.fill"
        case "Robotic Exploration": return "cpu"
        //Other
        case "Test Flight": return "paperplane.fill"
        case "Suborbital": return "circle.bottomhalf.fill"
        case "Government/Top Secret": return "key.fill"
        default: return "circle.fill"
        }
    }
    
}
