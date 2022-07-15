//
//  SaveDataManager.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 10.03.2022.
//

import RealmSwift
import SwiftUI



class CalculationTime {
    
    static let shared = CalculationTime()
    private init() {}
    
    private let secondsPerHour = 3600
    //MARK: -Date
    
    func componentsTime(_ startTime: Date, _ stopTime: Date) -> String {
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: startTime , to: stopTime)
        return "\(components.hour ?? 0)"
    }
    

    //MARK: Версия 3 (работает, но не красиво)
    func workDayTime(_ timeStart: Date, _ timeStop: Date) -> Double {
        func dateComponents(_ date: Date) -> Int {
            let components = Calendar.current.dateComponents([.day, .hour, .minute], from: date)
            return (components.hour ?? 0) * secondsPerHour + (components.minute ?? 0) * 60
                }
        var rangeWork: ClosedRange<Int>
        var rangeWorkTwo: ClosedRange<Int>
        let dayRange = (6 * secondsPerHour)...(22 * secondsPerHour) // дневные часы (6-22)
        
        if dateComponents(timeStart) < dateComponents(timeStop) {
            rangeWork = dateComponents(timeStart)...dateComponents(timeStop)
            let rangeClamped = rangeWork.clamped(to: dayRange)
            let dayTime = rangeClamped.upperBound - rangeClamped.lowerBound
            return Double(dayTime)
        } else {
            rangeWork = dateComponents(timeStart)...(24 * secondsPerHour)
            rangeWorkTwo = 0...dateComponents(timeStop)
            let rangeClamped = rangeWork.clamped(to: dayRange)
            let rangeClampedTwo = rangeWorkTwo.clamped(to: dayRange)
            
            let dayTime = rangeClamped.upperBound - rangeClamped.lowerBound
            let dayTimeTwo = rangeClampedTwo.upperBound - rangeClampedTwo.lowerBound
            
            return Double(dayTime + dayTimeTwo)
        }
}
    

}

    


