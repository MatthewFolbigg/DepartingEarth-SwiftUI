//
//  LaunchListItem.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 03/08/2021.
//

import SwiftUI

struct LaunchListItem: View {
    
    let launch: Launch
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(launch.provider!.name!)")
            Text("\(launch.name)")
                .fontWeight(.thin)
                .foregroundColor(.red)
            Text(string(for: launch.date))
                .fontWeight(.thin)
        }
    }
    
    func string(for date: Date) -> String {
        let calendar = Calendar.current
        let dayInt = calendar.component(.day, from: date)
        let yearInt = calendar.component(.year, from: date)
        let monthInt = calendar.component(.month, from: date)
        return "\(dayInt) / \(monthInt) / \(yearInt)"
    }
    
}
