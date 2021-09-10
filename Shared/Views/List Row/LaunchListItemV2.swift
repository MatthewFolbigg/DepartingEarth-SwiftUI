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
    
    
//    var countdown: some View {
//        let countdown = Countdown(to: launch.date)
//        return
//            CountdownView(
//            countdown: countdown,
//            stopped: !launch.status.hasActiveCountdown,
//            backgroundColor: .app.backgroundAccented,
//            textColor: .white
//        )
//            .aspectRatio(CGSize(width: 9, height: 1), contentMode: .fit)
//            .fixedSize(horizontal: true, vertical: false)
//    }
    
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
    
    var pinIcon: some View {
        Group {
            if isPinned {
                LinearGradient(
                    gradient: Gradient(colors: [.app.textAccented.opacity(0.8), .app.textAccented]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(width: iconSize, height: iconSize)
                .mask(
                    Image(systemName: "pin.circle.fill")
                        .foregroundColor(.app.textAccented)
                        .font(.system(size: iconSize)))
            }
        }
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
