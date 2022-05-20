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
    /// Кнопка определения часовой ставки
    @IBOutlet weak var rateButton: UIButton!
    
    //MARK: - Приватные свойства
    /// Объявление свойства хранения данных ставки
    private var settingRate: settingRateUser!
    /// Инициализация свойства доступа к StorageManager
    private let storageManager = StorageManager.shared
    
    //MARK: - Публичные свойства
    /// Объявление свойства хранения
    var rateTF: String = ""
    
    //MARK: - Методы переопределения родительского класса
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Инициализация свойства данными из БД
        settingRate = StorageManager.shared.realm.objects(settingRateUser.self).first
        /// Проверка свойства на наличие информации в БД
        if settingRate != nil {
            /// Инициализация тайтла кнопки данными из БД
            rateButton.setTitle(settingRate.rateTFOutlet, for: .normal)
        } else {
            /// Инициализация тайтла кнопки базовым значение
            rateButton.setTitle("Ставка", for: .normal)
        }
        /// Настройка цвета тайтла
        rateButton.setTitleColor(.systemYellow, for: .normal)
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
    
    //MARK: - Action
    /// Кнопка настройки часовой ставки
    @IBAction func rateButtonAction(_ sender: UIButton) {
        alertRate()
    }
    
    //MARK: - Приватные методы
    /// Метод инициализации часовой ставки и представления алерта
    private func alertRate() {
        /// Инициализация алерта
        let alertRate = UIAlertController.init(title: "Часовая ставка",
                                                message: nil,
                                                preferredStyle: .alert)
        /// Добавление и инициализация поля ввода текста в алерт
        alertRate.addTextField { (textField) in
            textField.placeholder = "Руб/час"
            self.rateTF = textField.text ?? "0"
            textField.delegate = self
        }
        /// Добавления  и инициализация кнопки "Сохранить" в алерт
        alertRate.addAction(.init(title: "Сохранить",
                                  style: .default,
                                  handler: { (action) in
            /// Проверка свойства хранения данных из БД на наличия данных
            guard self.settingRate != nil else {
                ///  Инициализация свойства экземпляром класса
                let setting = settingRateUser()
                /// Присвоение значения ставки свойству хранения в БД
                setting.rateTFOutlet = self.rateTF
                /// Сохранение в БД экземпляра
                self.storageManager.saveSettingRate(settings: setting)
                /// Установка нового тайтла кнопки установки ставки
                self.rateButton.setTitle(setting.rateTFOutlet, for: .normal)
                return
            }
            /// Чтенине данных о ставке из БД
            self.storageManager.write {
                /// Присвоение нового значения свойству хранения информации в БД
                self.settingRate.rateTFOutlet = self.rateTF
                /// Установка нового тайтла кнопки
                self.rateButton.setTitle(self.settingRate.rateTFOutlet, for: .normal)
            }
        }))
        /// Показ алерта
        present(alertRate,
                animated: true,
                completion: nil)
    }
}

/// Расширение родительского класса
extension SettingsTableViewController: UITextFieldDelegate {
    /// Метод завершения работы с текстовым полем
     func textFieldDidEndEditing(_ textField: UITextField) {
         /// Присвоения текстовому полю нового значения 
         rateTF = textField.text ?? ""
    }
}
