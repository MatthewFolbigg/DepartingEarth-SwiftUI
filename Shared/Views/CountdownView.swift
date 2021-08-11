//
//  CountdownView.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 04/08/2021.
//

import SwiftUI

struct CountdownView: View {
    
    @ObservedObject var countdown: Countdown
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let stopped: Bool
    
    //MARK: Styling
    var cornerRadius: CGFloat
    var spacing: CGFloat
    var backgroundColor: Color
    var symbolBackgroundColor: Color
    var textColor: Color
    
    //MARK: Init
    init(countdown: Countdown, stopped: Bool = false, cornerRadius: CGFloat = 5, spacing: CGFloat = 5, color: Color = .gray, symbolColor: Color? = nil, textColor: Color = .primary) {
        self.countdown = countdown
        self.stopped = stopped
        self.cornerRadius = cornerRadius
        self.spacing = spacing
        self.backgroundColor = color
        if let symbolColor = symbolColor {
            self.symbolBackgroundColor = symbolColor
        } else {
            self.symbolBackgroundColor = color
        }
        self.textColor = textColor
    }
    
    //MARK: Body
    var body: some View {
        GeometryReader { geo in
            let numberOfNumberComponents: CGFloat = 4
            let numberOfSymbolComponents: CGFloat = 1
            let spacing: CGFloat = spacing
            let totalSpace = spacing * (numberOfNumberComponents + numberOfSymbolComponents)
            let width = (geo.size.width - totalSpace) / (numberOfNumberComponents + (numberOfSymbolComponents * 0.5))
                //4.5 represents 4 full width components and 1 half width symbol
            HStack(alignment: .center, spacing: spacing) {
                componentView(component: !stopped ? countdown.minus : "-", isSymbol: true)
                    .frame(maxWidth: width/2)
                componentView(component: !stopped ? countdown.days: "--")
                    .frame(maxWidth: width)
                componentView(component: !stopped ? countdown.hours: "--")
                    .frame(maxWidth: width)
                componentView(component: !stopped ? countdown.minutes: "--")
                    .frame(maxWidth: width)
                componentView(component: !stopped ? countdown.seconds: "--")
                    .frame(maxWidth: width)
            }
            .position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).midY)
        }
        .aspectRatio(CGSize(width: 15, height: 2), contentMode: .fit)
        .onReceive(timer) { _ in
            countdown.updateComponents()
        }
    }
    
    func componentView(component: String, isSymbol: Bool = false) -> some View {
        GeometryReader { geo in
            let fontSize = geo.size.height * 0.8
            Text(component)
                .font(.system(size: fontSize, weight: .semibold, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .foregroundColor(textColor)
                .position(x: geo.frame(in: .local).midX, y: (geo.frame(in: .local).midY))
        }
        .aspectRatio(CGSize(width: isSymbol ? 5 : 10, height: 6), contentMode: .fit)
        .background(
            (isSymbol ? symbolBackgroundColor : backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: isSymbol ? cornerRadius * 1.2 : cornerRadius))
        )
    }
}




//MARK: - Previews
struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView(countdown: Countdown(to: Date.distantFuture))
            .previewDevice("iPad Pro (12.9-inch) (5th generation)")
            .previewLayout(.device)
    }
}
