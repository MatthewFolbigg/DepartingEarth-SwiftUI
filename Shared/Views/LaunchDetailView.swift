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
    
    init(launch: Launch) {
        self.launch = launch
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Spacer()
                    CountdownView(countdown: Countdown(to: launch.date), color: .clear, textColor: launch.status?.color ?? .gray)
                        .frame(maxWidth: 220)
                    Spacer()
                }
                statusSection
                weatherSection
                missionSection
                padSection
                Spacer()
            }
            .padding(25)
        }
        .navigationTitle(launch.mission?.name ?? "Flight")
    }
    
    var missionSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Mission").font(.title2).fontWeight(.medium)
            Label(
                title: { Text(launch.provider?.compactName ?? "") },
                icon: { Image(systemName: "person.2").foregroundColor(.blue) }
            )
            Label(
                title: { Text("\(launch.rocket?.name ?? "") - \(launch.rocket?.variant ?? "") ") },
                icon: { Image(systemName: "airplane").foregroundColor(.blue) }
            )
            Label(
                title: { Text(launch.mission?.type ?? "") },
                icon: { Image(systemName: "shippingbox").foregroundColor(.blue) }
            )
            Label(
                title: { Text(launch.mission?.orbit?.name ?? "") },
                icon: { Image(systemName: "circle.dashed").foregroundColor(.blue) }
            )
            Text(launch.mission?.infoText ?? "").font(.system(.body)).fontWeight(.thin)
                .padding(.horizontal)
                .foregroundColor(.primary)
        }
    }

    var statusSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Status").font(.title2).fontWeight(.medium)
            Label(
                title: { Text(launch.status?.name ?? "") },
                icon: { Image(systemName: "circle.fill").foregroundColor(launch.status?.color) }
            )
            Label(
                title: { Text(launch.dateString(compact: true)) },
                icon: { Image(systemName: "calendar").foregroundColor(.red) }
            )
            Label(
                title: { Text(launch.timeString()) },
                icon: { Image(systemName: "clock").foregroundColor(.blue) }
            )
            Text(launch.status?.infoText ?? "").font(.system(.caption))
                .foregroundColor(.secondary)
        }
    }
    
    var weatherSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Weather").font(.title2).fontWeight(.medium)
            Label(
                title: { Text("\(launch.weatherProbability)%") },
                icon: { Image(systemName: "cloud.sun").foregroundColor(.blue) }
            )
            Text("Chance of favourable weather").font(.system(.caption))
                .foregroundColor(.secondary)
        }
    }
    
    var padSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Pad").font(.title2).fontWeight(.medium)
            Label(
                title: { Text("\(launch.pad?.name ?? "")") },
                icon: { Image(systemName: "diamond").foregroundColor(.blue) }
            )
            Label(
                title: { Text("\(launch.pad?.locationName ?? "")") },
                icon: { Image(systemName: "map").foregroundColor(.blue) }
            )
//            Text("Chance of favourable weather").font(.system(.caption))
//                .foregroundColor(.secondary)
        }
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
