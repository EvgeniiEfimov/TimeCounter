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
    @IBOutlet weak var switchOfLunch: UISwitch!
    @IBOutlet weak var dataDayOutlet: UIDatePicker!
    @IBOutlet weak var startTimeJobOutlet: UIDatePicker!
    @IBOutlet weak var stopTimeJobOutlet: UIDatePicker!
    
    private var listInfoOfMonch: Results<ListInfoOfMonch>!
    
    let formatSave = FormatSave.shared
    
    var saveCompletion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listInfoOfMonch = StorageManager.shared.realm.objects(ListInfoOfMonch.self)
    }
        
    private func markButtonBool(_ markName: String, _ markOutlet: UIButton) {
        markOutlet.setImage(UIImage.init(systemName: markName), for: .normal)
    }
    
    private func saveData () -> Bool {
        
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
            newListDayOfMonth.timeWork = formatSave.lunchTimeString(startTimeJobOutlet.date,
                                                                   stopTimeJobOutlet.date,
                                                                    switchOfLunch.isOn).1
            newListDayOfMonth.timeWorkFormat = formatSave.timeWorkOfFormatString(newListDayOfMonth.timeWork)
            newListDayOfMonth.lunchBool = switchOfLunch.isOn
            
            
            newListInfoOfDayWork.timeStart = startTimeJobOutlet.date
            newListInfoOfDayWork.timeStop = stopTimeJobOutlet.date
            newListInfoOfDayWork.dateWorkShift = dataDayOutlet.date
            newListInfoOfDayWork.lunchString = formatSave.lunchTimeString(startTimeJobOutlet.date,
                                                                          stopTimeJobOutlet.date,
                                                                          switchOfLunch.isOn).0
            newListInfoOfDayWork.timeWorkString = formatSave.timeWorkOfFormatString(newListDayOfMonth.timeWork)
            
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
