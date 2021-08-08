//
//  LaunchListItemView.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 03/08/2021.
//

import SwiftUI

struct LaunchListItemView: View {
    
    @State var launch: Launch
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(launch: Launch) {
        self.launch = launch
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(launch.mission?.name ?? "")
                .font(.system(.subheadline, design: .default))
                .fontWeight(.light)
                .lineLimit(1)
            Text(launch.provider?.compactName ?? "")
                .font(.system(.headline, design: .monospaced))
                .fontWeight(.semibold)
                .lineLimit(1)
            Text(launch.rocket?.name ?? "")
                .font(.system(.subheadline, design: .default))
                .fontWeight(.semibold)
                .foregroundColor(.orange)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text(launch.mission?.type ?? "")
                .font(.system(.caption, design: .default))
                .fontWeight(.light)
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 5) {
                    Spacer()
                    CountdownView(countdown: Countdown(to: launch.date))
                        .frame(maxWidth: 220)
                    Spacer()
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 5) {
                    Spacer()
                    Text(launch.status?.abbreviation ?? "")
                    Text(LaunchDateFormatter.dateStringWithMonthText(for: launch.date, compact: true))
                        .font(.system(.caption, design: .default))
                        .fontWeight(.light)
                    Spacer()
                }
            }
        }
    }
    
}

struct LaunchListItemView_Previews: PreviewProvider {
    static var previews: some View {
        let launch = PersistenceController.testData()
        List {
            LaunchListItemView(launch: launch)
            LaunchListItemView(launch: launch)
            LaunchListItemView(launch: launch)
            LaunchListItemView(launch: launch)
        }
        .previewDevice("iPhone 12 pro")
    }
}

