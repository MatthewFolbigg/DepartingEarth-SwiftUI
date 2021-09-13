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
                VStack() {
                    countdownComponent
                    Spacer()
                    if pinned.isPinned(launch) {
                        //TODO: This is a plcehold icon pinned
                        Text("\(Image(systemName: "pin.fill")) Tracking")
                            .font(.app.rowElement)
                            .foregroundColor(.app.statusOrange)
                    }
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
            RoundedRectangle(cornerRadius: 10)
                .frame(maxWidth: 80, maxHeight: 60)
                .foregroundColor(.app.backgroundAccented)
            
            if launch.status.hasActiveCountdown {
                VStack(alignment: .trailing) {
                    let countdownElements = firstNonZero(components: launch.countdown.componentInts)
                    Text("\(countdownElements.0 ? "-" : "+")\(String(countdownElements.1))")
                    Text(countdownElements.2)
                }
                .onReceive(timer) { _ in
                    launch.countdown.updateComponents()
                }
                .font(.system(size: 17, weight: .black, design: .monospaced))
                .foregroundColor(.white)
            } else {
                Image(systemName: launch.status.iconName)
                    .imageScale(.large)
                    .foregroundColor(.white)
            }
        }
    }
    
    func firstNonZero(components: CountdownComponentInts) -> (Bool, Int, String) {
        guard components.days == 0 else { return (components.minus, components.days, "Days") }
        guard components.hours == 0 else { return (components.minus,components.hours, "Hours") }
        guard components.minutes == 0 else { return (components.minus,components.minutes, "Mins") }
        guard components.seconds == 0 else { return (components.minus,components.seconds, "Secs") }
        return (true, 0, "Launch!")
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
    
//    var pinIcon: some View {
//        Group {
//            if isPinned {
//                LinearGradient(
//                    gradient: Gradient(colors: [.app.textAccented.opacity(0.8), .app.textAccented]),
//                    startPoint: .topLeading,
//                    endPoint: .bottomTrailing
//                )
//                .frame(width: iconSize, height: iconSize)
//                .mask(
//                    Image(systemName: "pin.circle.fill")
//                        .foregroundColor(.app.textAccented)
//                        .font(.system(size: iconSize)))
//            }
//        }
//    }
    
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
