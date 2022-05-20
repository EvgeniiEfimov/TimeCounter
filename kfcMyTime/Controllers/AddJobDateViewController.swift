//
//  AddJobDateViewController.swift
//  kfcMyTime
//
//  Created by User on 26.10.2021.
//

import UIKit
import RealmSwift
import SPAlert

class AddJobDateViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var addButtonOutlet: UIButton!
    @IBOutlet weak var switchOfLunch: UISwitch!
    @IBOutlet weak var switchOfNightTime: UISwitch!
    @IBOutlet weak var dataDayOutlet: UIDatePicker!
    @IBOutlet weak var startTimeJobOutlet: UIDatePicker!
    @IBOutlet weak var stopTimeJobOutlet: UIDatePicker!
    @IBOutlet weak var infoTF: UITextField!
    
    //MARK: - Приватные свойства
    private var listInfoOfMonch: Results<ListInfoOfMonch>!
    
    //MARK: - Публичные свойства
    let formatSave = FormatSave.shared
    /// Комплишн
    var saveCompletion: (() -> Void)?
    
    //MARK: - Методы переопределения родительского класса
    override func viewDidLoad() {
        super.viewDidLoad()
        infoTF.delegate = self
        /// Инициализация свойства значением из БД
        listInfoOfMonch = StorageManager.shared.realm.objects(ListInfoOfMonch.self)
    }
    
    //MARK: - Action
    @IBAction func infoOfLunchAction(_ sender: UIButton) {
        showAlertConfigLunchTime()
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        guard saveData() else { return }
        dismiss(animated: true, completion: saveCompletion)
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
        if stopTimeJobOutlet.date > startTimeJobOutlet.date {
            
            let newListInfoOfMonch = ListInfoOfMonch()
            let newListDayOfMonth = DayOfMonth()
            let newListInfoOfDayWork = InfoOfDayWork()
            
            let dateFormatMonthName = DateFormatter()
            dateFormatMonthName.dateFormat = "LLLL"
            dateFormatMonthName.locale = Locale(identifier: "Ru-ru")
            
            let components = Calendar.current.dateComponents([.day, .month, .minute, .hour], from: dataDayOutlet.date)
            
            
            newListInfoOfMonch.nameMonth = dateFormatMonthName.string(from: dataDayOutlet.date)
            newListInfoOfMonch.numberMonth = components.month ?? 0
            
            
            newListDayOfMonth.dateWorkShift = dataDayOutlet.date
            
            let allWorkTime = formatSave.timeWorkDouble(startTimeJobOutlet.date, stopTimeJobOutlet.date)
            let lunchTime = formatSave.lunchTime(allWorkTime, switchOfLunch.isOn)
            
            newListDayOfMonth.timeWork = switchOfLunch.isOn ?
            ((allWorkTime - lunchTime.1) / 3600) :
            (allWorkTime / 3600)
            
            
            newListDayOfMonth.timeWorkFormat = formatSave.timeWorkOfFormatString(newListDayOfMonth.timeWork)
            newListDayOfMonth.lunchBool = switchOfLunch.isOn
            newListDayOfMonth.nightTimeBool = switchOfNightTime.isOn
            
            newListInfoOfDayWork.timeStart = startTimeJobOutlet.date
            newListInfoOfDayWork.timeStop = stopTimeJobOutlet.date
            newListInfoOfDayWork.dateWorkShift = dataDayOutlet.date
            newListInfoOfDayWork.lunchString = lunchTime.0
            newListInfoOfDayWork.timeWorkString = formatSave.timeWorkOfFormatString(newListDayOfMonth.timeWork)
            newListInfoOfDayWork.workDayTime = ((formatSave.workDayTime(startTimeJobOutlet.date, stopTimeJobOutlet.date)) - lunchTime.1 / 60) / 60
            newListInfoOfDayWork.workNightTime = switchOfNightTime.isOn ? newListDayOfMonth.timeWork  - newListInfoOfDayWork.workDayTime : 0.0
            
            newListInfoOfDayWork.inform = infoTF.text ?? ""
            
            let value =  listInfoOfMonch.filter("numberMonth = \(newListInfoOfMonch.numberMonth)")
            if value.isEmpty {
                DispatchQueue.main.async {
                    newListDayOfMonth.day = newListInfoOfDayWork
                    newListInfoOfMonch.monch.append(newListDayOfMonth)
                    StorageManager.shared.save(allMonch: newListInfoOfMonch)
                }
            } else {
                newListDayOfMonth.day = newListInfoOfDayWork
                StorageManager.shared.save(monch: newListDayOfMonth, in: value.first!)
            }
            spAlert()
            return true
        } else {
            showAlertNotCorrect()
            return false
        }
    }

    private func showAlertNotCorrect() {
        let alertError = UIAlertController.init(title: "Внимание!",
                                                message: "Не корректная продолжительность смены! проверь время начала и конца смены! \n00:00 является следующим днём",
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
