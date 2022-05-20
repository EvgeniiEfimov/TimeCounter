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
    var valueSettingNightTime: SettingNightTime!

    let monthName = DataManager.shared.monthArray
    let oneRangeDay = 1...15
    let twoRangeDay = 15...31
    let freeRangeDay = 1...31
    var rateTFOutlet: String = ""
    let monthNumber = Calendar.current.dateComponents([.month], from: Date())

    
    @IBOutlet weak var periodSCOutlet: UISegmentedControl!
    @IBOutlet weak var monthPickerView: UIPickerView!
    @IBOutlet weak var allTimeRangeDay: UILabel!
    @IBOutlet weak var amountLabelOutlet: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        monthPickerView.dataSource = self
        monthPickerView.delegate = self
        monthPickerView.selectRow((monthNumber.month ?? 1), inComponent: 0, animated: true)
        
        
        let titleTextAttributesNormal = [NSAttributedString.Key.foregroundColor: UIColor.systemYellow]
        periodSCOutlet.setTitleTextAttributes(titleTextAttributesNormal, for: .normal)
        let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        periodSCOutlet.setTitleTextAttributes(titleTextAttributesSelected, for: .selected)
        
        jobDataList = StorageManager.shared.realm.objects(ListInfoOfMonch.self).sorted(byKeyPath: "numberMonth")
        valueSettingNightTime = StorageManager.shared.realm.objects(SettingNightTime.self).first
        
        
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
        allTimeRangeDay.text = String(format: "%.1f", (allTime.0 + allTime.1))
        amountLabelOutlet.text = calculatedMoney(allTime.0, allTime.1, textField)
    }

    @IBAction func calculateButton(_ sender: UIButton) {
        readDataSettings()
    }
    
    private func filtrDay(_ sortDataDayOfMonth: ListInfoOfMonch?) -> (Double, Double) {
        guard let monch = sortDataDayOfMonth else { return (0.0,0.0) }
        var rangeDay: ClosedRange<Int>
        switch periodSCOutlet.selectedSegmentIndex {
        case 0: rangeDay = oneRangeDay
        case 1: rangeDay = twoRangeDay
        default:
            rangeDay = freeRangeDay
        }
        var allDayTime = 0.0
        var allNightTime = 0.0
        for day in monch.monch {
            let components = Calendar.current.dateComponents([.day], from: day.dateWorkShift )
            if rangeDay.contains(components.day ?? 0) {
                allDayTime += day.day?.workDayTime ?? 0.0
                allNightTime += day.day?.workNightTime ?? 0.0
            }
        }
        return (allDayTime, allNightTime)
    }
    
        private func calculatedMoney(_ numberOfDayHours: Double, _ numberOfNightHours: Double, _ rate: String) -> String {
            var nightTimePercent = 1.0
            if valueSettingNightTime != nil {
                nightTimePercent += valueSettingNightTime.percent / 100
                print(nightTimePercent)
            }
            let doubleRate = rate.doubleValue * numberOfDayHours + rate.doubleValue * nightTimePercent * numberOfNightHours 
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

extension СalculatedViewController: SaveSettingsRate {
    var settingsUser: settingRateUser! {
        get {
            StorageManager.shared.realm.objects(settingRateUser.self).first
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
//        if settingsUser != nil {
//        StorageManager.shared.deleteSettingsNotification(settings: settingsUser)
//        }
    }
    
    func saveSettings() {

        if settingsUser != nil {
            StorageManager.shared.write {
                settingsUser.rateTFOutlet = rateTFOutlet
            }
        }
        else {
            let newValueSettingsUser = settingRateUser()
            newValueSettingsUser.rateTFOutlet = rateTFOutlet
            StorageManager.shared.saveSettingsRate(rate: newValueSettingsUser)
        }
        }
}

extension String {
    static let numberFormatter = NumberFormatter()
    var doubleValue: Double {
        String.numberFormatter.decimalSeparator = "."
        if let result =  String.numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result = String.numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
}

