//
//  LaunchListItemV2.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 09/09/2021.
//

import SwiftUI

struct LaunchListItemViewV2: View {
    
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
                    if pinned.isPinned(launch) {
                        trackingIcon
                    }
                    Spacer()
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
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .frame(maxWidth: 80, maxHeight: 60)
                .foregroundColor(.app.backgroundAccented)
            
            if launch.status.hasActiveCountdown {
                VStack(alignment: .center) {
                    let countdownElements = firstNonZero(components: launch.countdown.componentInts)
                    Text("\(countdownElements.0 ? "-" : "+")\(String(countdownElements.1))")
                        .font(.system(size: 20, weight: .black, design: .monospaced))
                    Text(countdownElements.2)
                        .font(.system(size: 12, weight: .semibold, design: .default))
                }
                .onReceive(timer) { _ in
                    launch.countdown.updateComponents()
                }
                .foregroundColor(.white)
            } else {
                VStack(alignment: .center) {
                    Image(systemName: launch.status.iconName)
                        .imageScale(.large)
                }
                .foregroundColor(.white)
            }
        }
    }

    //TODO: Refactor this to countdown
    func firstNonZero(components: CountdownComponentInts) -> (Bool, Int, String) {
        guard components.days == 0 else { return (components.minus, components.days, "Days") }
        guard components.hours == 0 else { return (components.minus,components.hours, "Hours") }
        guard components.minutes == 0 else { return (components.minus,components.minutes, "Mins") }
        guard components.seconds == 0 else { return (components.minus,components.seconds, "Secs") }
        return (true, 0, "Launch!")
    }
    
    var trackingIcon: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundColor(.app.statusOrange)
            Text("Tracking")
                .foregroundColor(.white)
                .font(.system(size: 12, weight: .semibold, design: .default))
        }
        .frame(maxWidth: 80, maxHeight: 22)
    }
    
    var statusIcon: some View {
        LinearGradient(
            gradient: launch.status.gradient,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .frame(width: iconSize, height: iconSize)
        .mask(
            Image(systemName: launch.status.iconName)
                .font(.system(size: iconSize))
        )
    }
    
}

struct LaunchListItemV2_Previews: PreviewProvider {
    static var previews: some View {
        let launch = PersistenceController.testData()
        List {
            LaunchListItemViewV2(launch: launch)
            .environmentObject(PinnedLaunches.shared)
            
        }
        .listStyle(PlainListStyle())
        .previewDevice("iPhone 12 pro")
//        .preferredColorScheme(.dark)
    }
}
