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
                Text(launch.provider?.type ?? "")
                    .font(.system(.caption, design: .default))
                    .fontWeight(.light)
                Spacer()
                CountdownView(toDate: launch.date)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 5) {
                Text(launch.status?.abbreviation ?? "")
                Text(LaunchDateFormatter.longString(for: launch.date))
                    .font(.system(.caption, design: .default))
                    .fontWeight(.light)
            }
        }
        .padding(.vertical)
    }
    
}

struct LaunchListItemView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let launch = PersistenceController.testData(context: context)
        List {
            LaunchListItemView(launch: launch)
            LaunchListItemView(launch: launch)
            LaunchListItemView(launch: launch)
            LaunchListItemView(launch: launch)
        }
            .previewDevice("iPhone 12")
    }
}

