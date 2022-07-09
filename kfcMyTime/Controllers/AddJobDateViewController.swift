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
    @IBOutlet weak var startTimeJobOutlet: UIDatePicker!
    @IBOutlet weak var stopTimeJobOutlet: UIDatePicker!
    @IBOutlet weak var infoTF: UITextField!
    
    //MARK: - Приватные свойства
    private var listInfoOfMonch: Results<ListInfoOfMonch>!
    private let secondsPerHour = 3600.0
    
    //MARK: - Публичные свойства
    let formatSave = CalculationTime.shared
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
    
    @IBAction func saveButtonAction() {
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
        if stopTimeJobOutlet.date > startTimeJobOutlet.date && stopTimeJobOutlet.date.timeIntervalSince(startTimeJobOutlet.date) <= 24 * secondsPerHour {
            
            let newListInfoOfMonch = ListInfoOfMonch()
            let newListDayOfMonth = DayOfMonth()
            let newListInfoOfDayWork = InfoOfDayWork()
            
            newListInfoOfMonch.nameMonth = nameMonch
            newListInfoOfMonch.numberMonth = numberMonch
            
            
            newListDayOfMonth.dateWorkShift = startTimeJobOutlet.date
            
            let allWorkTime = stopTimeJobOutlet.date.timeIntervalSince(startTimeJobOutlet.date)
            let lunchTime = switchOfLunch.isOn ? determininglunchTime(allWorkTime) : (stringValue: "Не учтен", doubleValue: 0.0)
            
            newListDayOfMonth.timeWork = switchOfLunch.isOn ?
            ((allWorkTime - lunchTime.doubleValue) / secondsPerHour) :
            (allWorkTime / secondsPerHour)
            
            
            newListDayOfMonth.timeWorkStringFormat = formattingTimeWorkOfString(newListDayOfMonth.timeWork)
            newListDayOfMonth.lunchBool = switchOfLunch.isOn
            newListDayOfMonth.nightTimeBool = switchOfNightTime.isOn
            
            newListInfoOfDayWork.timeStart = timeDateFormatter(startTimeJobOutlet.date, "HH:mm")
            newListInfoOfDayWork.timeStop = timeDateFormatter(stopTimeJobOutlet.date, "HH:mm")
            newListInfoOfDayWork.dateWorkShift = timeDateFormatter(startTimeJobOutlet.date, "dd.MM.yy")
            newListInfoOfDayWork.timeStartData = startTimeJobOutlet.date
            newListInfoOfDayWork.timeStopData = stopTimeJobOutlet.date
            newListInfoOfDayWork.lunchString = lunchTime.stringValue
            newListInfoOfDayWork.timeWorkString = formattingTimeWorkOfString(newListDayOfMonth.timeWork)
            if formatSave.workDayTime(startTimeJobOutlet.date, stopTimeJobOutlet.date) > lunchTime.doubleValue {
                newListInfoOfDayWork.workDayTime = ((formatSave.workDayTime(startTimeJobOutlet.date, stopTimeJobOutlet.date)) - lunchTime.doubleValue) / secondsPerHour
                newListInfoOfDayWork.workNightTime = switchOfNightTime.isOn ?
                newListDayOfMonth.timeWork  - newListInfoOfDayWork.workDayTime : 0.0
            } else {
                newListInfoOfDayWork.workDayTime = (formatSave.workDayTime(startTimeJobOutlet.date, stopTimeJobOutlet.date)) / secondsPerHour
                newListInfoOfDayWork.workNightTime = switchOfNightTime.isOn ?
                (newListDayOfMonth.timeWork  - newListInfoOfDayWork.workDayTime) : 0.0
//                print(newListDayOfMonth.timeWork)
//                print(lunchTime.doubleValue / secondsPerHour)
//                print(newListInfoOfDayWork.workNightTime)
            }
//            newListInfoOfDayWork.workDayTime = ((formatSave.workDayTime(startTimeJobOutlet.date, stopTimeJobOutlet.date)) - lunchTime.doubleValue) / secondsPerHour
//            
//            newListInfoOfDayWork.workNightTime = switchOfNightTime.isOn ?
//            newListDayOfMonth.timeWork  - newListInfoOfDayWork.workDayTime : 0.0
//            
            newListInfoOfDayWork.inform = infoTF.text ?? ""
            
            let valueByMonth =  listInfoOfMonch.filter("numberMonth = \(newListInfoOfMonch.numberMonth)")
            if valueByMonth.isEmpty {
                DispatchQueue.main.async {
                    newListDayOfMonth.day = newListInfoOfDayWork
                    newListInfoOfMonch.monch.append(newListDayOfMonth)
                    StorageManager.shared.save(allMonch: newListInfoOfMonch)
                }
            } else {
                newListDayOfMonth.day = newListInfoOfDayWork
                guard let valueMonth = valueByMonth.first else {
                    return false
                }
                StorageManager.shared.save(monch: newListDayOfMonth, in: valueMonth)
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

extension AddJobDateViewController {
    
    private var nameMonch: String {
    let dateFormatMonthName = DateFormatter()
    dateFormatMonthName.dateFormat = "LLLL"
    dateFormatMonthName.locale = Locale(identifier: "Ru-ru")
        return dateFormatMonthName.string(from: self.startTimeJobOutlet.date)
    }
    
    private var numberMonch: Int {
        Calendar.current.dateComponents([.month], from: self.startTimeJobOutlet.date).month ?? 0
    }
    
   private func timeDateFormatter(_ time: Date, _ dateFormat: String) -> String {
       let dateFormatterTime = DateFormatter()
       dateFormatterTime.dateFormat = dateFormat
       dateFormatterTime.locale = Locale(identifier: "RU_RU")
       return dateFormatterTime.string(from: time)
   }
    
    private func formattingTimeWorkOfString(_ timeInterval: Double) -> String {
    let formatter = DateComponentsFormatter()
        formatter.calendar?.locale = Locale(identifier: "Ru-ru")
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated

        return formatter.string(from: TimeInterval(timeInterval * secondsPerHour)) ?? "-"
    }
    
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
}

enum ValueLunchTime: String {
    case NoLunch = "-"
    case fifteenMinutes = "15'"
    case thirtyMinutes = "30'"
    case fortyFiveMinutes = "45'"
}
