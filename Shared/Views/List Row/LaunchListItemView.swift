//
//  LaunchListItemView.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 03/08/2021.
//

import SwiftUI

struct LaunchListItemView: View {
    
    @State var launch: Launch
    @EnvironmentObject var pinned: PinnedLaunches
    var isPinned: Bool { pinned.isPinned(launch) }
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
    
    init(launch: Launch, isPinned: Bool) {
        self.launch = launch
    }
        
    //MARK: - Body
    var body: some View {
        HStack(alignment: .top) {
            statusColorBar
            VStack(alignment: .leading, spacing: drawing.vSectionSpacing) {
                VStack(alignment: .leading, spacing: drawing.vItemSpacing) {
                    HStack {
                        provider
                        Spacer()
                        if isPinned { Image(systemName: "pin.circle").foregroundColor(.app.control) }
                    }
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
            .foregroundColor(.app.textSecondary)
            .lineLimit(1)
            .minimumScaleFactor(drawing.textMinimumScale)
    }
    
    var rocket: some View {
        Text(launch.rocket?.name ?? "")
            .fontWeight(.black)
            .font(.system(.headline, design: .default))
            .foregroundColor(.app.textPrimary)
            .lineLimit(1)
            .minimumScaleFactor(drawing.textMinimumScale)
    }
        
    //MARK: - Mission
    var mission: some View {
        Label(launch.mission?.name ?? "", systemImage: launch.mission?.symbolForType ?? "")
            .imageScale(drawing.iconScale)
            .font(.system(.subheadline, design: .default))
            .lineLimit(1)
            .minimumScaleFactor(drawing.textMinimumScale)
            .foregroundColor(.app.textPrimary)
    }
    
    //MARK: - Date
    var date: some View {
        HStack(alignment: .firstTextBaseline, spacing: drawing.hItemSpacing) {
            Label(launch.dateString(compact: true), systemImage: "calendar")
                .font(.system(.subheadline, design: .default).weight(.regular))
                .lineLimit(1)
                .minimumScaleFactor(drawing.textMinimumScale)
                .layoutPriority(1)
            if situation == .dateUndetermined || situation == .dateUnconfirmed  {
                Text("\(launch.status?.currentSituation.dateDescription ?? "")")
                    .fontWeight(.thin)
                    .font(.system(.subheadline, design: .default))
                    .lineLimit(1)
                    .minimumScaleFactor(drawing.textMinimumScale)
                    .layoutPriority(0)
            }
        }
        .foregroundColor(.app.textPrimary)
    }
        
    //MARK: - Status
    var status: some View {
        HStack(alignment: .firstTextBaseline, spacing: drawing.hItemSpacing) {
            Label(launch.status?.currentSituation.name ?? "", systemImage: launch.status?.iconName ?? "")
                .font(.system(.subheadline, design: .default).weight(.regular))
                .lineLimit(1)
                .minimumScaleFactor(drawing.textMinimumScale)
                .layoutPriority(1)
        }
        .foregroundColor(.app.textPrimary)
    }
    
    var statusColorBar: some View {
        Rectangle()
            .frame(maxWidth: 3)
            .foregroundColor(launch.status?.color == .clear ? .app.backgroundPrimary : launch.status?.color)
    }
    
    
    
    //MARK: Countdown
    var countdown: some View {
        CountdownView(
            countdown: Countdown(to: launch.date),
            stopped: launch.status?.currentSituation.noCountdown ?? true,
            backgroundColor: .app.backgroundPrimary.opacity(0.5),
            textColor: .app.textPrimary,
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
            LaunchListItemView(launch: launch, isPinned: false)
            LaunchListItemView(launch: launch, isPinned: false)
            LaunchListItemView(launch: launch, isPinned: true)
            LaunchListItemView(launch: launch, isPinned: false)
        }
        .previewDevice("iPhone 12 pro")
    }
}

