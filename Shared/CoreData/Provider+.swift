//
//  Provider+.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 03/08/2021.
//

import Foundation
import CoreData

extension Provider {
    
    //MARK: - Convienience Varibales
    var compactName: String? {
        (name?.count ?? 12) < 25 ? name : abbreviation
    }
    
    //MARK: - Helper Methods
    @discardableResult
    static func create(from info: providerInfo, context: NSManagedObjectContext) -> Provider {
        let provider = Provider(context: context)
        provider.providerID = Int16(info.id)
        provider.name = info.name
        provider.abbreviation = info.abbreviation
        provider.type = info.type
        provider.logoUrl = info.logoUrl
        provider.countryCode = info.countryCode
        provider.infoText = info.description
        return provider
    }
    
    static func requestForAll(ascending: Bool = true) -> NSFetchRequest<Provider> {
        let request = NSFetchRequest<Provider>(entityName: "Provider")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: ascending)]
        return request
    }
    
}
