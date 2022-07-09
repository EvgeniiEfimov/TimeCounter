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
    private var settingRate: Results <SettingRateAndFormatDate>?
    /// Инициализация свойства доступа к StorageManager
    private let storageManager = StorageManager.shared
    
    //MARK: - Методы переопределения родительского класса
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = UIImageView(image: UIImage(named: "269"))
        tableView.backgroundView?.contentMode = .scaleAspectFill
        tableView.backgroundView?.alpha = 0.6
        tableView.backgroundColor = UIColor.gray
        
        rateTextFieldOutlet.delegate = self

        /// Инициализация свойства данными из БД
        settingRate = StorageManager.shared.realm.objects(SettingRateAndFormatDate.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let settingValue = settingRate?.first else {
            rateTextFieldOutlet.text = "Ставка"
            formatSegmentControlOutlet.selectedSegmentIndex = 1
            return
        }
        formatSegmentControlOutlet.selectedSegmentIndex = settingValue.formatSegmentControl
        rateTextFieldOutlet.text = settingValue.rateTFOutlet

        animationCell()
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
        guard let saveValue = settingRate?.first else {
            /// Создаем экземпляр
            let settingFormatSelect = SettingRateAndFormatDate()
            settingFormatSelect.formatSegmentControl = formatSegmentControlOutlet.selectedSegmentIndex
            settingFormatSelect.rateTFOutlet = rateTextFieldOutlet.text ?? "Ставка"
            self.storageManager.saveSettingRate(settings: settingFormatSelect)
            return
        }
        storageManager.write {
            saveValue.formatSegmentControl = formatSegmentControlOutlet.selectedSegmentIndex
            saveValue.rateTFOutlet = rateTextFieldOutlet.text ?? "Ставка"
        }
    }
    
    //MARK: - Action
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        alertOfDeleteAll()
    }
    
    
    //MARK: - Приватные методы

    private func animationCell() {
        let cells = tableView.visibleCells
        let height =  -tableView.bounds.width
        var delay: Double = 0
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: height, y: height)
            
            UIView.animate(withDuration: 0.4,
                           delay: delay * 0.05,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: { cell.transform = CGAffineTransform.identity})
            delay += 1
        }
    }
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
            self.rateTextFieldOutlet.text = "Ставка"
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
