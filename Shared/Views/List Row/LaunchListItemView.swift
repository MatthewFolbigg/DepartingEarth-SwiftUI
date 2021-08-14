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
    
    struct drawing {
        static let vSectionSpacing: CGFloat = 8
        static let vItemSpacing: CGFloat = 4
        static let hItemSpacing: CGFloat = 8
        static let shadowRadius: CGFloat = 2
        static let shadownColor: Color = .secondary
        static let iconScale: Image.Scale = .medium
        static let secondaryItemOpcatity: Double = 0.6
        static let textMinimumScale: CGFloat = 0.8
    }
    
    init(launch: Launch) {
        self.launch = launch
    }
        
    //MARK: - Body
    var body: some View {
        HStack(alignment: .top) {
            statusColorBar
            VStack(alignment: .leading, spacing: drawing.vSectionSpacing) {
                VStack(alignment: .leading, spacing: drawing.vItemSpacing) {
                    provider
                    rocket
                }
                VStack(alignment: .leading, spacing: drawing.vItemSpacing) {
                    if launch.mission != nil {
                        mission
                    }
//                    date
                    status
                }
                HStack {
                    countdown
                    Spacer()
                } .padding(.top, 8)
            }
            Spacer()
        }
        .padding(.vertical, 5)
    }
    
    //MARK: - Sections
    var provider: some View {
        Text(launch.provider?.compactName ?? "")
            .fontWeight(.black)
            .font(.system(.headline, design: .default))
            .foregroundColor(.ui.greyBlueAccent)
            .lineLimit(1)
            .minimumScaleFactor(drawing.textMinimumScale)
    }
    
    var rocket: some View {
        Text(launch.rocket?.name ?? "")
            .fontWeight(.black)
            .font(.system(.headline, design: .default))
            .foregroundColor(.ui.deepOrangeAccent)
            .lineLimit(1)
            .minimumScaleFactor(drawing.textMinimumScale)
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
            .font(.system(.subheadline, design: .default))
            .lineLimit(1)
            .minimumScaleFactor(drawing.textMinimumScale)
    }
    
    //MARK: - Date
    var date: some View {
        HStack(alignment: .firstTextBaseline, spacing: drawing.hItemSpacing) {
            Label(
                title: { dateText },
                icon: { Image(systemName: "calendar") }
            )
            .layoutPriority(1)
            if situation == .dateUndetermined || situation == .dateUnconfirmed  {
                dateDescriptionText
                    .layoutPriority(0)
            }
        }
        .foregroundColor(.ui.greyBlueAccent)
    }
    
    var dateText: some View {
        Text(launch.dateString(compact: true))
            .fontWeight(.regular)
            .font(.system(.subheadline, design: .default))
            .lineLimit(1)
            .minimumScaleFactor(drawing.textMinimumScale)
    }
    
    var dateDescriptionText: some View {
        Text("\(launch.status?.currentSituation.dateDescription ?? "")")
            .fontWeight(.thin)
            .font(.system(.subheadline, design: .default))
            .lineLimit(1)
            .minimumScaleFactor(drawing.textMinimumScale)
    }
    
    //MARK: - Status
    var status: some View {
        HStack(alignment: .firstTextBaseline, spacing: drawing.hItemSpacing) {
            Label(
                title: { statusText },
                icon: { Image(systemName: "checkmark.circle") }
            )
            .layoutPriority(1)
        }
        .foregroundColor(.ui.greyBlueAccent)
    }
    
    var statusText: some View {
        Text(launch.status?.currentSituation.name ?? "")
            .fontWeight(.regular)
            .font(.system(.subheadline, design: .default))
            .lineLimit(1)
            .minimumScaleFactor(drawing.textMinimumScale)
    }
    
    var statusColorBar: some View {
        Rectangle()
            .frame(maxWidth: 3)
            .foregroundColor(launch.status?.color == .clear ? .ui.greyBlueBackground : launch.status?.color)
    }
    
    
    
    //MARK: Countdown
    var countdown: some View {
        CountdownView(
            countdown: Countdown(to: launch.date),
            stopped: launch.status?.currentSituation.noCountdown ?? true,
            backgroundColor: .ui.greyBlueBackground.opacity(0.5),
            textColor: .ui.greyBlueAccent,
            fontWeight: .bold
        )
        .aspectRatio(CGSize(width: 11, height: 1), contentMode: .fit)
        .font(.system(.body, design: .default))
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

