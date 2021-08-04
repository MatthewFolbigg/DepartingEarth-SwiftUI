//
//  CountdownView.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 04/08/2021.
//

import SwiftUI

struct CountdownView: View {
    var date: Date
    @State var countdown: CountdownComponentStrings? = nil
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(toDate: Date) {
        self.date = toDate
        self.countdown = LaunchDateFormatter.countdownComponents(untill: toDate)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 150, height: 25, alignment: .center)
                .foregroundColor(.gray)
            HStack {
                if let countdown = countdown {
                    Text(countdown.minus ? "-" : "+")
                    Text(countdown.days)
                    Text(countdown.hours)
                    Text(countdown.minutes)
                    Text(countdown.seconds)
                }
            }
            .foregroundColor(.white)
            .onReceive(timer) { _ in
                self.countdown = LaunchDateFormatter.countdownComponents(untill: date)
            }
        }
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView(toDate: Date.distantFuture)
    }
}
