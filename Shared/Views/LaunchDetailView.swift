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
        
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Spacer()
                    countdown
                        .aspectRatio(CGSize(width: 11, height: 1), contentMode: .fit)
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
        .background(Color.app.backgroundPlain.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline) //TODO: Not available on MacOS
        .navigationTitle(launch.mission?.name ?? "Flight")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(
                    action: { withAnimation { pinned.togglePin(for: launch) } },
                    label: { Label("Pinned", systemImage: isPinned ? "pin.circle.fill" : "pin.circle") }
                )
            }
        }
    }
    
    var countdown: some View {
        CountdownView(
            countdown: launch.countdown,
            stopped: !launch.status.hasActiveCountdown,
            backgroundColor: .app.backgroundAccented,
            textColor: .white
        )
    }
    
    var statusSection: some View {
        //TODO: If on hold add hold reason
        //TODO: Window Start Window End timeline
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Status").font(.app.sectionTitle)
                Spacer()
            }
            Label(launch.status.name, systemImage: launch.status.iconName)
            Label(launch.dateString(), systemImage: "calendar")
            Text(launch.status.infoText ?? "")
                .font(.app.sectionCaption)
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
        }
        .font(.app.sectionDefault)
        .groupedSectionStyle()
    }
    
    var missionSection: some View {
        HStack {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Mission")
                    .font(.app.sectionTitle)
                Spacer()
                Image(systemName: "ellipsis.circle")
                    .rotationEffect(Angle(degrees: missionIsExpanded ? 90 : 0))
                    .scaleEffect(missionIsExpanded ? 1.2 : 1)
                    .foregroundColor(missionIsExpanded ? .app.control : .app.control)
            }
            Label(launch.provider?.compactName ?? "", systemImage: "person.2")
            Label(launch.rocket?.name ?? "", systemImage: "airplane")
            Label(launch.mission?.type ?? "", systemImage: launch.mission?.symbolForType ?? "")
            Label(launch.mission?.orbit?.name ?? "", systemImage: "circle.dashed")
            
            if missionIsExpanded {
                Spacer()
                Text(launch.mission?.infoText ?? "")
                    .font(.app.sectionParagraph)
                    //TODO: improve transition. currently overlaps other text on rapid press
                    .transition(.asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity.animation(.easeInOut.delay(0.2))),
                        removal: .move(edge: .top).combined(with: .opacity.animation(.easeInOut(duration: 0.05)))
                    )
                )
            }
        }
        }
        .font(.app.sectionDefault)
        .groupedSectionStyle()
    }
    
}





struct LaunchDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let launch = PersistenceController.testData()
        LaunchDetailView(launch: launch)
            .environmentObject(PinnedLaunches.shared)
            .previewDevice("iPhone 12")
    }
}
