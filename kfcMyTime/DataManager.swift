//
//  DataManager.swift
//  kfcMyTime
//
//  Created by User on 28.10.2021.
//

import Foundation
import RealmSwift

class DataManager {
    static let shared = DataManager()
    init() {}
    
//    let settingSet = [("Ставка", "rublesign.circle"),
//                      ("Уведомления", "bell.fill"),
//                      ("Обед", "fork.knife"),
//                      ("Ночные часы","moon.stars.fill")]
    
    let monthArray = [1: "Январь",
                      2: "Февраль",
                      3: "Март",
                      4: "Апрель",
                      5: "Май",
                      6: "Июнь",
                      7: "Июль",
                      8: "Август",
                      9: "Сентябрь",
                      10: "Октябрь",
                      11: "Ноябрь",
                      12: "Декабрь"]
    
    func dayDateFormatterDay(_ day: Date) -> String  {
        let dateFormatterDay = DateFormatter()
        dateFormatterDay.dateFormat = "dd"
        dateFormatterDay.locale = Locale(identifier: "RU_RU")
        return dateFormatterDay.string(from: day)
    }
    func startStopTimeInterval(_ startTime: Date, _ stopTime: Date) -> TimeInterval {
         stopTime.timeIntervalSince(startTime)
    }
    // MARK: calculated
     func calculationOfWorkingHours(_ timeWork: TimeInterval,_ lunchTime: Double) -> Double {
        
        return Double(String(format: "%.1f", (timeWork / 3600.0 - lunchTime))) ?? 0.2
        }
    
    
    func calculationLunchTime(_ timeWork: TimeInterval, _ settingUserOfLunch: Bool) -> (Double, String) {
        if settingUserOfLunch {
        switch timeWork {
        case (14401...32399):
            return (timeWork - 1800 , "30 мин")
        case (32400...):
            return (timeWork - 2700, "45 мин")
        default:
            return (timeWork, "-")
        }
        } else { return (timeWork, "-") }
    }
        
    func lunchTime(_ timeWork: TimeInterval, _ settingUserOfLunch: Bool) -> String {
        if settingUserOfLunch {
        switch timeWork {
        case (14401...32399):
            return dateFormat(0.5 * 60 * 60)
        case (32400...):
            return dateFormat(0.8 * 60 * 60)
        default:
            return "-"
        }
        }
        return "-"
    }
    
    
    
         func allTimeMonth(_ section: Results<InfoOfDayWork>, _ settingUserOfLunch: Bool) -> String {
             var allTime: TimeInterval = 0.0
            for timeDay in section {
                allTime = allTime + (calculationLunchTime(startStopTimeInterval(timeDay.timeStart, timeDay.timeStop), settingUserOfLunch).0)
            }
            if allTime == 0 {
                return ""
            } else {
                return dateFormat(allTime) + String(format: " ⚒︎ (%.1f)", (allTime / 3600))
            }
        }
    
    
    func dateFormat(_ value: TimeInterval) -> String {
    let formatter = DateComponentsFormatter()
        formatter.calendar?.locale = Locale(identifier: "Ru-ru")
    formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated

    let formattedString = formatter.string(from: TimeInterval(value))
        return formattedString ?? "-"
    }

    
    func componentsTime(_ startTime: Date, _ stopTime: Date) -> DateComponents {
    Calendar.current.dateComponents([.hour, .minute, .second], from: startTime , to: stopTime)
    }
    
//    func calculatedTimeOfLunch(_ startTime: Date, _ stopTime: Date,_ settingUserOfLunch: Bool) -> Double {
//       let timeWork = calculationLunchTime(startStopTimeInterval(startTime,stopTime),settingUserOfLunch)
//        
//        
////        return dateFormat(timeWork.0) + String(format: " (%.1f)", (timeWork.0 / 3600.0))
//        return timeWork
//    }
    
    }
