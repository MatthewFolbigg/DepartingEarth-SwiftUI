//
//  CountdownView.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 04/08/2021.
//

import SwiftUI

struct CountdownView: View {
    
    @ObservedObject var countdown: Countdown
    
    init(countdown: Countdown) {
        self.countdown = countdown
    }
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        HStack(alignment: .top , spacing: 5) {
            
            componentView(component: countdown.days, label: "Day")
            componentView(component: countdown.hours, label: "Hour")
            componentView(component: countdown.minutes, label: "Minute")
            componentView(component: countdown.seconds, label: "Second")
        }
        .onReceive(timer) { _ in
            countdown.updateComponents()
        }

    }
    
    @ViewBuilder
    func componentView(component: String, label: String = "") -> some View {
        GeometryReader { geo in
            let minAxis = min(geo.size.width, geo.size.height)
            let height = min(geo.size.height , geo.size.width/1.5)
            let radius = minAxis * 0.15
            VStack(alignment: .center, spacing: 1) {
                ZStack {
                    Color.gray.clipShape(RoundedRectangle(cornerRadius: radius))
                        .frame(width: geo.size.width, height: height, alignment: .center)
                        
                        Text(component)
                            .font(.system(size: height * 0.8, weight: .semibold, design: .monospaced))
                            .lineLimit(1)
                            .foregroundColor(.white)
                }
                if let label = label {
                    Text(label)
                        .font(.system(size: height * 0.35, weight: .thin, design: .rounded))
                        .lineLimit(1)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .frame(maxHeight: 100)
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView(countdown: Countdown(to: Date.distantFuture))
            .previewDevice("iPad Pro (12.9-inch) (5th generation)")
            .previewLayout(.device)
    }
}
