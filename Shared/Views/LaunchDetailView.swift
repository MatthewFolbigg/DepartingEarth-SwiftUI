//
//  LaunchDetailView.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 04/08/2021.
//

import SwiftUI
import Combine

struct LaunchDetailView: View {
    
    @State var launch: Launch
    
    @State var missionIsExpanded: Bool = false
    
    init(launch: Launch) {
        self.launch = launch
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Spacer()
                    countdown
                        .aspectRatio(CGSize(width: 11, height: 1), contentMode: .fit)
                        .font(.system(.body, design: .default))
                    Spacer()
                }
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
                title: { Text("\(launch.rocket?.name ?? "") - \(launch.rocket?.variant ?? "") ") },
                icon: { Image(systemName: "airplane") }
            )
            Label(
                title: { Text(launch.mission?.type ?? "") },
                icon: { Image(systemName: "shippingbox") }
            )
            Label(
                title: { Text(launch.mission?.orbit?.name ?? "") },
                icon: { Image(systemName: "circle.dashed") }
            )
            Spacer()
            if missionIsExpanded {
                Text(launch.mission?.infoText ?? "").font(.system(.body)).fontWeight(.thin)
                    .foregroundColor(.primary)
                    .transition(.asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity.animation(.easeInOut.delay(0.2))),
                        removal: .move(edge: .top).combined(with: .opacity.animation(.easeInOut(duration: 0.05)))
                    )
                )
            }
        }
            .foregroundColor(.ui.greyBlueForeground)
        }
        .padding(20)
        .background(Color.ui.greyBlueBackground.clipShape(RoundedRectangle(cornerRadius: 20)).opacity(0.5))
        .animation(.easeOut)
    }
    
    
        
//    @State var imageFetchCancellable: AnyCancellable?
//    LaunchLibraryApiClient.shared.fetchImageData(
//        url: URL(string: launch?.provider?.logoUrl ?? ""),
//        cancellable: $imageFetchCancellable) { image in
//        withAnimation(.easeInOut(duration: 0.2)) {
//            self.logoImage = image
//        }
//    }
    
}




struct LaunchDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let launch = PersistenceController.testData()
        LaunchDetailView(launch: launch)
            .previewDevice("iPhone 12")
    }
}
