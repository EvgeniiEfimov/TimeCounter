//
//  ViewController.swift
//  kfcMyTime
//
//  Created by User on 29.01.2022.
//

//import UIKit
import RealmSwift

class СalculatedViewController: UIViewController {
    
    private var jobDataList: Results<ListInfoDate>!
    
    var value: Results<ListInfoDate>! // проба
    let monthName = DataManager.shared.monthArray
    let oneRangeDay = 1...15
    let twoRangeDay = 15...31
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

        readDataAndUpdateUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        allTimeRangeDay.isHidden = true
        amountLabelOutlet.isHidden = true
    }
    
    private func sortDataToMonth(_ monthDay: Int) -> Results<ListInfoDate>! {
        var filtrDate: Results<ListInfoDate>!
            filtrDate = jobDataList.filter("month = \(monthDay)")
            return filtrDate
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func allCalculate( _ textField: String) {
        let intValue = monthPickerView.selectedRow(inComponent: 0)
       value = sortDataToMonth(intValue)
        let newValue = filtrDay(value)
        let allTime = calculatedTime(newValue)
        allTimeRangeDay.text = "\(allTime)"
        amountLabelOutlet.text = calculatedMoney(allTime, textField)
        
    }

    @IBAction func calculateButton(_ sender: UIButton) {
        readDataSettings()
        
    }
    
    private func filtrDay(_ sortDataDayOfMonth: Results<ListInfoDate>) -> [ListInfoDate] {
       
        let rangeDay = (periodSCOutlet.selectedSegmentIndex == 0) ? oneRangeDay : twoRangeDay
        var newList = [ListInfoDate]()
        for day in sortDataDayOfMonth {
            if rangeDay.contains(day.dayOfDateWorkShift) {
                newList.append(day)
            }
        }
        return newList
    }
    
    private func calculatedTime(_ arrayOfDay: [ListInfoDate]) -> Double{
        var allTime = 0.0
        for day in arrayOfDay {
            allTime = allTime + day.timeWork
        }
        return allTime
    }
    
    private func calculatedMoney(_ numberOfHours: Double, _ rate: String) -> String {
        let one = rate
        let two = Double(one) ?? 0
        let doubleRate = two * numberOfHours
        return String(format: "%.2f", doubleRate)
    }
    
    
    private func readDataAndUpdateUI() {
        jobDataList = StorageManager.shared.realm.objects(ListInfoDate.self).sorted(byKeyPath: "dateWorkShift")
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
                                    self.deleteSettings()
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
        let valueSaveSattingUser = SettingsUser()
        valueSaveSattingUser.rateTFOutlet = rateTFOutlet
        
        DispatchQueue.main.async {
            StorageManager.shared.saveSettings(settings: valueSaveSattingUser)

    }
    
}
}
