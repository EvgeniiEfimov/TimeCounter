//
//  AddJobDateViewController.swift
//  kfcMyTime
//
//  Created by User on 26.10.2021.
//

import UIKit
import RealmSwift
import SPAlert

class AddJobDateViewController: UIViewController {

    @IBOutlet weak var addButtonOutlet: UIButton!
    @IBOutlet weak var markDoublePayOutlet: UIButton!
    @IBOutlet weak var dataDayOutlet: UIDatePicker!
    @IBOutlet weak var startTimeJobOutlet: UIDatePicker!
    @IBOutlet weak var stopTimeJobOutlet: UIDatePicker!
    
    var saveCompletion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    private func markButtonBool(_ markName: String, _ markOutlet: UIButton) {
        markOutlet.setImage(UIImage.init(systemName: markName), for: .normal)
    }
    
    private func saveData () -> Bool {
        
        if stopTimeJobOutlet.date > startTimeJobOutlet.date {
            
            let newListInfo = ListInfoDate()
            
            let dateFormatMonthName = DateFormatter()
            dateFormatMonthName.dateFormat = "MMMM"
            dateFormatMonthName.locale = Locale(identifier: "Ru-ru")
            
            let components = Calendar.current.dateComponents([.day, .month, .minute, .hour], from: dataDayOutlet.date)
            let componentsTime = Calendar.current.dateComponents([.hour, .minute], from:startTimeJobOutlet.date , to:stopTimeJobOutlet.date)

            
            let timeWorkCalculation = stopTimeJobOutlet.date.timeIntervalSince(startTimeJobOutlet.date)
            print(timeWorkCalculation)
            newListInfo.dateWorkShift = dataDayOutlet.date
            newListInfo.fullTimeWork = calculationOfWorkingHours(timeWorkCalculation, calculationLunchTime(timeWorkCalculation))
            newListInfo.timeWorkWithLunch = calculationOfWorkingHours(timeWorkCalculation, 0.0)
            newListInfo.timeStart = startTimeJobOutlet.date
            newListInfo.timeStop = stopTimeJobOutlet.date
            newListInfo.lunch = calculationLunchTime(timeWorkCalculation)
            newListInfo.dayOfDateWorkShift = components.day ?? 0
            newListInfo.month = components.month ?? 0
            newListInfo.monthNameString = dateFormatMonthName.string(from: dataDayOutlet.date)
            newListInfo.timeWorkHour = componentsTime.hour ?? 0
            newListInfo.timeWorkMinute = componentsTime.minute ?? 0
            
            
            
            DispatchQueue.main.async {
                StorageManager.shared.saveListInfo(infoList: newListInfo)
            }
            spAlert() 
            return true
        } else {
            showAlert()
            return false
        }
    }
    
    private func showAlert() {
        let alertError = UIAlertController.init(title: "Стоп-стоп-стоп!",
                                                message: "Не корректная продолжительность смены! проверь время начала и конца смены",
                                                preferredStyle: .alert)
        alertError.addAction(.init(title: "Ок",
                                   style: .default,
                                   handler: nil))
        present(alertError,
                animated: true,
                completion: nil)
    }
    
    private func calculationOfWorkingHours(_ timeWork: TimeInterval,_ lunchTime: Double) -> Double {
        
        return Double(String(format: "%.1f", (timeWork / 3600.0 - lunchTime))) ?? 0.2
        }
    
    private func calculationLunchTime(_ timeWork: TimeInterval) -> Double {
        switch timeWork {
        case (14401...32399):
            return 0.5
        case (32400...):
            return 0.8
        default:
            return 0.0
        }
    }
    
    private func spAlert() {
        let alertView = SPAlertView(title: "Добавлено", preset: .done)
        alertView.duration = 1.3
        alertView.cornerRadius = 12
        alertView.present()
        alertView.backgroundColor = UIColor.darkGray
    }
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        guard saveData() else { return }
        dismiss(animated: true, completion: saveCompletion)
    }
    
    
}
