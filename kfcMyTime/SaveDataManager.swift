//
//  SaveDataManager.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 10.03.2022.
//

import RealmSwift



class FormatSave {
    
    static let shared = FormatSave()
    private init() {}
    
    //MARK: -Date
    
    func timeWorkDouble(_ timeStart: Date, _ timeStop: Date) -> Double {
        timeStop.timeIntervalSince(timeStart)
    }
    
    func componentsTime(_ startTime: Date, _ stopTime: Date) -> String {
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: startTime , to: stopTime)
        return "\(components.hour ?? 0)"
    }
    
    func timeWorkOfFormatString(_ timeInterval: Double) -> String {
    let formatter = DateComponentsFormatter()
        formatter.calendar?.locale = Locale(identifier: "Ru-ru")
    formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated

        let formattedString = formatter.string(from: TimeInterval(timeInterval * 3600.0))
        return formattedString ?? "-"
    }
    
    
    func lunchTimeString(_ timeStart: Date, _ timeStop: Date, _ settingUserOfLunch: Bool) -> (String,Double) {
        ///Метод инициализации времени обеденного перерыва
        let timeInterval = timeStop.timeIntervalSince(timeStart)
        if settingUserOfLunch {
            switch timeInterval {
            case (14401...32399):
                return ("30'", (timeInterval - 1800) / 3600)
            case (32400...):
                return ("45'",(timeInterval - 2700) / 3600)
            default:
                return ("-", timeInterval / 3600.0)
            }
        }
        return ("-", timeInterval/3600.0)
    }
    
    func allTimeMonch() {
        
    }
}
    


