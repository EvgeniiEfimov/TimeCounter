//
//  SettingsTableViewController.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 10.04.2022.
//

import UIKit
import RealmSwift

class SettingsTableViewController: UITableViewController {
        //MARK: - Outlet
    /// Outlet  на TF
    @IBOutlet weak var rateTextFieldOutlet: UITextField!
    /// Outlet на segmentControl
    @IBOutlet weak var formatSegmentControlOutlet: UISegmentedControl!
    
    //MARK: - Приватные свойства
    /// Объявление свойства хранения данных ставки
    private var settingRate: SettingRateAndFormatDate!
    /// Инициализация свойства доступа к StorageManager
    private let storageManager = StorageManager.shared
    
    //MARK: - Методы переопределения родительского класса
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rateTextFieldOutlet.delegate = self

        /// Инициализация свойства данными из БД
        settingRate = StorageManager.shared.realm.objects(SettingRateAndFormatDate.self).first
        /// Проверка свойства на наличие информации в БД
        if settingRate != nil {
            /// Инициализация SegmentControl данными из БД
            formatSegmentControlOutlet.selectedSegmentIndex = settingRate.formatSegmentControl
            /// Инициализация TF данными из БД
            rateTextFieldOutlet.text = settingRate.rateTFOutlet
            ///
//            rateButton.setTitle(settingRate.rateTFOutlet, for: .normal)
        } else {
            /// Инициализация TF базовым значение
            rateTextFieldOutlet.text = "Ставка"
            /// Инициализация SegmentControl базовым значением
            formatSegmentControlOutlet.selectedSegmentIndex = 1
        }
        /// Настройка цвета тайтла
//        rateButton.setTitleColor(.systemYellow, for: .normal)
    }
    /// Переопределения метода конфигурации заголовка секции
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        /// Приведение  view к UITableViewHeaderFooterView
        let header = view as! UITableViewHeaderFooterView
        /// Объявление и присвоение свойству дефолтных конфигураций
        var content = header.defaultContentConfiguration()
        /// Присвоение значения свойству text
        content.text = "Настройки"
        /// Присвоение значения свойству font имя и размер шрифта
        content.textProperties.font = UIFont.init(name: "Zapf DingBats", size: 18.0)!
        /// Присвоение значения цвета свойству color
        content.textProperties.color = UIColor.systemYellow
        /// Присвоение конфигурации header
        header.contentConfiguration = content
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        /// Проверка наличия информации в БД
        guard settingRate != nil else {
            /// Создаем экземпляр
            let settingFormatSelect = SettingRateAndFormatDate()
            settingFormatSelect.formatSegmentControl = formatSegmentControlOutlet.selectedSegmentIndex
            settingFormatSelect.rateTFOutlet = rateTextFieldOutlet.text ?? "Ставка"
            self.storageManager.saveSettingRate(settings: settingFormatSelect)
            return
        }
        storageManager.write {
            settingRate.formatSegmentControl = formatSegmentControlOutlet.selectedSegmentIndex
            settingRate.rateTFOutlet = rateTextFieldOutlet.text ?? "Ставка"
        }
    }
    
    //MARK: - Action
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        alertOfDeleteAll()
    }
    
    
    //MARK: - Приватные методы

}

/// Расширение родительского класса
extension SettingsTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       return true
   }
}

extension SettingsTableViewController {
    ///  Метод вызова алерта отчистки БД
    private func alertOfDeleteAll() {
        /// Инициализация алерта
        let alertDelete = UIAlertController.init(title: "Удалить все записанные смены?",
                                                message: "Вы действительно хотите удалить все записанные смены без возможности восстановления?",
                                                preferredStyle: .alert)
        /// Добавление кнопки в алерт
        alertDelete.addAction(.init(title: "Да",
                                    style: .destructive,
                                    handler: { (UIAlertAction) in
            StorageManager.shared.deleteAllListInfo()
                //  self.tableView.reloadData()
        }))
        /// Добавление кнопки в алерт
        alertDelete.addAction(.init(title: "Нет",
                                    style: .default,
                                    handler: nil))
        /// Представление алерта
        present(alertDelete,
                animated: true,
                completion: nil)
    }
}
