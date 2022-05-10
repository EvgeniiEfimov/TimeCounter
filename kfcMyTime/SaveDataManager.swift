//
//  SaveDataManager.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 10.03.2022.
//

import RealmSwift
import SwiftUI



class FormatSave {
    
    static let shared = FormatSave()
    private init() {}
    
    let nightRangeOne = 22...23
    let nightRangeTwo = 0...6
    let dayRange = 360...1320
    
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
    //MARK: версия 1
//    func nightTime (_ timeStart: Date, _ timeStop: Date) -> Int {
//        func timeComponent (_ time: Date) -> Int {
//            guard let component = Calendar.current.dateComponents([.hour], from: time).hour else {return 0}
//            return component
//        }
//        let a = timeComponent(timeStart)
//        let b = timeComponent(timeStop)
//
//        var counterNightTime = 0
//        for c in a...b {
//            if nightRangeOne.contains(c) || nightRangeTwo.contains(c){
//                counterNightTime += 1
//            }
//        }
//        return counterNightTime
//    }
    //MARK: Версия 2
    
//    func nightTime(_ timeStart: Date, _ timeStop: Date, _ rangeDay: ClosedRange<Int>) -> Double {
//        func dateComponents(_ date: Date) -> Int {
//        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
//            return (components.hour ?? 0) * 60 + (components.minute ?? 0)
//        }
//
//            if rangeDay.lowerBound >= dateComponents(timeStart) {
//                return Double(rangeDay.lowerBound - dateComponents(timeStart)) / 60.0
//        } else if rangeDay.upperBound <= dateComponents(timeStop) {
//            return Double(dateComponents(timeStop) - rangeDay.upperBound) / 60.0
//        } else {
//            return 0
//        }
//    }
    
    //MARK: Версия 3 (работает, но не красиво)
    func test(_ timeStart: Date, _ timeStop: Date) -> Int{
        func dateComponents(_ date: Date) -> Int {
            let components = Calendar.current.dateComponents([.day, .hour, .minute], from: date)
            return (components.hour ?? 0) * 60 + (components.minute ?? 0)
                }
        var rangeWork: ClosedRange<Int>
        var rangeWorkTwo: ClosedRange<Int>
        
        
        if dateComponents(timeStart) < dateComponents(timeStop) {
            rangeWork = dateComponents(timeStart)...dateComponents(timeStop)
            let rangeClamped = rangeWork.clamped(to: dayRange)
            let dayTime = rangeClamped.upperBound - rangeClamped.lowerBound
            return dayTime
        } else {
            rangeWork = dateComponents(timeStart)...1440
            rangeWorkTwo = 0...dateComponents(timeStop)
            let rangeClamped = rangeWork.clamped(to: dayRange)
            let rangeClampedTwo = rangeWorkTwo.clamped(to: dayRange)
            
            let dayTime = rangeClamped.upperBound - rangeClamped.lowerBound
            let dayTimeTwo = rangeClampedTwo.upperBound - rangeClampedTwo.lowerBound
            
            return dayTime + dayTimeTwo
        }
}
    

}

    


