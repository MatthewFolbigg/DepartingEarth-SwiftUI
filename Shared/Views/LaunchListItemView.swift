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
        static let vItemSpacing: CGFloat = 8
        static let shadowRadius: CGFloat = 2
        static let shadownColor: Color = .secondary
        static let iconScale: Image.Scale = .medium
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
                    if launch.mission != nil {
                        mission
                    }
                    date
                }
                Spacer()
            }
            Spacer()
            HStack {
                countdown
                Spacer()
                statusText.opacity(0.8)
            }
        }
        .padding(5)
    }
    
    //MARK: - Main Section
    var rocket: some View {
        Text(launch.rocket?.name ?? "")
            .fontWeight(.bold)
            .font(.system(.title2, design: .default))
            .foregroundColor(.ui.deepOrangeAccent)
            .lineLimit(1)
            .minimumScaleFactor(0.6)
    }
    
    var provider: some View {
        Text(launch.provider?.compactName ?? "")
            .fontWeight(.black)
            .font(.system(.title, design: .default))
            .foregroundColor(.ui.greyBlueAccent)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
    }
    
    //MARK: Mission
    var mission: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Image(systemName: launch.mission?.symbolForType ?? "")
                .imageScale(drawing.iconScale)
            missionName
        }
        .foregroundColor(.ui.greyBlueAccent)
    }
        
    var missionName: some View {
        Text(launch.mission?.name ?? "")
            .fontWeight(.semibold)
            .font(.system(.subheadline, design: .default))
            .foregroundColor(.ui.greyBlueAccent)
            .lineLimit(2)
            .minimumScaleFactor(0.8)
    }
    
    //MARK: Date
    var date: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Image(systemName: "calendar")
                .imageScale(drawing.iconScale)
            if situation == .dateUndetermined || situation == .dateUnconfirmed  {
                dateText
                Text("\(launch.status?.currentSituation.dateDescription ?? "")")
                    .fontWeight(.thin)
                    .font(.system(.caption, design: .default))
                    .foregroundColor(.ui.greyBlueAccent)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            } else {
                dateText
            }
            
        }
        .foregroundColor(.ui.greyBlueForeground)
    }
    
    var dateText: some View {
        Text(launch.dateString(compact: true))
            .fontWeight(.semibold)
            .font(.system(.subheadline, design: .default))
            .foregroundColor(.ui.greyBlueAccent)
            .lineLimit(2)
            .minimumScaleFactor(0.8)
    }
    
    //MARK: Status
    var statusBar: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundColor(launch.status?.color == .clear ? .ui.greyBlueBackground : launch.status?.color)
            .shadow(color: drawing.shadownColor, radius: drawing.shadowRadius)
            .frame(width: 120, height: 8)
            .opacity(drawing.secondaryItemOpcatity)
            .frame(width: 120, height: 8)
    }
    
    var statusText: some View {
        Text(launch.status?.currentSituation.name ?? "")
            .padding(.horizontal, 2).padding(.vertical, 2)
            .foregroundColor(.primary)
            .font(.system(.body, design: .default))
            .scaleEffect(0.8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(launch.status?.color == .clear ? .ui.greyBlueBackground : launch.status?.color)
                    .shadow(color: drawing.shadownColor, radius: drawing.shadowRadius)
                    .frame(width: 120, height: 23)
            )
            .opacity(drawing.secondaryItemOpcatity)
            .frame(width: 120, height: 23)
    }
    

        
    //MARK: - Countdown Section
    var countdown: some View {
        VStack(alignment: .leading, spacing: 0) {
            CountdownView(
                countdown: Countdown(to: launch.date),
                stopped: launch.status?.currentSituation.noCountdown ?? true,
                color: Color.ui.greyBlueBackground,
                textColor: Color.ui.greyBlueForeground,
                shadowColor: drawing.shadownColor,
                shadowRadius: drawing.shadowRadius
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

