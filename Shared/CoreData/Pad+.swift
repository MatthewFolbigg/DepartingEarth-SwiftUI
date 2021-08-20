//
//  Pad+.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 05/08/2021.
//

import Foundation
import CoreData
import MapKit

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
    
    var locationCoordinate: CLLocationCoordinate2D {
        let latDouble = Double(latitude!) ?? 0
        let longDouble = Double(longitude!) ?? 0
        print(latDouble)
        print(longDouble)
        let lat = CLLocationDegrees(latDouble)
        let long = CLLocationDegrees(longDouble)
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
}
