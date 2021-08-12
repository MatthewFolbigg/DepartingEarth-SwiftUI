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

    struct drawing {
        static let vSectionSpacing: CGFloat = 8
        static let vItemSpacing: CGFloat = 2
        static let shadowRadius: CGFloat = 2
        static let shadownColor: Color = .secondary
        static let secondaryItemOpcatity: Double = 0.6
    }
    
    init(launch: Launch) {
        self.launch = launch
    }
        
    var body: some View {
        VStack(alignment: .leading, spacing: drawing.vSectionSpacing) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: drawing.vItemSpacing) {
                    provider
                    rocket
                }
                Spacer()
                VStack(alignment: .trailing, spacing: drawing.vSectionSpacing) {
                    statusText
                }
            }
            VStack(alignment: .leading, spacing: drawing.vItemSpacing) {
                if launch.mission != nil {
                    type
                    mission
                }
            }
            Spacer()
            HStack(alignment: .bottom) {
                countdown
                Spacer()
                date
            }
        }
    }
    
    //MARK: - Main Section
    var provider: some View {
        Text(launch.provider?.compactName ?? "")
            .fontWeight(.heavy)
            .font(.system(.title2, design: .rounded))
            .foregroundColor(.ui.greyBlueAccent)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
    }
    
    var rocket: some View {
        Text(launch.rocket?.name ?? "")
            .fontWeight(.semibold)
            .font(.system(.title3, design: .rounded))
            .foregroundColor(.ui.deepOrangeAccent)
            .lineLimit(1)
            .minimumScaleFactor(0.6)
    }
    
    var statusLight: some View {
            Image(systemName: "circle.fill")
                .foregroundColor(launch.status?.color)
                .scaleEffect(0.8)
    }
    
    var statusText: some View {
        Text(launch.status?.currentSituation.name ?? "").padding(.horizontal, 2).padding(.vertical, 2)
            .foregroundColor(.primary)
            .font(.system(.body, design: .rounded))
            .scaleEffect(0.8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(launch.status?.color == .clear ? .ui.greyBlueBackground : launch.status?.color)
                    .shadow(color: drawing.shadownColor, radius: drawing.shadowRadius)
            )
            .opacity(drawing.secondaryItemOpcatity)
    }
    
    var mission: some View {
        Text(launch.mission?.name ?? "")
            .fontWeight(.regular)
            .font(.system(.body, design: .rounded))
            .foregroundColor(.primary)
            .lineLimit(2)
            .minimumScaleFactor(0.8)
    }
    
    var type: some View {
        Text(launch.mission?.type ?? "")
            .fontWeight(.bold)
            .font(.system(.body, design: .rounded))
            .foregroundColor(.primary)
            .lineLimit(2)
            .minimumScaleFactor(0.8)
    }
    
    //MARK: - Countdown Section
    var countdown: some View {
        VStack(alignment: .leading, spacing: 5) {
            CountdownView(
                countdown: Countdown(to: launch.date),
                stopped: launch.status?.currentSituation.noCountdown ?? true,
                color: Color.ui.greyBlueBackground,
                textColor: Color.ui.greyBlueForeground,
                shadowColor: drawing.shadownColor,
                shadowRadius: drawing.shadowRadius
            )
                .frame(maxHeight: 25)
        }
    }
    
    var date: some View {
        VStack(alignment: .trailing) {
            Text(launch.status?.currentSituation.dateDescription ?? "")
                .fontWeight(.semibold)
                .font(.system(.caption, design: .rounded))
                .foregroundColor(.secondary)
                .lineLimit(1)
            Text(LaunchDateFormatter.dateStringWithMonthText(for: launch.date, compact: true))
                .fontWeight(.medium)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.primary)
                .lineLimit(1)
        }
    }
    
}



//MARK: - Previews
struct LaunchListItemView_Previews: PreviewProvider {
    static var previews: some View {
        let launch = PersistenceController.testData()
        List {
            LaunchListItemView(launch: launch)
            LaunchListItemView(launch: launch)
            LaunchListItemView(launch: launch)
            LaunchListItemView(launch: launch)
        }
        .previewDevice("iPhone 12 pro")
    }
}

