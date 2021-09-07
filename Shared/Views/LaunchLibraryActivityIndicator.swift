//
//  LaunchLibraryActivityIndicator.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 07/09/2021.
//

import SwiftUI

struct LaunchLibraryActivityIndicator: View {
    var body: some View {
        
        VStack {
            ProgressView()
                .padding(.top)
            Text("Updating Launches")
                .padding(.vertical)
                .font(.app.activityIndicator)
        }
        .frame(width: 250, height: 150, alignment: .center)
        .foregroundColor(.secondary)
        .background(
            Color.app.backgroundPrimary
                .opacity(0.9)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 5)
    }
}

struct LaunchLibraryActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        LaunchLibraryActivityIndicator()
    }
}
