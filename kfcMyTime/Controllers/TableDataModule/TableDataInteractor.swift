//
//  TableDataInteractor.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 08.08.2022.
//

import Foundation
import RealmSwift

protocol TableDataInteractorProtocol: AnyObject {
    var startInfo: Results<ListInfoOfMonch>? { get }
    var settingsView: Results<SettingRateAndFormatDate>? { get }
    
    func deleteDay(_ indexPath: IndexPath)
}

class TableDataInteractor: TableDataInteractorProtocol {
    
    weak var presenter: TableDataPresenterProtocol!
    let dataService: DataServiceProtocol = DataService()
    let settingService: SettingServiceProtocol = SettingService()
    let alertService: AlertServiceProtocol = AlertService()

    required init(presenter: TableDataPresenterProtocol) {
        self.presenter = presenter
    }
    var startInfo: Results<ListInfoOfMonch>? {
    get {
        return dataService.listInfoOfMonch
    }
    }
    
    var settingsView: Results<SettingRateAndFormatDate>? {
        get {
            return settingService.settingData
        }
    }
    
    func deleteDay(_ indexPath: IndexPath) {
        guard let listInfoOfMonch = startInfo else { return }
        /// Определение свойства месяца, соответствующего номеру секции
        let monch = listInfoOfMonch[indexPath.section]
        /// Сортировка массива дней месяца
        let daySorted = monch.monch.sorted(byKeyPath: "dateWorkShift")
        /// Присвоения свойству дня, соответствующего номеру строки таблицы
        let days = daySorted[indexPath.row]
        guard let day = days.day else { return }
        
        dataService.deleteDayOfMonth(monch: days, in: monch)
        dataService.deleteDayInfo(day: day)
        
        // Проверка количества дней в месяце секции
            if monch.monch.count == 0 {
                /// Удаление месяца (Если нет записанных дней)
                dataService.deleteMonch(allMonch: monch)
                /// Удаление секции "пустого" (удаленного) месяца
                presenter.deleteSection(indexPath)
                /// Вызов визуального эффекта (подтверждения) удаления
            } else {
                /// Удаление ячейки удаленного дня
                presenter.deleteRow(indexPath)
                /// Вызов визуального эффекта (подтверждения) удаления
            }
        presenter.showSpAlert(alertService.spAlertDelete)
    }

}
