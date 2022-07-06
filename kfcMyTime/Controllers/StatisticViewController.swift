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
    
    @IBOutlet weak var imageViewOutlet: SpringImageView!
    @IBOutlet weak var imageViewTwoOutlet: SpringImageView!
    @IBOutlet weak var imageViewTree: SpringImageView!
    @IBOutlet weak var imageViewFore: SpringImageView!
    @IBOutlet weak var monchStatisticLabel: UILabel!
    
    var arrayMonch: Results <ListInfoOfMonch>!
    var valueSettingTarget: SettingTarget?
//    var valueSettingTargetTest: Results <SettingTarget>?

    var valueTarget = Double()
    var textFieldAlertValue = String()
        
    let date = Calendar.current.dateComponents([.month], from: Date())

    override func viewWillAppear(_ animated: Bool) {
        
        arrayMonch = StorageManager.shared.realm.objects(ListInfoOfMonch.self).sorted(byKeyPath: "numberMonth")
        valueSettingTarget = StorageManager.shared.realm.objects(SettingTarget.self).first
        
//        guard (valueSettingTargetTest?.first?.targetMonch) != nil else {print("Null")
//            return
//        }
//        print("NoNull")
        //print(arrayMonch.first)
        guard arrayMonch.first != nil else {
//            print(arrayMonch)
            scrollViewOutlet.isHidden = true
            return
        }
    
        scrollViewOutlet.isHidden = false
       // noDataLabel.isHidden = false

        valueTarget = valueSettingTarget?.targetMonch ?? 0.0
        labelTitleTargetOutlet.text = "Цель текущего месяца: \n\(valueSettingTarget?.targetMonch ?? 0.0)"

        loadTargetImage()
        loadNightAndDayClock()
        loadStatisticToMonch()
        loadeStatisticDayOfMonch()
    }
    
    private func loadTargetImage() {

        guard let valueByMonth =  arrayMonch.filter("numberMonth = \(date.month ?? 0)").first else {return}
        valueTarget = ((valueByMonth.allWorkTimeOfMonch ) / (valueSettingTarget?.targetMonch ?? 1000.0)) * 100

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
Всего: \(round(valueByMonth.allWorkTimeOfMonch * 10)/10)
Цель: \(valueSettingTarget?.targetMonch ?? 0.0)
Дневные: \(round(valueByMonth.allDayWorkTime * 10)/10)
Ночные: \(round(valueByMonth.allNightWorkTime * 10)/10)

"""
    }
    
    private func loadNightAndDayClock() {
        let valueByMonth =  arrayMonch.filter("numberMonth = \(date.month ?? 0)")
        let nightTime = valueByMonth.first?.allNightWorkTime
        let dayTime = valueByMonth.first?.allDayWorkTime
        DispatchQueue.main.async {
            NetworkManager.shared.clockNightOfDay(dayTime ?? 0.0, nightTime ?? 0.0) { url in
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
        for monchName in arrayMonch {
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
    
    private func loadeStatisticDayOfMonch() {
        var arrayMonchString = [String]()
        var arrayTimeMonch = [Double]()
        
        guard let valueByMonth =  arrayMonch.filter("numberMonth = \(date.month ?? 0)").first else {return}
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
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        arrayMonch = StorageManager.shared.realm.objects(ListInfoOfMonch.self)
//        valueSettingTarget = StorageManager.shared.realm.objects(SettingTarget.self).first
//
//
//        loadTargetImage()
//        loadNightAndDayClock()
//        loadStatisticToMonch()
//        loadeStatisticDayOfMonch()
//    }
    
    @IBAction func addingOrEditingTargetButton(_ sender: UIButton) {
        alertSettingTarget()
    }
}

extension StatisticViewController {
    
    func alertSettingTarget (){
        let alertSettingTarget = UIAlertController.init(title: "Цель текущего месяца", message: nil, preferredStyle: .alert)
        alertSettingTarget.addTextField { textField in
           // self.textFieldAlertValue = textField.text
            textField.delegate = self
            self.textFieldAlertValue = textField.text ?? ""
            print(self.textFieldAlertValue)
        }
        alertSettingTarget.addAction(.init(title: "Ок", style: .default, handler: { action in
            guard let target = self.valueSettingTarget?.targetMonch else {
                let targetSetting = SettingTarget()
                print(self.textFieldAlertValue)
                targetSetting.targetMonch = self.valueTarget
                StorageManager.shared.savwSettingTarget(target: targetSetting)
                self.loadTargetImage()
                return
            }
            StorageManager.shared.write {
                self.valueSettingTarget?.targetMonch = self.valueTarget
                print(target)
            }
            self.loadTargetImage()
            }))
        
        present(alertSettingTarget, animated: true)
    }
}

extension StatisticViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        valueTarget = Double(textField.text ?? "") ?? 5.0
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
