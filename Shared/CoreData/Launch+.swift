//
//  Launch.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 02/08/2021.
//

import Foundation
import CoreData

extension Launch {
    
    //MARK: - Convienience Varibales
    var name: String {
        get { self.name_ ?? "" }
        set { self.name_ = newValue }
    }
    
    var countdown: Countdown { Countdown(to: date) }
    var hasLaunched: Bool {
        status.currentSituation == .success ||
        status.currentSituation == .failure ||
        status.currentSituation == .partialFailure ||
        status.currentSituation == .inFlight
    }
    
    var status: Status {
        //provides a default value in the event of a CoreData error. API will always return a status
        status_ ?? Status.create(from: Status.defaultStatusInfo, context: PersistenceController.shared.container.viewContext)
    }
    
    var date: Date {
        get {
            let dateFormatter = ISO8601DateFormatter()
            if dateISO == nil { print("nil date for \(name)") }
            let date = dateFormatter.date(from: dateISO ?? "2007-01-08T09:41:00Z")
            //TODO: Remove force unwrap
            return date!
        }
        set {
            let dateFormatter = ISO8601DateFormatter()
            let newDate = dateFormatter.string(from: newValue)
            self.dateISO = newDate
            try? self.managedObjectContext?.save()
        }
    }
    
    func dateString(compact: Bool = false, digitsOnly: Bool = false, digitSeperator: LaunchDateFormatter.Seperator = .forwardSlash) -> String {
        if digitsOnly {
            return LaunchDateFormatter.dateStringWithMonthDigit(for: date, seperator: digitSeperator)
        } else {
            return LaunchDateFormatter.dateStringWithMonthText(for: date, compact: compact)
        }
    }
    
    func timeString(withSeconds: Bool = false) -> String {
        LaunchDateFormatter.timeString(for: date, withSeconds: withSeconds)
    }
        
    //MARK: - Creation and Deletion
    @discardableResult
    static func create(from info: LaunchInfo, context: NSManagedObjectContext) -> Launch {
        let launch = Launch(context: context)
        launch.lastUpdated = Date()
        
        //Attributes
        launch.launchID = info.id
        launch.name_ = info.name
        launch.dateISO = info.noEarlierThan
        launch.windowStart = info.windowStart
        launch.windowEnd = info.windowEnd
        launch.weatherProbability = Int16(info.probability ?? -1)
        launch.holdReason = info.holdreason
        
        //Relationships
        launch.provider = Provider.create(from: info.launchServiceProvider, context: context)
        launch.rocket = Rocket.create(from: info.rocket, context: context)
        launch.status_ = Status.create(from: info.launchStatus, context: context)
        launch.pad = Pad.create(from: info.pad, context: context)
        if let missionInfo = info.mission { launch.mission = Mission.create(from: missionInfo, context: context) }
        return launch
    }
    
    static func deleteAll(from context: NSManagedObjectContext) {
        PersistenceController.deleteAll(entityName: "Launch", from: context)
    }
    
    //MARK: - Updates and managing data accuracy
    func delete(from context: NSManagedObjectContext, excludingPinned: Bool) {
        if PinnedLaunches.shared.isPinned(self) && excludingPinned {
            PinnedLaunches.shared.togglePin(for: self)
        }
        context.delete(self)
        print("Deleted: \(self.name) \(self.lastUpdated?.timeIntervalSinceNow ?? 0)")
    }
    
    func downloadUpdate() {
        if let updateID = self.launchID {
            LaunchLibraryApiClient.shared.fetchData(.launchID(updateID))
        }
    }
    
    static func checkMismatchedStatus(for launch: Launch, in context: NSManagedObjectContext) {
        // Used to update launches that are donwloaded pre-launch and then not updated post launch before they are removed from the upcoming launches endpoint

        if (launch.hasLaunched && launch.countdown.isMinus) || (!launch.hasLaunched && !launch.countdown.isMinus) {
            // Countdown or Status is incorrect and needs to be updated
            print("A status/countdown mismatch was found: \(launch.launchID!)")
            print("Downloading Update for: \(launch.name)")
            launch.downloadUpdate()
        }
    }
    
    static func removeStale(from context: NSManagedObjectContext) {
        //Called after an LaunchLibrary update to remove data for future launches that have been cancelled/removed from the upcoming endpoint
        let ageOfStaleInSeconds: Double = 1800 //1800 seconds = 30 minutes
        let request = requestForAll()
        
        if let launches = try? context.fetch(request) {
            for launch in launches {
                
                if PinnedLaunches.shared.isPinned(launch) {
                    //Prevents the removal of a pinned launch but makes sure it has/will get a final status/countdown
                    //TODO: this has the potential to break the API rate limit if many launches are pinned
                    checkMismatchedStatus(for: launch, in: context)
                } else {
                    //Removes non pinned launches that havent been including in a recent LLAPI respone
                    if launch.lastUpdated?.timeIntervalSinceNow ?? (ageOfStaleInSeconds * -1) <= (ageOfStaleInSeconds * -1) {
                        launch.delete(from: context, excludingPinned: true)
                    }
                }
            }
        }
        try? context.save()
    }
    
    static func removeOld(from context: NSManagedObjectContext) {
        //Removes data for past launches older than the maximumTimeSinceLaunch
        //TODO: If possible set this time to automatially align with the number of previous launches fetched from the API
        let maximumTimeSinceLaunch: Double = 604800 // 604800 seconds = 7 Days
        let request = requestForAll()
        
        if let launches = try? context.fetch(request) {
            for launch in launches {
                if launch.date.timeIntervalSinceNow <= (maximumTimeSinceLaunch * -1) {
                    launch.delete(from: context, excludingPinned: true)
                    print("Deleted: \(launch.name) \(launch.lastUpdated?.timeIntervalSinceNow ?? 0)")
                }
            }
        }
        try? context.save()
    }
    
    //MARK: - Request Methods
    enum SortOption: String {
        case name = "name_"
        case date = "dateISO"
    }
    
    static func requestForAll(sortBy: SortOption = .date, ascending: Bool = true, predicates: [NSPredicate] = []) -> NSFetchRequest<Launch> {
        let request = NSFetchRequest<Launch>(entityName: "Launch")
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = [NSSortDescriptor(key: sortBy.rawValue, ascending: ascending)]
        request.predicate = predicate
        return request
    }
    
    static func requestForLaunch(withID id: String) -> NSFetchRequest<Launch> {
        let request = NSFetchRequest<Launch>(entityName: "Launch")
        request.sortDescriptors = [NSSortDescriptor(key: SortOption.name.rawValue, ascending: true)]
        request.predicate = NSPredicate(format: "launchID == %@", id)
        return request
    }
    
    static func requestForLaunch(withIDs ids: [String]) -> NSFetchRequest<Launch> {
        let request = NSFetchRequest<Launch>(entityName: "Launch")
        request.sortDescriptors = [NSSortDescriptor(key: SortOption.name.rawValue, ascending: true)]
        request.predicate = NSPredicate(format: "launchID IN %@", ids)
        return request
    }
    
    //MARK: - Entity Info/Stats
    static func count(in context: NSManagedObjectContext) -> Int {
        if let count = try? context.count(for: NSFetchRequest(entityName: "Launch")) {
            print("CoreData Launch count: \(count)")
            return count
        } else {
            return 0
        }
    }
        
}
