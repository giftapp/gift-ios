//
// Created by Matan Lachmish on 02/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import SwiftDate

enum DayName: Int {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday

    func localizedDescription() -> String {
        switch self {
        case .sunday:
            return "Date+String.Day.Sunday".localized
        case .monday:
            return "Date+String.Day.Monday".localized
        case .tuesday:
            return "Date+String.Day.Tuesday".localized
        case .wednesday:
            return "Date+String.Day.Wednesday".localized
        case .thursday:
            return "Date+String.Day.Thursday".localized
        case .friday:
            return "Date+String.Day.Friday".localized
        case .saturday:
            return "Date+String.Day.Saturday".localized
        }
    }
}

enum PartOfDay {
    case morning
    case noon
    case afternoon
    case evening
    case night

    func localizedGreeting() -> String {
        switch self {
        case .morning:
            return "Date+String.Greeting.Morning".localized
        case .noon:
            return "Date+String.Greeting.Noon".localized
        case .afternoon:
            return "Date+String.Greeting.Afternoon".localized
        case .evening:
            return "Date+String.Greeting.Evening".localized
        case .night:
            return "Date+String.Greeting.Night".localized
        }
    }
}

extension Date {

    var dayString: String {
        let dayName = DayName(rawValue: self.weekday)
        return dayName!.localizedDescription()
    }

    var formattedDateString: String {        
        let usDateFormat = DateFormatter()
        usDateFormat.dateFormat = "d MMMM"
        usDateFormat.locale = NSLocale(localeIdentifier: "he-IL") as Locale!
        return usDateFormat.string(from: self)
    }

    var partOfDayGreetingString: String {
        var partOfDay: PartOfDay
        switch self.hour {
        case 6...11:
            partOfDay = .morning
        case 12...15:
            partOfDay = .noon
        case 16...18:
            partOfDay = .afternoon
        case 19...21:
            partOfDay = .evening
        case 22...24, 0...5:
            partOfDay = .night
        default:
            Logger.error("Failed to get part of day string")
            partOfDay = .morning
        }

        return partOfDay.localizedGreeting()
    }
}
