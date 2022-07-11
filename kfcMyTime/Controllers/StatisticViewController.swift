//
//  StatisticViewController.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 24.05.2022.
//

import UIKit
import Alamofire
import RealmSwift
import Spring

class StatisticViewController: UIViewController {

    @IBOutlet weak var labelNoData: UILabel!
    
    @IBOutlet weak var scrollViewOutlet: UIScrollView!
    @IBOutlet weak var labelTitleTargetOutlet: UILabel!
    @IBOutlet weak var labelInfoToMonchOutlet: UILabel!
    @IBOutlet weak var textFieldSelectMonthOutlet: UITextField!
    
    @IBOutlet weak var imageViewOutlet: SpringImageView!
    @IBOutlet weak var imageViewTwoOutlet: SpringImageView!
    @IBOutlet weak var imageViewTree: SpringImageView!
    @IBOutlet weak var imageViewFore: SpringImageView!
    @IBOutlet weak var monchStatisticLabel: UILabel!
    
    var arrayMonch: Results <ListInfoOfMonch>?
    var monthData: ListInfoOfMonch?
    
    var valueTarget = Double()
    var textFieldAlertValue = String()
    var picker = UIPickerView()
    var tapBar = UIToolbar()
    let monthNameArray = ["январь", "февраль", "март", "апрель", "май", "июнь", "июль", "август",
                          "сентябрь", "октябрь", "ноябрь", "декабрь"]
    let date = Calendar.current.dateComponents([.month], from: Date())
    lazy var valueMonth = date.month ?? 0
    
    override func viewDidLoad() {
        
        picker.delegate = self
        picker.dataSource = self
        
        getPickerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        arrayMonch = StorageManager.shared.realm.objects(ListInfoOfMonch.self).sorted(byKeyPath: "numberMonth")
        
        guard arrayMonch?.first != nil else {
            scrollViewOutlet.isHidden = true
            labelNoData.isHidden = false
            return
        }
        scrollViewOutlet.isHidden = false
        labelNoData.isHidden = true

        loadTargetImage(valueMonth)
        loadNightAndDayClock(valueMonth)
        loadeStatisticDayOfMonch(valueMonth)
        loadStatisticToMonch()
    }
    
    private func loadTargetImage(_ month: Int) {

        guard let valueByMonth =  arrayMonch?.filter("numberMonth = \(month)").first else {
           
            labelInfoToMonchOutlet.text = "Увы, нет данных по текущему месяцу =("
            imageViewOutlet.image = UIImage.init(named: "noData")
            textFieldSelectMonthOutlet.text = monthNameArray[month - 1]
            return
        }
        monthData = valueByMonth
        textFieldSelectMonthOutlet.text = valueByMonth.nameMonth
        valueTarget = ((valueByMonth.allWorkTimeOfMonch ) / (valueByMonth.targetMonth <= 0.0 ? 1000 : valueByMonth.targetMonth)) * 100

        DispatchQueue.main.async {
            NetworkManager.shared.monchTarget(self.valueTarget) { url in
                NetworkManager.shared.gettingAnImage(from: url) { image in
                    self.animation(self.imageViewOutlet, 0.2)
                    self.imageViewOutlet.image = image
                }
            }
        }
        labelInfoToMonchOutlet.text = """
Часы
Всего: \(round(valueByMonth.allWorkTimeOfMonch * 100)/100)
Цель: \(valueByMonth.targetMonth)
Дневные: \(round(valueByMonth.allDayWorkTime * 100)/100)
Ночные: \(round(valueByMonth.allNightWorkTime * 100)/100)
"""
    }
    //\(round(valueByMonth.targetMonth * 100)/100)
    private func loadNightAndDayClock(_ month: Int) {
        guard let valueMonth = arrayMonch?.filter("numberMonth = \(month)").first else {
            imageViewTwoOutlet.image = UIImage.init(named: "noData")
            return
        }
        let nightTime = valueMonth.allNightWorkTime
        let dayTime = valueMonth.allDayWorkTime
        DispatchQueue.main.async {
            NetworkManager.shared.clockNightOfDay(dayTime , nightTime) { url in
                        NetworkManager.shared.gettingAnImage(from: url) { image in
                            self.animation(self.imageViewTwoOutlet, 0.4)
                            self.imageViewTwoOutlet.image = image
                        }
                    }
        }
    }
    
    private func loadStatisticToMonch() {
        var arrayMonchString = [String]()
        var arrayTimeMonch = [Double]()
        
        guard let valueArrayMonth = arrayMonch else {
            return
        }
        for monchName in valueArrayMonth {
            arrayMonchString.append(monchName.nameMonth)
            arrayTimeMonch.append(monchName.allWorkTimeOfMonch)
        }
        NetworkManager.shared.statisticToMonth(arrayMonchString, arrayTimeMonch) { url in
            NetworkManager.shared.gettingAnImage(from: url) { image in
                self.animation(self.imageViewFore, 0.6)
                self.imageViewFore.image = image
            }
        }
    }
    
    private func loadeStatisticDayOfMonch(_ month: Int) {
        var arrayMonchString = [String]()
        var arrayTimeMonch = [Double]()
        
        guard let valueByMonth =  arrayMonch?.filter("numberMonth = \(month)").first else {
            imageViewTree.image = UIImage.init(named: "noData")
            return
        }
        for monchName in valueByMonth.monch.sorted(byKeyPath: "dateWorkShift") {
            arrayMonchString.append(dateFormatterDay(monchName.dateWorkShift))
            arrayTimeMonch.append(monchName.timeWork)
        }
        monchStatisticLabel.text = valueByMonth.nameMonth
        
        NetworkManager.shared.statisticToMonth(arrayMonchString, arrayTimeMonch) { url in
            NetworkManager.shared.gettingAnImage(from: url) { image in
                self.animation(self.imageViewTree, 0.6)
                self.imageViewTree.image = image
            }
        }
    }
    
    private func animation(_ imageLabel: SpringImageView, _ delay: Double) {
        imageLabel.animation = "zoomIn"
        imageLabel.curve = "easwIn"
        imageLabel.duration = 1.3
        imageLabel.damping = 0.5
        imageLabel.delay = delay
        imageLabel.animate()
    }
    
    private func getPickerView() {
        textFieldSelectMonthOutlet.inputAccessoryView = tapBar
        textFieldSelectMonthOutlet.inputView = picker
        let barItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        tapBar.sizeToFit()
        tapBar.setItems([barItem], animated: true)
        
    }
    
    @objc func donePressed() {
        let selectValue = picker.selectedRow(inComponent: 0)
        valueMonth =  arrayMonch?[selectValue].numberMonth ?? 0
        loadTargetImage(valueMonth)
        loadNightAndDayClock(valueMonth)
        loadeStatisticDayOfMonch(valueMonth)
        self.view.endEditing(true)
    }
    
    @IBAction func addingOrEditingTargetButton(_ sender: UIButton) {
        alertSettingTarget()
    }
}

extension StatisticViewController {
    
    func alertSettingTarget (){
        let alertSettingTarget = UIAlertController.init(title: "Цель текущего месяца", message: nil, preferredStyle: .alert)
        alertSettingTarget.addTextField { textField in
            textField.delegate = self
            self.textFieldAlertValue = textField.text ?? ""
        }
        alertSettingTarget.addAction(.init(title: "Сохранить", style: .default, handler: { action in
            StorageManager.shared.write {
                self.monthData?.targetMonth = self.valueTarget
            }
            self.loadTargetImage(self.valueMonth)
            }))
        alertSettingTarget.addAction(.init(title: "Выйти", style: .cancel, handler: nil))
        
        present(alertSettingTarget, animated: true)
    }
}

extension StatisticViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        valueTarget = Double(textField.text?.doubleValue ?? 0.0)
    }
}

extension StatisticViewController {
        /// Метод форматирования представления даты рабочей смены
        func dateFormatterDay (_ dateDay: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd, EEE"
            dateFormatter.locale = Locale(identifier: "Ru_Ru")
            return dateFormatter.string(from: dateDay)
}
}

extension StatisticViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        arrayMonch?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        arrayMonch?[row].nameMonth
    }
}
