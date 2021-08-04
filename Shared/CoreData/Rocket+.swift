//
//  Rocket+.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 04/08/2021.
//

import Foundation
import CoreData

extension Rocket {
    
    static func create(from info: RocketInfo, context: NSManagedObjectContext) -> Rocket {
        let rocket = Rocket(context: context)
        rocket.rocketID = Int16(info.id)
        rocket.configurationID = Int16(info.configuration.id)
        rocket.name = info.configuration.name
        rocket.family = info.configuration.family
        rocket.variant = info.configuration.variant
        rocket.infoText = info.configuration.description
        return rocket
    }
    
}
