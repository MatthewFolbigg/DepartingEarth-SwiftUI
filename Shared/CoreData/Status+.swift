//
//  Status+.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 04/08/2021.
//

import SwiftUI
import CoreData

extension Status {
    
    //MARK: - Status Cases
    // 1 - Go - Current T-0 confirmed by official or reliable sources.
    // 2 - To Be Determined - Current date is a 'No Earlier Than' estimation based on unreliable or interpreted sources.
    // 3 - Launch Successful - The launch vehicle successfully inserted its payload(s) into the target orbit(s).
    // 4 - Launch Failure - Either the launch vehicle did not reach orbit, or the payload(s) failed to separate.
    // 5 - On Hold
    // 6 - In Flight
    // 7 - Partial Failure
    // 8 - To Be Confirmed - Awaiting official confirmation, current date is known with some certainty.
    //404 - Custom, local to App not from API - To provide a default value in the event of a nil status relationship
        
    enum Situation: Int, CaseIterable {
        case go = 1
        case dateUndetermined = 2
        case success = 3
        case failure = 4
        case hold = 5
        case inFlight = 6
        case partialFailure = 7
        case dateUnconfirmed = 8
    }
    
    var currentSituation: Situation { Situation(rawValue: Int(statusID)) ?? .dateUndetermined }
    
    var name: String {
        switch self.currentSituation {
        case .go : return "Go for Launch"
        case .success : return "Departed"
        case .failure : return "Failed"
        case .partialFailure : return "Departed*"
        case .hold : return "Holding"
        case .inFlight : return "In Flight"
        case .dateUnconfirmed : return "Preparing"
        case .dateUndetermined: return "Awaiting Info"
        }
    }
    
    var hasActiveCountdown: Bool {
        switch self.currentSituation {
        case .go, .success, .inFlight, .partialFailure, .dateUnconfirmed: return true
        case .failure, .hold, .dateUndetermined: return false
        }
    }
    
    var color: Color {
        switch self.currentSituation {
        case .go, .inFlight, .success: return Color.app.statusGreen
        case .hold: return Color.app.statusOrange
        case .dateUndetermined: return Color.gray
        case .dateUnconfirmed: return Color.app.statusYellow
        case .failure, .partialFailure: return Color.app.statusRed
        }
    }
    
    //TODO: Confirm Icons
    var iconName: String {
        switch self.currentSituation {
        case .success: return "checkmark.circle.fill"
        case .inFlight: return "paperplane.circle.fill"
        case .failure, .partialFailure: return "xmark.circle.fill"
        case .go : return "circle.fill"
        case .dateUnconfirmed : return "circle.lefthalf.fill"
        case .dateUndetermined: return "circle"
        case .hold: return "pause.circle.fill"
        }
    }
    
    var gradient: Gradient {
        //TODO: Confirm all colours
        switch self.currentSituation {
        case .go : return Gradient(colors: [.app.statusGreen, .app.statusGreenDark])
        case .success : return Gradient(colors: [.app.statusGreen, .app.statusGreenDark])
        case .failure : return Gradient(colors: [.app.statusRed, .app.statusRedDark])
        case .partialFailure : return Gradient(colors: [.app.statusRed, .app.statusGreen])
        case .hold : return Gradient(colors: [.app.statusYellow, .app.statusGreen])
        case .inFlight : return Gradient(colors: [.app.statusGreen, .orange])
        case .dateUnconfirmed : return Gradient(colors: [.app.statusGreen, .app.statusGreenDark])
        case .dateUndetermined: return Gradient(colors: [.app.textAccented])
        }
    }
    
    //MARK: Creation and Fetch Requests
    static func create(from info: LaunchStatus, context: NSManagedObjectContext) -> Status {
        let status = Status(context: context)
        status.statusID = Int16(info.id)
        status.name_ = info.name
        status.abbreviation = info.abbrev
        status.infoText = info.description
        return status
    }
     
    static var defaultStatusInfo: LaunchStatus { LaunchStatus(id: 404, name: "Unknown", abbrev: "N/A", description: "No status information is currently available") }
    
    //MARK:- Filtering
    enum Filter: String, CaseIterable {
        case departed = "Departed"
        case failed = "Failed"
        case goForLaunch = "Go For Launch"
        case preparing = "Preparing"
        case unconfirmed = "Unconfirmed"
    }
    
    static func predicateFor(filter: Filter) -> NSCompoundPredicate {
        switch filter {
        case .departed:
            return NSCompoundPredicate(orPredicateWithSubpredicates: [
                NSPredicate(format: "status_.statusID == %i", 3),
                NSPredicate(format: "status_.statusID == %i", 6),
                NSPredicate(format: "status_.statusID == %i", 7)
            ])
        case .failed:
            return NSCompoundPredicate(orPredicateWithSubpredicates: [
                NSPredicate(format: "status_.statusID == %i", 4),
                NSPredicate(format: "status_.statusID == %i", 7)
            ])
        case .preparing:
            return NSCompoundPredicate(orPredicateWithSubpredicates: [
                NSPredicate(format: "status_.statusID == %i", 8),
                NSPredicate(format: "status_.statusID == %i", 5)
            ])
        case .goForLaunch: return NSCompoundPredicate(orPredicateWithSubpredicates: [NSPredicate(format: "status_.statusID == %i", 1)])
        case .unconfirmed: return NSCompoundPredicate(orPredicateWithSubpredicates: [NSPredicate(format: "status_.statusID == %i", 2)])
        }
    }
}
