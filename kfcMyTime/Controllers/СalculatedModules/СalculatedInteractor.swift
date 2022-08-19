//
//  СalculatedInteractor.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 18.08.2022.
//

import Foundation

protocol CalculatedInteractorProtocol: AnyObject {
    func calculated(_ valuePickerView: Int, _ indexSegmentedControl: Int)
    func saveRate(_ rate: String)
    var getArrayNameOfMonth: [String] { get }
//    var getArrayNameOfMonthCount: Int { get }
}

final class CalculatedInteractor: CalculatedInteractorProtocol {
    weak var presenter: CalculatedPresenterProtocol!
    let dataService: DataServiceProtocol = DataService()
    let settingService: SettingServiceProtocol = SettingService()
    let alertService: AlertServiceProtocol = AlertService()
    
    required init(presenter: CalculatedPresenterProtocol) {
        self.presenter = presenter
    }
    
    var getArrayNameOfMonth: [String] {
        var array: [String] = []
        for valueData in dataService.listInfoOfMonch {
            array.append(valueData.nameMonth)
        }
        return array
    }
    
    func calculated(_ valuePickerView: Int, _ indexSegmentedControl: Int) {
        guard let setting = settingService.settingData?.rateTFOutlet else {
            presenter.showAlert(alertService.alertSaveRate)
            return
          }
             var range: ClosedRange<Int> {
                switch indexSegmentedControl {
                case 0: return 1...15
                case 1: return 15...31
                default: return 1...31
                }
            }
        let dayArray = filtrDayOfMonth(dataService.listInfoOfMonch[valuePickerView], range)
        let allTimeDayAndNight = countAllDayAndNightClock(dayArray)
        
        var allTime: String {
            String(format: "%.1f", (allTimeDayAndNight.allDayTime + allTimeDayAndNight.allNightTime))
        }
        
        presenter.calculateValue(allTime, calculatedMoney(allTimeDayAndNight.allDayTime,
                                                                                 allTimeDayAndNight.allNightTime,
                                                                                 setting))
    }
    

    func saveRate(_ rate: String) {
        settingService.saveSettings(rate)
    }
    
    private func filtrDayOfMonth(_ DataDayMonth: ListInfoOfMonch, _ rangeDay: ClosedRange<Int>) -> [DayOfMonth] {
            var arrayFiltrDay = [DayOfMonth]()
            for day in DataDayMonth.monch {
                let components = Calendar.current.dateComponents([.day], from: day.dateWorkShift )
                if rangeDay.contains(components.day ?? 0) {
                    arrayFiltrDay.append(day)
                }
            }
            return arrayFiltrDay
        }
    
    /// Подсчет всех дневных и ночных часов
    private func countAllDayAndNightClock(_ arrayWorkDay: [DayOfMonth]) -> (allDayTime: Double, allNightTime: Double) {
        var allDayTime = 0.0
        var allNightTime = 0.0
        for day in arrayWorkDay {
            allDayTime += day.day?.workDayTime ?? 0.0
            allNightTime += day.day?.workNightTime ?? 0.0
        }
        return (allDayTime, allNightTime)
    }
    
        private func calculatedMoney(_ allDayTime: Double, _ allNightTime: Double, _ rate: String) -> String {
            var nightTimePercent = 1.0
            if let valueSettingNightTime = settingService.valueSettingNightTime {
                nightTimePercent += valueSettingNightTime.percent / 100
            }
            let doubleRate = rate.doubleValue * allDayTime + rate.doubleValue * nightTimePercent * allNightTime
            guard rate.doubleValue != 0.0 else {
                presenter.showAlert(alertService.alertSaveRate)
                return ""
            }
            return String(format: "%.2f", doubleRate)
        }
}
