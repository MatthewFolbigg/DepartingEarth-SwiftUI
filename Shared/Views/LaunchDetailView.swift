//
//  LaunchDetailView.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 04/08/2021.
//

import SwiftUI
import Combine

struct LaunchDetailView: View {
    
    @FetchRequest var fetchedLaunch: FetchedResults<Launch>
    @State var imageFetchCancellable: AnyCancellable?
    @State var logoImage: UIImage?
    var launch: Launch { fetchedLaunch.first! }
    
    init(launch: Launch) {
        _fetchedLaunch = FetchRequest(fetchRequest: Launch.requestForLaunch(withID: launch.launchID ?? ""))
    }
    
    var body: some View {
        VStack {
            if let logoImage = logoImage {
                Image(uiImage: logoImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 150)
                    .background(Color.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
            } else {
                Color.clear
                    .frame(width: 200, height: 150)
            }
            testTextStack
            Spacer()
        }
        .onAppear {
            //TODO: Dont do this every time, store the image and check if it already exists
            LaunchLibraryApiClient.shared.fetchImageData(
                url: URL(string: launch.provider?.logoUrl ?? ""),
                cancellable: $imageFetchCancellable) { image in
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.logoImage = image
                }
            }
        }
    }
    
    var testTextStack: some View {
        VStack {
            Text("\(launch.rocket?.family ?? "") : \(launch.rocket?.variant ?? "")")
                .fontWeight(.bold)
                .padding(.top)
            Text(launch.dateISO ?? "Unavailable")
                .fontWeight(.thin)
            Text("Window: \(launch.windowStart ?? "") : \(launch.windowEnd ?? "")")
                .fontWeight(.thin)
            Text("Weather: \(launch.weatherProbability)")
                .fontWeight(.thin)
            Text(launch.provider?.compactName ?? "Unavailable")
                .fontWeight(.bold)
                .padding(.top)
            Text(launch.provider?.type ?? "Unavailable")
                .fontWeight(.thin)
            Text(launch.status?.name ?? "Unavailable")
                .fontWeight(.bold)
                .padding(.top)
            Text(launch.status?.infoText ?? "Unavailable")
                .fontWeight(.thin)
        }
        .multilineTextAlignment(.center)
        .padding()
    }
        
}


//struct LaunchDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        LaunchDetailView()
//    }
//}
