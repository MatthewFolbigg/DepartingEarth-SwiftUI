//
//  Departing_EarthApp.swift
//  Shared
//
//  Created by Matthew Folbigg on 02/08/2021.
//

import SwiftUI

@main
struct Departing_EarthApp: App {
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            let launchList = UpcomingLaunchList()
            UpcomingLaunchesView(launchList: launchList)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
