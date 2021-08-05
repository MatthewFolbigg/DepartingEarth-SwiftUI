//
//  LaunchDateFormatter.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 04/08/2021.
//

import Foundation

struct LaunchDateFormatter {
    
    static private var calendar = Calendar.current
    
    enum Seperator: String {
        case forwardSlash = "/"
        case colon = ":"
        case bar = "|"
        case spcae = " "
    }
    
    enum Month: Int {
        case january = 1, february, march, april, may, june, july, august, september, october, november, december
        
        var abbreviation: String {
            switch self {
            case .january : return "Jan"
            case .february: return "Feb"
            case .march: return "Mar"
            case .april: return "Apr"
            case .may: return "May"
            case .june: return "Jun"
            case .july: return "Jul"
            case .august: return "Aug"
            case .september: return "Sep"
            case .october: return "Oct"
            case .november: return "Nov"
            case .december: return "Dec"
            }
        }
        
        var string: String {
            switch self {
            case .january : return "January"
            case .february: return "February"
            case .march: return "March"
            case .april: return "April"
            case .may: return "May"
            case .june: return "June"
            case .july: return "July"
            case .august: return "August"
            case .september: return "September"
            case .october: return "October"
            case .november: return "November"
            case .december: return "December"
            }
        }
    }
    
    static func longString(for date: Date) -> String {
        let dayInt = calendar.component(.day, from: date)
        let yearInt = calendar.component(.year, from: date)
        let monthInt = calendar.component(.month, from: date)
        if let month = Month(rawValue: monthInt) {
            return "\(dayInt) \(month.string) \(yearInt)"
        } else {
            return ""
        }
    }
    
    static func digitSting(for date: Date, seperator: Seperator = .forwardSlash) -> String {
        let dayInt = calendar.component(.day, from: date)
        let yearInt = calendar.component(.year, from: date)
        let monthInt = calendar.component(.month, from: date)
        let sep = seperator.rawValue
        return "\(dayInt)\(sep)\(monthInt)\(sep)\(yearInt)"
    }
    
    static func shortTime(for date: Date, withSeconds: Bool) -> String {
        let hours = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        return "\(hours):\(minutes)\(withSeconds ? String(seconds) : "")"
    }
    
    static func countdownComponents(untill launchDate: Date) -> CountdownComponentInts {
        let including: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let dateComponents = calendar.dateComponents(including, from: Date(), to: launchDate)
        
        let minus = launchDate.timeIntervalSinceNow <= 0 ? false : true
        let days = abs(dateComponents.day ?? 0)
        let hours = abs(dateComponents.hour ?? 0)
        let minutes = abs(dateComponents.minute ?? 0)
        let seconds = abs(dateComponents.second ?? 0)
        
        let countdown = CountdownComponentInts(days: days, hours: hours, minutes: minutes, seconds: seconds, minus: minus)
        return countdown
    }
    
    static func countdownComponents(untill launchDate: Date) -> CountdownComponentStrings {
        let intComponents: CountdownComponentInts = countdownComponents(untill: launchDate)
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 2
        
        let minus = launchDate.timeIntervalSinceNow <= 0 ? "+" : "-"
        let days = formatter.string(from: NSNumber(value: intComponents.days)) ?? ""
        let hours = formatter.string(from: NSNumber(value: intComponents.hours)) ?? ""
        let minutes = formatter.string(from: NSNumber(value: intComponents.minutes)) ?? ""
        let seconds = formatter.string(from: NSNumber(value: intComponents.seconds)) ?? ""
        
        let countdown = CountdownComponentStrings(days: days, hours: hours, minutes: minutes, seconds: seconds, minus: minus)
        return countdown
    }
}

struct CountdownComponentInts {
    var days: Int
    var hours: Int
    var minutes: Int
    var seconds: Int
    var minus: Bool
}

struct CountdownComponentStrings {
    var days: String
    var hours: String
    var minutes: String
    var seconds: String
    var minus: String
}
