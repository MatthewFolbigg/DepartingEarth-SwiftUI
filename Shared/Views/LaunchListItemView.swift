//
//  LaunchListItemView.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 03/08/2021.
//

import SwiftUI

struct LaunchListItemView: View {
    
    @State var launch: Launch
    var situation: Status.Situation { launch.status?.currentSituation ?? .dateUndetermined }
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    struct drawing {
        static let vSectionSpacing: CGFloat = 8
        static let vItemSpacing: CGFloat = 2
        static let shadowRadius: CGFloat = 2
        static let shadownColor: Color = .secondary
        static let iconScale: Image.Scale = .medium
        static let secondaryItemOpcatity: Double = 0.6
    }
    
    init(launch: Launch) {
        self.launch = launch
    }
        
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: drawing.vSectionSpacing) {
                VStack(alignment: .leading, spacing: drawing.vItemSpacing) {
                    provider
                    rocket
                }
                VStack(alignment: .leading, spacing: drawing.vItemSpacing) {
                    if launch.mission != nil {
                        mission
                    }
                    date
                }
                Spacer()
                HStack {
                    countdown
                    Spacer()
                    status.opacity(0.8)
                }
            }
            Spacer()
        }
    }
    
    //MARK: - Main Section
    var rocket: some View {
        Text(launch.rocket?.name ?? "")
            //            .fontWeight(.bold)
            .font(.system(.headline, design: .default))
            .foregroundColor(.ui.deepOrangeAccent)
            .lineLimit(1)
            .minimumScaleFactor(0.6)
    }
    
    var provider: some View {
        Text(launch.provider?.compactName ?? "")
            //            .fontWeight(.bold)
            .font(.system(.headline, design: .default))
            .foregroundColor(.ui.greyBlueAccent)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
    }
    
    //MARK: - Mission
    var mission: some View {
        Label(
            title: { missionNameText },
            icon: {
                Image(systemName: launch.mission?.symbolForType ?? "")
                    .imageScale(drawing.iconScale)
            }
        )
        .foregroundColor(.ui.greyBlueAccent)
    }
    
    var missionNameText: some View {
        Text(launch.mission?.name ?? "")
            //            .fontWeight(.regular)
            .font(.system(.subheadline, design: .default))
            .lineLimit(1)
            .minimumScaleFactor(0.8)
    }
    
    //MARK: - Date
    var date: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Label(
                title: { dateText },
                icon: { Image(systemName: "calendar") }
            )
            if situation == .dateUndetermined || situation == .dateUnconfirmed  {
                dateDescriptionText
            }
        }
        .foregroundColor(.ui.greyBlueAccent)
    }
    
    var dateText: some View {
        Text(launch.dateString(compact: true))
            .fontWeight(.regular)
            .font(.system(.subheadline, design: .default))
            .lineLimit(1)
            .minimumScaleFactor(0.8)
    }
    
    var dateDescriptionText: some View {
        Text("\(launch.status?.currentSituation.dateDescription ?? "")")
            .fontWeight(.thin)
            .font(.system(.subheadline, design: .default))
            .lineLimit(1)
            .minimumScaleFactor(0.8)
    }
    
    //MARK: - Status
    var status: some View {
        statusText
            .scaleEffect(0.8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(launch.status?.color == .clear ? .ui.greyBlueBackground : launch.status?.color)
                    .frame(width: 120, height: 23)
            )
            .opacity(drawing.secondaryItemOpcatity)
            .frame(width: 120, height: 23)
    }
    
    var statusText: some View {
        Text(launch.status?.currentSituation.name ?? "")
            .font(.system(.subheadline, design: .default))
            .lineLimit(1)
            .minimumScaleFactor(0.8)
    }
    
    
    
    //MARK: Countdown
    var countdown: some View {
        VStack(alignment: .leading, spacing: 0) {
            CountdownView(
                countdown: Countdown(to: launch.date),
                stopped: launch.status?.currentSituation.noCountdown ?? true,
                color: Color.ui.greyBlueBackground,
                textColor: Color.ui.greyBlueForeground
            )
            .padding(.bottom, (drawing.shadowRadius)/2 * -1)
            .frame(height: 24)
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

