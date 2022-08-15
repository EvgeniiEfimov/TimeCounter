//
//  AddJobDateViewController.swift
//  kfcMyTime
//
//  Created by User on 26.10.2021.
//

import UIKit
import RealmSwift
import SPAlert


protocol AddDataViewProtocol: AnyObject {
    
}

class AddJobDateViewController: UIViewController, UITextFieldDelegate, AddDataViewProtocol {
    
    //MARK: - Outlets
    @IBOutlet weak var addButtonOutlet: UIButton!
    @IBOutlet weak var switchOfLunch: UISwitch!
    @IBOutlet weak var switchOfNightTime: UISwitch!
    @IBOutlet weak var startTimeJobOutlet: UIDatePicker!
    @IBOutlet weak var stopTimeJobOutlet: UIDatePicker!
    @IBOutlet weak var infoTF: UITextField!
    
    //MARK: - Приватные свойства
    private var listInfoOfMonch: Results<ListInfoOfMonch>!
    private let secondsPerHour = 3600.0
    
    //MARK: - Публичные свойства
//    let formatSave = CalculationTime.shared
    /// Комплишн
    var saveCompletion: (() -> Void)?
    
    var presenter: AddDataPresenterProtocol!
    let configurator: AddDataConfiguratorProtocol = AddDataConfigurator()
    //MARK: - Методы переопределения родительского класса
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(with: self)
        
        
        infoTF.delegate = self
        /// Инициализация свойства значением из БД
//        listInfoOfMonch = StorageManager.shared.realm.objects(ListInfoOfMonch.self)
    }
    
    //MARK: - Action
    @IBAction func infoOfLunchAction(_ sender: UIButton) {
        showAlertConfigLunchTime()
    }
    
    @IBAction func saveButtonAction() {
        guard saveData() else { return }
        dismiss(animated: true, completion: saveCompletion)
        let data = AddDataStruct(note: infoTF.text,
                                   timeStart: startTimeJobOutlet.date,
                                   timeStop: stopTimeJobOutlet.date,
                                   lunch: switchOfLunch.isOn,
                                   nightTime: switchOfNightTime.isOn)
        presenter.pressSaveButton(data)
    }
    
    @IBAction func switchOfLunchAction(_ sender: UISwitch) {
               if sender.isOn == true {
                   sender.tintColor = UIColor.systemYellow
                   sender.thumbTintColor = UIColor.darkGray
               } else {
                   sender.tintColor = UIColor.darkGray
                   sender.thumbTintColor = UIColor.systemOrange
               }
       }

    //MARK: - Приватные методы
    ///Метод сохранения новых данных в БД
    private func saveData () -> Bool {
        /// Проверка корректности ввода данных
        if stopTimeJobOutlet.date > startTimeJobOutlet.date && stopTimeJobOutlet.date.timeIntervalSince(startTimeJobOutlet.date) <= 24 * secondsPerHour {
            spAlert()
            return true
        } else {
            showAlertNotCorrect()
            return false
        }
    }

    private func showAlertNotCorrect() {
        let alertError = UIAlertController.init(title: "Внимание!",
                                                message: "Не корректная продолжительность смены! \n✷проверь время начала и конца смены! \n✷00:00 является следующим днём \n✷Продолжительность смены не может превышать 24 часа",
                                                preferredStyle: .alert)
        alertError.addAction(.init(title: "Ок",
                                   style: .default,
                                   handler: nil))
        present(alertError,
                animated: true,
                completion: nil)
    }
    
    private func showAlertConfigLunchTime() {
        let alertConfigOfLunchTime = UIAlertController.init(title: "Обеденный перерыв",
                                                            message: "Время обеденного перерыва автоматически вычитается от общего времени смены исходя из действующих стандартов: \nпри продолжительности смены 4-8 часов - 30 минут, \n9 и более часво - 45 минут",
                                                            preferredStyle: .alert)
        alertConfigOfLunchTime.addAction(.init(title: "Ок",
                                               style: .cancel,
                                               handler: nil))
        present(alertConfigOfLunchTime, animated: true, completion: nil)
    }
    
    private func spAlert() {
        let alertView = SPAlertView(title: "Добавлено", preset: .done)
        alertView.duration = 1.3
        alertView.cornerRadius = 12
        alertView.present()
        alertView.backgroundColor = UIColor.darkGray
    }
    
    //MARK: - Публичные свойства
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

struct AddDataStruct {
    let note: String?
    let timeStart: Date
    let timeStop: Date
    let lunch: Bool
    let nightTime: Bool

}
    

