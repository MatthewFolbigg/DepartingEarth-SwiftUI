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
            provider
            rocket
                .padding(.bottom, 5)
            if launch.mission != nil {
                type
                mission
            }
            Spacer()
            HStack(alignment: .bottom) {
                countdown
                Spacer()
//                date
            }
        }

    }
    
    //MARK: - Main Section
    var provider: some View {
        Text(launch.provider?.compactName ?? "")
            .fontWeight(.heavy)
            .font(.system(.title2, design: .monospaced))
            .foregroundColor(.ui.greyBlueAccent)
            .lineLimit(1)
    }
    
    var rocket: some View {
        Text(launch.rocket?.name ?? "")
            .fontWeight(.semibold)
            .font(.system(.title3, design: .monospaced))
            .foregroundColor(.ui.deepOrangeAccent)
            .lineLimit(1)
            .minimumScaleFactor(0.6)
    }
    
    var mission: some View {
        Text(launch.mission?.name ?? "")
            .fontWeight(.regular)
            .font(.system(.body, design: .monospaced))
            .foregroundColor(.primary)
            .lineLimit(2)
            .minimumScaleFactor(0.8)
    }
    
    var type: some View {
        Text(launch.mission?.type ?? "")
            .fontWeight(.bold)
            .font(.system(.body, design: .monospaced))
            .foregroundColor(.primary)
            .lineLimit(2)
            .minimumScaleFactor(0.8)
    }
    
    //MARK: - Countdown Section
    var countdown: some View {
        VStack(alignment: .leading, spacing: 5) {
            CountdownView(
                countdown: Countdown(to: launch.date),
                stopped: launch.status?.currentSituation.noCountdown ?? true,
                color: Color.ui.greyBlueBackground,
                textColor: Color.ui.greyBlueForeground)
                .frame(maxHeight: 25)
        }
    }
    
    //MARK: - Status Section
    var date: some View {
        VStack(alignment: .trailing, spacing: 5) {
            Spacer()
            HStack {
                Text(launch.status?.abbreviation ?? "")
                    .fontWeight(.regular)
                    .font(.system(.body, design: .rounded))
                Text(Image(systemName: "circle.fill"))
                    .foregroundColor(launch.status?.color)
                    .padding(.bottom, 1.5)
            }
            Text(LaunchDateFormatter.dateStringWithMonthText(for: launch.date, compact: true))
                .font(.system(.caption, design: .default))
                .fontWeight(.light)
            Spacer()
        }
    }
    
    
    
}



//MARK: - Previews
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

