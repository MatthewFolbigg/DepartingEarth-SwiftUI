//
//  LaunchDetailView.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 04/08/2021.
//

import SwiftUI
import Combine
import MapKit

struct LaunchDetailView: View {
    
    @EnvironmentObject var pinned: PinnedLaunches
    @State var launch: Launch
    @State var missionIsExpanded: Bool = false
    var isPinned: Bool { pinned.isPinned(launch) }
        
    init(launch: Launch) {
        self.launch = launch
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Spacer()
                    countdown
                        .aspectRatio(CGSize(width: 11, height: 1), contentMode: .fit)
                        .font(.system(.body, design: .default))
                        .scaleEffect(1.2)
                    Spacer()
                }
                statusSection
                missionSection
                    .onTapGesture {
                        withAnimation(.easeOut) {
                            missionIsExpanded.toggle()
                        }
                    }
                Spacer()
            }
            .padding(25)
        }
        .navigationTitle(launch.mission?.name ?? "Flight")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(
                    action: { withAnimation { pinned.togglePin(for: launch) } },
                    label: { Label("Pinned", systemImage: isPinned ? "pin.circle.fill" : "pin.circle") }
                )
            }
        }
    }
    
    var countdown: some View {
        CountdownView(
            countdown: Countdown(to: launch.date),
            stopped: launch.status?.currentSituation.noCountdown ?? true,
            backgroundColor: .ui.greyBlueBackground.opacity(0.5),
            textColor: .ui.greyBlueAccent,
            fontWeight: .bold
        )
    }
    
    var statusSection: some View {
        //TODO: If on hold add hold reason
        //TODO: Window Start Window End timeline
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Status").font(.title2).fontWeight(.medium)
                Spacer()
            }
            Label(
                title: { Text(launch.status?.currentSituation.name ?? "") },
                icon: { launch.status?.icon }
            )
            Label(
                title: { Text(launch.dateString()) },
                icon: { Image(systemName: "calendar") }
            )
            Text(launch.status?.infoText ?? "").font(.caption).fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
        }
        .foregroundColor(.ui.greyBlueForeground)
        .padding(20)
        .background(Color.ui.greyBlueBackground.clipShape(RoundedRectangle(cornerRadius: 20)).opacity(0.5))
    }
    
    var missionSection: some View {
        HStack {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Mission").font(.title2).fontWeight(.medium)
                Spacer()
                Image(systemName: "ellipsis.circle")
                    .rotationEffect(Angle(degrees: missionIsExpanded ? 90 : 0))
                    .scaleEffect(missionIsExpanded ? 1.2 : 1)
                    .foregroundColor(missionIsExpanded ? .ui.deepOrangeAccent : .ui.greyBlueForeground)
            }
            Label(
                title: { Text(launch.provider?.compactName ?? "") },
                icon: { Image(systemName: "person.2") }
            )
            Label(
                title: { Text(launch.rocket?.name ?? "")},
                icon: { Image(systemName: "airplane") }
            )
            Label(
                title: { Text(launch.mission?.type ?? "") },
                icon: { Image(systemName: launch.mission?.symbolForType ?? "") }
            )
            Label(
                title: { Text(launch.mission?.orbit?.name ?? "") },
                icon: { Image(systemName: "circle.dashed") }
            )
            if missionIsExpanded {
                Spacer()
                Text(launch.mission?.infoText ?? "").font(.system(.body)).fontWeight(.thin)
                    .foregroundColor(.primary)
                    //TODO: improve transition. currently overlaps other text on rapid press
                    .transition(.asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity.animation(.easeInOut.delay(0.2))),
                        removal: .move(edge: .top).combined(with: .opacity.animation(.easeInOut(duration: 0.05)))
                    )
                )
            }
        }
        }
        .foregroundColor(.ui.greyBlueForeground)
        .padding(20)
        .background(Color.ui.greyBlueBackground.clipShape(RoundedRectangle(cornerRadius: 20)).opacity(0.5))
    }
    
}



struct LaunchDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let launch = PersistenceController.testData()
        LaunchDetailView(launch: launch)
            .previewDevice("iPhone 12")
    }
}
