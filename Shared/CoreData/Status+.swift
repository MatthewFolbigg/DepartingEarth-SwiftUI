//
//  Status+.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 04/08/2021.
//

import SwiftUI
import CoreData

extension Status {
    
    // 1 - Go - Current T-0 confirmed by official or reliable sources.
    // 2 - To Be Determined - Current date is a 'No Earlier Than' estimation based on unreliable or interpreted sources.
    // 3 - Launch Successful - The launch vehicle successfully inserted its payload(s) into the target orbit(s).
    // 4 - Launch Failure - Either the launch vehicle did not reach orbit, or the payload(s) failed to separate.
    // 5 - On Hold
    // 6 - In Flight
    // 7 - Partial Failure
    // 8 - To Be Confirmed - Awaiting official confirmation, current date is known with some certainty.
    
    enum Situation: Int {
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
    
    var color: Color {
        switch self.currentSituation {
        case .go, .inFlight, .success: return Color.ui.statusGreen
        case .hold: return Color.ui.statusOrange
        case .dateUndetermined, .dateUnconfirmed: return Color.ui.statusYellow
        case .failure, .partialFailure: return Color.ui.statusRed
        }
    }
    
    static func create(from info: LaunchStatus, context: NSManagedObjectContext) -> Status {
        let status = Status(context: context)
        status.statusID = Int16(info.id)
        status.name = info.name
        status.abbreviation = info.abbrev
        status.infoText = info.description
        return status
    }
    
    static func requestForAll(ascending: Bool = true) -> NSFetchRequest<Status> {
        let request = NSFetchRequest<Status>(entityName: "Status")
        request.sortDescriptors = [NSSortDescriptor(key: "statusID", ascending: ascending)]
        return request
    }
}
