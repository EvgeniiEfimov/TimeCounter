//
//  ViewController.swift
//  kfcMyTime
//
//  Created by User on 29.01.2022.
//

import UIKit
import RealmSwift

class СalculatedViewController: UIViewController {
    
    private var jobDataList: Results<ListInfoOfMonch>!
    
    var value1: ListInfoOfMonch!// проба
    var valueSettingsOfLunchtime = StorageManager.shared.realm.objects(SettingsUser.self)

    let monthName = DataManager.shared.monthArray
    let oneRangeDay = 1...15
    let twoRangeDay = 15...31
    let freeRangeDay = 1...31
    var rateTFOutlet: String = ""

    
    @IBOutlet weak var periodSCOutlet: UISegmentedControl!
    @IBOutlet weak var monthPickerView: UIPickerView!
    @IBOutlet weak var allTimeRangeDay: UILabel!
    @IBOutlet weak var amountLabelOutlet: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        monthPickerView.dataSource = self
        monthPickerView.delegate = self
        monthPickerView.selectRow(1, inComponent: 0, animated: true)
        
        
        let titleTextAttributesNormal = [NSAttributedString.Key.foregroundColor: UIColor.systemYellow]
        periodSCOutlet.setTitleTextAttributes(titleTextAttributesNormal, for: .normal)
        let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        periodSCOutlet.setTitleTextAttributes(titleTextAttributesSelected, for: .selected)
        
        jobDataList = StorageManager.shared.realm.objects(ListInfoOfMonch.self).sorted(byKeyPath: "numberMonth")
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        allTimeRangeDay.isHidden = true
        amountLabelOutlet.isHidden = true
    }
    
    
    private func sortDataToMonth(_ monthDay: Int, _ arrayDayOfMonch: Results<ListInfoOfMonch> ) -> ListInfoOfMonch? {
        
        for monch in arrayDayOfMonch {
            if monch.numberMonth == monthDay {
                return monch
            }
        }
        return nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func allCalculate( _ textField: String) {
        let valuePicker = monthPickerView.selectedRow(inComponent: 0)

        value1 = sortDataToMonth(valuePicker, jobDataList)
        let allTime = filtrDay(value1)
        allTimeRangeDay.text = "\(allTime)"
        amountLabelOutlet.text = calculatedMoney(allTime, textField)
    }

    @IBAction func calculateButton(_ sender: UIButton) {
        readDataSettings()
    }
    
    private func filtrDay(_ sortDataDayOfMonth: ListInfoOfMonch?) -> Double {
        guard let monch = sortDataDayOfMonth else { return 0.0 }
        var rangeDay: ClosedRange<Int>
        switch periodSCOutlet.selectedSegmentIndex {
        case 0: rangeDay = oneRangeDay
        case 1: rangeDay = twoRangeDay
        default:
            rangeDay = freeRangeDay
        }
        var newList = 0.0
        for day in monch.monch {
            let components = Calendar.current.dateComponents([.day], from: day.dateWorkShift )
            if rangeDay.contains(components.day ?? 0) {
               newList += day.timeWork
            }
        }
        return newList
    }
    
    private func calculatedMoney(_ numberOfHours: Double, _ rate: String) -> String {
        let doubleRate = (Double(rate) ?? 0) * numberOfHours
        return String(format: "%.2f", doubleRate)
    }
    
}

extension СalculatedViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return monthName.count
    }
}

extension СalculatedViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return monthName[row]
    }
    
    private func showAlert() {
        let alertError = UIAlertController.init(title: "Часовая ставка",
                                                message:"""
Введи вашу часовую ставку в формате рубли.копейки
""",
                                                preferredStyle: .alert)
        alertError.addTextField { (textField) in
            textField.placeholder = "Рублей / час"
            self.rateTFOutlet = textField.text ?? "10"
            textField.delegate = self
        }
        
        alertError.addAction(.init(title: "Ок",
                                   style: .default,
                                   handler:{ action in
                                    self.allCalculate(self.rateTFOutlet)
                                   // self.deleteSettings()
                                    self.saveSettings()
                                    self.allTimeRangeDay.isHidden = false
                                    self.amountLabelOutlet.isHidden = false
                                   }
                             ))

        present(alertError,
                animated: true,
                completion: nil)
    }
}

extension СalculatedViewController: UITextFieldDelegate {
     func textFieldDidEndEditing(_ textField: UITextField) {
        rateTFOutlet = textField.text ?? ""
    }
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        allCalculate(rateTFOutlet)
        return true
    }
}

extension СalculatedViewController: SaveSettings {
    var settingsUser: SettingsUser! {
        get {
            StorageManager.shared.realm.objects(SettingsUser.self).first
        }
    }
    
    func readDataSettings() {
        guard settingsUser != nil else { return
            showAlert()
        }
        if settingsUser.rateTFOutlet.isEmpty {
            showAlert()
        }
        allCalculate(settingsUser.rateTFOutlet)
        allTimeRangeDay.isHidden = false
        amountLabelOutlet.isHidden = false
    }
    
    func deleteSettings() {
        if settingsUser != nil {
        StorageManager.shared.deleteSettings(settings: settingsUser)
        }
    }
    
    func saveSettings() {

        if settingsUser != nil {
            StorageManager.shared.write {
                settingsUser.rateTFOutlet = rateTFOutlet
            }
        }
        else {
            let newValueSettingsUser = SettingsUser()
            newValueSettingsUser.rateTFOutlet = rateTFOutlet
            StorageManager.shared.saveSettings(settings: newValueSettingsUser)
        }
        
}
}

