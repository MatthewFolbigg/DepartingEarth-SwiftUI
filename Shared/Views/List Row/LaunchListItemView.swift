//
//  LaunchListItemV2.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 09/09/2021.
//

import SwiftUI

struct LaunchListItemView: View {
    
    @State var launch: Launch
    @EnvironmentObject var pinned: PinnedLaunches
    
    var isPinned: Bool { pinned.isPinned(launch) }
    var iconSize: CGFloat = 22
    var cornerRadius: CGFloat = 10
    
    var body: some View {
        VStack {
            HStack() {
                VStack(alignment: .leading, spacing: 0) {
                    providerName
                    rocketName
                    Spacer()
                    VStack(alignment: .leading, spacing: 5) {
                        missionName
                        date
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    countdownComponent
                    Spacer()
                    iconBar
                }
            }
        }
        .padding(.vertical, 10)
    }
    
    
    var providerName: some View {
        Text(launch.provider?.compactName ?? "")
            .font(.app.rowTitle)
            .foregroundColor(.app.textAccented)
    }
    
    var rocketName: some View {
        Text(launch.rocket?.name ?? "")
            .font(.app.rowSubtitle)
            .foregroundColor(.app.textPrimary)
    }
    
    var missionName: some View {
        let typeIcon = Image(systemName: launch.mission?.symbolForType ?? "questionmark.circle")
        return Text("\(typeIcon) \(launch.mission?.name ?? "Unknown")")
            .font(.app.rowElement)
            .foregroundColor(.app.textPrimary)
            .lineLimit(1)
            .tagStyle(color: .gray)
    }
    
    var date: some View {
        let calIcon = Image(systemName: "calendar")
        return Text("\(calIcon) \(launch.dateString(compact: true))")
            .font(.app.rowElement)
            .foregroundColor(.app.textPrimary)
            .lineLimit(1)
            .tagStyle(color: .gray)
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var countdownComponent: some View {
        VStack(alignment: .trailing) {
            
            let countdownElements = firstNonZero(components: launch.countdown.componentInts)
            let number = "\(countdownElements.0 ? "-" : "+")\(String(countdownElements.1))"
            
            Text(launch.status.hasActiveCountdown ? number : "--")
                .font(.system(size: 20, weight: .black, design: .monospaced))
            Text(launch.status.hasActiveCountdown ? countdownElements.2 : "Pending")
                .font(.system(size: 12, weight: .semibold, design: .default))
        }
        .onReceive(timer) { _ in
            launch.countdown.updateComponents()
        }
        .foregroundColor(.app.textAccented)
    }

    //TODO: Refactor this to countdown
    func firstNonZero(components: CountdownComponentInts) -> (Bool, Int, String) {
        guard components.days == 0 else { return (components.minus, components.days, "Days") }
        guard components.hours == 0 else { return (components.minus,components.hours, "Hours") }
        guard components.minutes == 0 else { return (components.minus,components.minutes, "Mins") }
        guard components.seconds == 0 else { return (components.minus,components.seconds, "Secs") }
        return (true, 0, "Launch!")
    }
    
    var iconBar: some View {
        VStack(alignment: .trailing, spacing: 4) {
            trackingIcon
            statusIcon
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.clear)//.app.backgroundAccented)
        )
    }
    
    var trackingIcon: some View {
        let icon = Image(systemName: "pin.circle.fill")
        return Text(pinned.isPinned(launch) ? "\(icon) Tracked" : "")
                .imageScale(.small)
                .font(.app.rowDetail)
                .foregroundColor(.app.tracked)
    }
    
    var statusIcon: some View {
        let icon = Image(systemName: launch.status.iconName)
        return Text("\(icon) \(launch.status.name)")
            .imageScale(.small)
            .font(.app.rowDetail)
            .foregroundColor(launch.status.color)
        
    }
    
}

struct LaunchListItemV2_Previews: PreviewProvider {
    static var previews: some View {
        let launch = PersistenceController.testData()
        List {
            LaunchListItemView(launch: launch)
            .environmentObject(PinnedLaunches.shared)
            
        }
        .listStyle(PlainListStyle())
        .previewDevice("iPhone 12 pro")
//        .preferredColorScheme(.dark)
    }
}
