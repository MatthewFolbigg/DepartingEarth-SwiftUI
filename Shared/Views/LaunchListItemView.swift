//
//  LaunchListItemView.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 03/08/2021.
//

import SwiftUI

struct LaunchListItemView: View {
    
    @State var launch: Launch
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(launch: Launch) {
        self.launch = launch
    }
    
    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 5) {
                Text(launch.provider?.compactName ?? "")
                    .font(.system(.headline, design: .monospaced))
                    .fontWeight(.semibold)
                Text(launch.rocket?.name ?? "")
                    .font(.system(.subheadline, design: .monospaced))
                    .fontWeight(.semibold)
                    .truncationMode(.tail)
                    .foregroundColor(.orange)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                Text(launch.provider?.type ?? "")
                    .font(.system(.caption, design: .default))
                    .fontWeight(.light)
                Spacer()
                CountdownView(countdown: Countdown(to: launch.date))
                    .frame(maxHeight: 30)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 5) {
                Spacer()
                Text(launch.status?.abbreviation ?? "")
                Text(LaunchDateFormatter.longString(for: launch.date))
                    .font(.system(.caption, design: .default))
                    .fontWeight(.light)
                Spacer()
            }
        }
        .padding(.vertical, 5)
    }
    
}

struct LaunchListItemView_Previews: PreviewProvider {
    static var previews: some View {
        let launch = PersistenceController.testData()
        List {
            LaunchListItemView(launch: launch)
            LaunchListItemView(launch: launch)
            LaunchListItemView(launch: launch)
            LaunchListItemView(launch: launch)
        }
            .previewDevice("iPhone 12")
    }
}

