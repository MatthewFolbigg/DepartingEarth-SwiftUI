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
    var compactName: String {
        if let name = name, let abbreviation = abbreviation {
            return (name.count) < 25 ? name : abbreviation
        } else {
            return "Unknown"
        }
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
    
    static func providerFor(name: String, context: NSManagedObjectContext) -> Provider? {
        if let allProviders = try? context.fetch(requestForAll()) {
            return allProviders.first(where: { $0.name == name } )
        } else {
            return nil
        }
    }
    
    static func requestForAll(ascending: Bool = true) -> NSFetchRequest<Provider> {
        let request = NSFetchRequest<Provider>(entityName: "Provider")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: ascending)]
        return request
    }
    
  

}
