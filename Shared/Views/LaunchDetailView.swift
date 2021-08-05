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
        Text(launch.name)
    
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
