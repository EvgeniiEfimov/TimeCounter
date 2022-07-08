//
//  ViewController.swift
//  kfcMyTime
//
//  Created by User on 29.01.2022.
//

import UIKit
import RealmSwift

class СalculatedViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var periodSCOutlet: UISegmentedControl!
    @IBOutlet weak var monthPickerView: UIPickerView!
    @IBOutlet weak var allTimeRangeDayOutlet: UILabel!
    @IBOutlet weak var amountLabelOutlet: UILabel!
    
    @IBOutlet weak var buttonCalculatedOutlet: UIButton!
    
    //MARK: - Приватные свойства
    private var jobDataList: Results<ListInfoOfMonch>?
    private var listInfoOfMonth = ListInfoOfMonch()
    private var valueSettingNightTime: Results<SettingNightTime>!
    private var rateSetting: Results<SettingRateAndFormatDate>!
    
    private var rateTF: String = ""
    
    private var range: ClosedRange<Int> {
        switch periodSCOutlet.selectedSegmentIndex {
        case 0: return oneRangeDay
        case 1: return twoRangeDay
        default: return freeRangeDay
        }
    }
    
    private let oneRangeDay = 1...15
    private let twoRangeDay = 15...31
    private let freeRangeDay = 1...31
    
    
    private let monthNumber = Calendar.current.dateComponents([.month], from: Date())
    
    //MARK: - Методы переопределения родительского класса
    override func viewDidLoad() {
        super.viewDidLoad()
        monthPickerView.dataSource = self
        monthPickerView.delegate = self
        /// Вызов метода стартовых настроек view
        startSetView()
        valueSettingNightTime = StorageManager.shared.realm.objects(SettingNightTime.self)
        rateSetting = StorageManager.shared.realm.objects(SettingRateAndFormatDate.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let valueJobDataList = jobDataList?.first else {
            buttonCalculatedOutlet.isUserInteractionEnabled = false
            buttonCalculatedOutlet.alpha = 0.5
            allTimeRangeDayOutlet.isHidden = true
            amountLabelOutlet.isHidden = true
            monthPickerView.reloadAllComponents()
                        return
        }
        listInfoOfMonth = valueJobDataList
        buttonCalculatedOutlet.alpha = 1
        buttonCalculatedOutlet.isUserInteractionEnabled = true
        allTimeRangeDayOutlet.isHidden = true
        amountLabelOutlet.isHidden = true
        monthPickerView.reloadAllComponents()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - Actions
    
    @IBAction func button() {
        guard let rate = rateSetting.first?.rateTFOutlet else {
            showAlert()
            return
        }
        allTimeRangeDayOutlet.isHidden = false
        amountLabelOutlet.isHidden = false
        guard let valueJobDataList = jobDataList else {
            return
        }
        let arrayDay = filtrDayOfMonth(valueJobDataList[monthPickerView.selectedRow(inComponent: 0)], range)
        let allTimeDayAndNight = countAllDayAndNightClock(arrayDay)
        allTimeRangeDayOutlet.text = String(format: "%.1f", (allTimeDayAndNight.allDayTime + allTimeDayAndNight.allNightTime))
        amountLabelOutlet.text = calculatedMoney(allTimeDayAndNight.allDayTime,
                                                 allTimeDayAndNight.allNightTime,
                                                 rate)
    }
    
    //MARK: - Приватные методы
    private func startSetView() {
        monthPickerView.selectRow((monthNumber.month ?? 1), inComponent: 0, animated: true)
        let titleTextAttributesNormal = [NSAttributedString.Key.foregroundColor: UIColor.systemYellow]
        periodSCOutlet.setTitleTextAttributes(titleTextAttributesNormal, for: .normal)
        let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        periodSCOutlet.setTitleTextAttributes(titleTextAttributesSelected, for: .selected)
    }
    
    /// Фильтрация дней соответствующих выбранному периоду
    private func filtrDayOfMonth(_ DataDayMonth: ListInfoOfMonch, _ rangeDay: ClosedRange<Int>) -> [DayOfMonth] {
        var arrayFiltrDay = [DayOfMonth]()
        for day in DataDayMonth.monch {
            let components = Calendar.current.dateComponents([.day], from: day.dateWorkShift )
            if rangeDay.contains(components.day ?? 0) {
                arrayFiltrDay.append(day)
            }
        }
        return arrayFiltrDay
    }
    
    /// Подсчет всех дневных и ночных часов
    private func countAllDayAndNightClock(_ arrayWorkDay: [DayOfMonth]) -> (allDayTime: Double, allNightTime: Double) {
        var allDayTime = 0.0
        var allNightTime = 0.0
        for day in arrayWorkDay {
            allDayTime += day.day?.workDayTime ?? 0.0
            allNightTime += day.day?.workNightTime ?? 0.0
        }
        return (allDayTime, allNightTime)
    }
    
    private func calculatedMoney(_ allDayTime: Double, _ allNightTime: Double, _ rate: String) -> String {
        var nightTimePercent = 1.0
        if valueSettingNightTime != nil {
            nightTimePercent += (valueSettingNightTime.first?.percent ?? 0) / 100
        }
        let doubleRate = rate.doubleValue * allDayTime + rate.doubleValue * nightTimePercent * allNightTime
        guard rate.doubleValue != 0.0 else {
            showAlert()
            return ""
        }
        return String(format: "%.2f", doubleRate)
    }
}
//MARK: - Расширения класса
extension СalculatedViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         jobDataList = StorageManager.shared.realm.objects(ListInfoOfMonch.self).sorted(byKeyPath: "numberMonth")
        return (jobDataList?.first != nil ? (jobDataList?.count ?? 1) : 1)
    }
}

extension СalculatedViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard jobDataList?.first != nil else {
            return "Нет данных"
        }
        return jobDataList?[row].nameMonth
    }
    private func showAlert() {
        let alertError = UIAlertController.init(title: "Часовая ставка",
                                                message:"""
Введи вашу часовую ставку в формате рубли.копейки
""",
                                                preferredStyle: .alert)
        alertError.addTextField { (textField) in
            textField.placeholder = "Рублей / час"
            self.rateTF = textField.text ?? "10"
            textField.delegate = self
        }
        
        alertError.addAction(.init(title: "Ок",
                                   style: .default,
                                   handler:{ action in
            self.saveSettings()
            self.allTimeRangeDayOutlet.isHidden = false
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
        rateTF = textField.text ?? ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        button()
        return true
    }
}

extension СalculatedViewController {
    func saveSettings() {
        guard let rate = rateSetting.first  else {
            let newValueSettingsUser = SettingRateAndFormatDate()
            newValueSettingsUser.rateTFOutlet = rateTF
            StorageManager.shared.saveSettingsRate(rate: newValueSettingsUser)
            return
        }
        StorageManager.shared.write {
            rate.rateTFOutlet = rateTF
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

