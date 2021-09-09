//
//  Countdown.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 05/08/2021.
//

import Foundation

class Countdown: ObservableObject {
    
    @Published var date: Date
    @Published var components: CountdownComponentStrings
    
    var isMinus: Bool { return components.minus == "-" }
    
    init(to date: Date) {
        self.date = date
        self.components = LaunchDateFormatter.countdownComponents(untill: date)
    }
    
    var minus: String { components.minus }
    var days: String { components.days }
    var hours: String { components.hours }
    var minutes: String { components.minutes }
    var seconds: String { components.seconds }
    
    func updateComponents() {
        components = LaunchDateFormatter.countdownComponents(untill: date)
    }
    
}
