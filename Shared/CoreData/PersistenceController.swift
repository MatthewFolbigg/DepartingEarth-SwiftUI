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
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        //Test Data
        for _ in 0..<10 {
            let newItem = Launch(context: viewContext)
            newItem.provider = "Rocket Company X"
            newItem.name = "Big Fx Rocket"
        }
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    //MARK:-

}
