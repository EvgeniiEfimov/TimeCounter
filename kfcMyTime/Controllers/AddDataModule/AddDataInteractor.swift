//
//  AddDataInteractor.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 11.08.2022.
//

import Foundation

protocol AddDataInteractorProtocol: AnyObject {
    func saveData(_ data: AddDataStruct)
}

class AddDataInteractor: AddDataInteractorProtocol {
    weak var presenter: AddDataPresenterProtocol!
    let dataService: DataServiceProtocol = DataService()
    
    
    required init(presenter: AddDataPresenterProtocol) {
        self.presenter = presenter
    }
    let secondsPerHour = 3600

    func saveData(_ data: AddDataStruct) {
        let secondPerDay = 86400.0
        if data.timeStop > data.timeStart && data.timeStop.timeIntervalSince(data.timeStart) <= secondPerDay {
        let newListInfoOfMonch = ListInfoOfMonch()
        let newListDayOfMonth = DayOfMonth()
        let newListInfoOfDayWork = InfoOfDayWork()
            
            
            newListInfoOfMonch.nameMonth = data.timeStart.getNameMonth
            newListInfoOfMonch.numberMonth = data.timeStart.getNumberMonth
            
            
            newListDayOfMonth.dateWorkShift = data.timeStart
            
            let allWorkTime = data.timeStop.timeIntervalSince(data.timeStart)
            
            let lunchTime = data.lunch ? determininglunchTime(allWorkTime) : (stringValue: "Не учтен", doubleValue: 0.0)
            
            newListDayOfMonth.timeWork = data.lunch ?
            ((allWorkTime - lunchTime.doubleValue) / Double(secondsPerHour)) :
            (allWorkTime / Double(secondsPerHour))
            
            
            newListDayOfMonth.timeWorkStringFormat = newListDayOfMonth.timeWork.formattingTimeWorkOfString
            newListDayOfMonth.lunchBool = data.lunch
            newListDayOfMonth.nightTimeBool = data.nightTime
            
            newListInfoOfDayWork.timeStart = data.timeStart.timeDateFormatter("HH:mm")
            newListInfoOfDayWork.timeStop = data.timeStop.timeDateFormatter("HH:mm")
            newListInfoOfDayWork.dateWorkShift = data.timeStart.timeDateFormatter("dd.MM.yy")
            newListInfoOfDayWork.timeStartData = data.timeStart
            newListInfoOfDayWork.timeStopData = data.timeStop
            newListInfoOfDayWork.lunchString = lunchTime.stringValue
            newListInfoOfDayWork.timeWorkString = newListDayOfMonth.timeWork.formattingTimeWorkOfString
            if workDayTime(data.timeStart, data.timeStop) > lunchTime.doubleValue {
                newListInfoOfDayWork.workDayTime = ((workDayTime(data.timeStart, data.timeStop)) - lunchTime.doubleValue) / Double(secondsPerHour)
                newListInfoOfDayWork.workNightTime = data.nightTime ?
                newListDayOfMonth.timeWork  - newListInfoOfDayWork.workDayTime : 0.0
            } else {
                newListInfoOfDayWork.workDayTime = (workDayTime(data.timeStart, data.timeStop)) / Double(secondsPerHour)
                newListInfoOfDayWork.workNightTime = data.nightTime ?
                (newListDayOfMonth.timeWork  - newListInfoOfDayWork.workDayTime) : 0.0
            }
            newListInfoOfDayWork.inform = data.note ?? ""
            
            let valueByMonth =  dataService.listInfoOfMonch.filter("numberMonth = \(newListInfoOfMonch.numberMonth)")
            if valueByMonth.isEmpty {
                DispatchQueue.main.async {
                    newListDayOfMonth.day = newListInfoOfDayWork
                    newListInfoOfMonch.monch.append(newListDayOfMonth)
                    self.dataService.saveListInfoOfMonch(allMonch: newListInfoOfMonch)
//                    StorageManager.shared.save(allMonch: newListInfoOfMonch)
                }
            } else {
                newListDayOfMonth.day = newListInfoOfDayWork
                guard let valueMonth = valueByMonth.first else { return }
                /////////////////
                self.dataService.saveDayOfMonch(monch: newListDayOfMonth, in: valueMonth)
//                StorageManager.shared.save(monch: newListDayOfMonth, in: valueMonth)
            }
        }
    }

}
extension AddDataInteractor {
    private func determininglunchTime(_ timeIntervalWork: Double) -> (stringValue: String, doubleValue: Double) {
        ///Метод инициализации времени обеденного перерыва
            switch timeIntervalWork {
            case (7200...14400):
                return (ValueLunchTime.fifteenMinutes.rawValue, 900.0)
            case (14401...32399):
                return (ValueLunchTime.thirtyMinutes.rawValue, 1800.0)
            case (32400...):
                return (ValueLunchTime.fortyFiveMinutes.rawValue, 2700.0)
            default:
                return (ValueLunchTime.NoLunch.rawValue, 0.0)
            }
        }
    
    private func workDayTime(_ timeStart: Date, _ timeStop: Date) -> Double {
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


enum ValueLunchTime: String {
    
    case NoLunch = "-"
    case fifteenMinutes = "15'"
    case thirtyMinutes = "30'"
    case fortyFiveMinutes = "45'"

}

