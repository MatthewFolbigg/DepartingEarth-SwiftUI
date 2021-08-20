//
//  CustomList.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 19/08/2021.
//

import Foundation

struct CustomList {
    
    var launchIDs: [String]
    var name: String
    
    init(name: String) {
        self.name = name
        self.launchIDs = UserDefaults.standard.stringArray(forKey: name) ?? []
    }
    
    mutating func togglePin(launch: Launch) {
        if let idToToggle = launch.launchID {
            if isPinned(launchID: idToToggle) {
                removeFromPinned(launch: launch)
            } else {
                addToPinned(launch: launch)
            }
        }
    }
    
    private mutating func addToPinned(launch: Launch) {
        if let newID = launch.launchID {
            self.launchIDs.append(newID)
            save()
        } else {
            print("Error: Could not pin due to nil LaunchID")
        }
    }
    
    private mutating func removeFromPinned(launch: Launch) {
        if let removeID = launch.launchID {
            self.launchIDs.removeAll(where: ( { $0 == removeID } ))
            save()
        }
    }
    
    func isPinned(launchID: String) -> Bool {
        if self.launchIDs.contains(launchID) {
            return true
        } else {
            return false
        }
    }
    
    //MARK: - Persistance
    private func save() {
        UserDefaults.standard.setValue(launchIDs, forKey: name)
    }
}

