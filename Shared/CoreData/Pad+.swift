//
//  Pad+.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 05/08/2021.
//

import Foundation
import CoreData

extension Pad {
    static func create(from info: PadInfo, context: NSManagedObjectContext) -> Pad {
        let pad = Pad(context: context)
        pad.padID = Int16(info.id)
        pad.name = info.name
        pad.latitude = info.latitude
        pad.longitude = info.longitude
        pad.locationName = info.location.name
        pad.countryCode = info.location.countryCode
        return pad
    }
    
}
