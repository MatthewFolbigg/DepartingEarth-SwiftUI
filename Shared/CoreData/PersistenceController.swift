//
//  Persistence.swift
//  Shared
//
//  Created by Matthew Folbigg on 02/08/2021.
//

import CoreData

struct PersistenceController {
    let container: NSPersistentContainer
    static let shared = PersistenceController()

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Departing_Earth")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    //MARK: - Helper Methods
    static func deleteAll(entityName: String, from context: NSManagedObjectContext) {
        let request: NSFetchRequest<NSFetchRequestResult>
        request = NSFetchRequest(entityName: entityName)
        let batchDelete = NSBatchDeleteRequest(fetchRequest: request)
        batchDelete.resultType = .resultTypeObjectIDs
        do {
            let delete = try context.execute(batchDelete) as? NSBatchDeleteResult
            if let deleteResult = delete?.result as? [NSManagedObjectID] {
                let changes: [AnyHashable: Any] = [NSDeletedObjectsKey : deleteResult]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
            }
        } catch {
            //TODO: Handle Error
            print("Error Deleting Launches")
        }
    }
    
    //MARK:- Preview Controller
//    static var preview: PersistenceController = {
//        let result = PersistenceController(inMemory: true)
//        let viewContext = result.container.viewContext
//        
//        //Test Data
//        for i in 0..<15 {
//            let info = LaunchInfo(id: String(i), name: "Launching A Rocket \(i)", launchStatus: LaunchStatus(id: 1, name: "Go", description: "Status Des"), noEarlierThan: "\(i)-0\(i)-0\(i)0\(i)T0\(i):0\(i):0\(i)Z", windowStart: "Window Start", windowEnd: "Window End", inhold: false, tbdtime: false, tbddate: false, holdreason: "Holding Reason", failreason: "Fail", launchServiceProvider: providerInfo(id: i, name: "Rocket Company X", abbreviation: "RCX", logoUrl: nil, type: nil, countryCode: "USA", description: "Info"), rocket: RocketInfo(configuration: ConfigurationInfo(name: "Big Fx Rocket", family: "Big Rockets", variant: "Fx")), mission: nil, pad: PadInfo(id: i, name: "A Pad", latitude: "Lat", longitude: "Long", location: PadLocationInfo(name: "Pad Loc Name")), probability: 50)
//            Launch.create(from: info, context: viewContext)
//        }
//        
//        do {
//            try viewContext.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//        return result
//    }()
    
    //MARK:- Test Data
    static func testData(context: NSManagedObjectContext) -> Launch {
        let info = LaunchInfo(
            id: "testLaunchID",
            name: "A Big Rocket",
            launchStatus: LaunchStatus(
                id: 2,
                name: "To Be Determined",
                abbrev: "TBD",
                description: "Current date is a 'No Earlier Than' estimation based on unreliable or interpreted sources."),
            noEarlierThan: "2021-09-30T00:00:00Z",
            windowStart: "2021-09-30T00:00:00Z",
            windowEnd: "2021-09-30T00:00:00Z",
            holdreason: "No Hold Reason",
            failreason: "No Fail Reason",
            launchServiceProvider: providerInfo(
                id: 10,
                name: "Rocket Company",
                abbreviation: "Rckt Cmpny",
                logoUrl: nil,
                type: "Test Company",
                countryCode: "UK",
                description: "A company that makes very large rockets"),
            rocket: RocketInfo(
                id: 10,
                configuration: ConfigurationInfo(
                    id: 10,
                    name: "A Big Rocket",
                    family: "The Biggens",
                    variant: "Big",
                    description: "A very large rocket")),
            mission: nil,
            pad: PadInfo(
                id: 10,
                name: "A remote pad",
                latitude: "100",
                longitude: "100",
                location: PadLocationInfo(name: "United Kingdom", countryCode: "UK")),
            probability: 50)
        return Launch.create(from: info, context: context)
    }


}
