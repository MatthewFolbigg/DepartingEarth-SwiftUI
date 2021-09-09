//
//  CountdownView.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 13/08/2021.
//

import SwiftUI

struct CountdownView: View {
    //TODO: Don't display a countdown when stopepd
    
    @ObservedObject var countdown: Countdown
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let stopped: Bool
    
    //MARK: Styling
    var textColor: Color
    var backgroundColor: Color
    
    //MARK: Init
    init(countdown: Countdown, stopped: Bool = false, backgroundColor: Color = .clear, textColor: Color = .primary) {
        self.countdown = countdown
        self.stopped = stopped
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }
    
    struct drawing {
        static let componentSpacing: CGFloat = 6
        static let textBorderV: CGFloat = 3
        static let cornerRadius: CGFloat = 4
    }
    
    var body: some View {
        HStack(spacing: drawing.componentSpacing) {
            viewForSymbol(component: countdown.components.minus)
            HStack(spacing: drawing.componentSpacing) {
                viewForDate(component: countdown.components.days)
                viewForTime(component: countdown.components.hours)
                viewForTime(component: countdown.components.minutes)
                viewForTime(component: countdown.components.seconds)
            }
        }
        .onReceive(timer) { _ in
                countdown.updateComponents()
        }
    }
    
    @ViewBuilder
    func viewForTime(component: String) -> some View {
        Text(component)
            .font(.app.countdown)
            .lineLimit(1)
            .padding(.vertical, drawing.textBorderV)
            .foregroundColor(textColor)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: drawing.cornerRadius)
                    .foregroundColor(backgroundColor)
            )
    }
    
    
    @ViewBuilder
    func viewForDate(component: String) -> some View {
        Text(component)
            .font(.app.countdown)
            .lineLimit(1)
            .padding(.vertical, drawing.textBorderV)
            .foregroundColor(textColor)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: drawing.cornerRadius)
                    .foregroundColor(backgroundColor)
            )
    }
    
    @ViewBuilder
    func viewForSymbol(component: String) -> some View {
        Text(component)
            .font(.app.countdown)
            .padding(.horizontal, 5)
            .lineLimit(1)
            .padding(.vertical, drawing.textBorderV)
            .foregroundColor(textColor)
            .background(
                RoundedRectangle(cornerRadius: drawing.cornerRadius)
                    .foregroundColor(backgroundColor)
            )
    }
    
    
}

struct CountdownViewVersion2_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView(countdown: Countdown(to: Date.distantFuture), backgroundColor: .red)
            .environment(\.sizeCategory, .medium)
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .previewLayout(.device)
    }
}
