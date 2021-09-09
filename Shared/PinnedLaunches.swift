//
//  PinnedLaunches.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 19/08/2021.
//

import Foundation
import SwiftUI

class PinnedLaunches: ObservableObject {
    
    @Published private(set) var model = CustomList(name: "PinnedLaunches")
    
    static var shared = PinnedLaunches()
    
    var launchIDs: [String] { model.launchIDs }
    
    func togglePin(for launch: Launch) {
        model.togglePin(launch: launch)
    }
    
    func isPinned(_ launch: Launch) -> Bool {
        if let id = launch.launchID {
            return model.isPinned(launchID: id)
        } else {
            return false
        }
    }
    
}
