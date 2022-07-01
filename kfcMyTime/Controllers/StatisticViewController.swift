//
//  StatisticViewController.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 24.05.2022.
//

import UIKit
import Alamofire
import RealmSwift

class StatisticViewController: UIViewController {

    @IBOutlet weak var labelTitleTargetOutlet: UILabel!
    @IBOutlet weak var labelInfoToMonchOutlet: UILabel!
    
    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var imageViewTwoOutlet: UIImageView!
    @IBOutlet weak var imageViewTree: UIImageView!
    
    var arrayMonch: Results <ListInfoOfMonch>!
    var valueSettingTarget: SettingTarget?
    var valueTarget = Double()
    var textFieldAlertValue = ""
        
    let date = Calendar.current.dateComponents([.month], from: Date())

    override func viewWillAppear(_ animated: Bool) {
        labelTitleTargetOutlet.text = "Цель текущего месяца: \n\(valueTarget)"

        loadTargetImage()
        loadNightAndDayClock()
        loadStatisticToMonch()
    }
    
    private func loadTargetImage() {
        arrayMonch = StorageManager.shared.realm.objects(ListInfoOfMonch.self).sorted(byKeyPath: "numberMonth")
        valueSettingTarget = StorageManager.shared.realm.objects(SettingTarget.self).first


        guard let valueByMonth =  arrayMonch.filter("numberMonth = \(date.month ?? 0)").first else {return}
      
        valueTarget = ((valueByMonth.allWorkTimeOfMonch ) / (valueSettingTarget?.targetMonch ?? 1000.0)) * 100

        DispatchQueue.main.async {
            NetworkManager.shared.monchTarget(self.valueTarget) { url in
                NetworkManager.shared.gettingAnImage(from: url) { image in
                    self.imageViewOutlet.image = image
                }
            }
        }
        labelInfoToMonchOutlet.text = """
Часы:
Всего/Цель \(valueByMonth.allWorkTimeOfMonch) / \(valueSettingTarget?.targetMonch ?? 0.0)
Дневные: \(valueByMonth.allDayWorkTime)
Ночные: \(valueByMonth.allNightWorkTime)

"""
        
    }
    
    private func loadNightAndDayClock() {
        let valueByMonth =  arrayMonch.filter("numberMonth = \(date.month ?? 0)")
        let nightTime = valueByMonth.first?.allNightWorkTime
        let dayTime = valueByMonth.first?.allDayWorkTime
        DispatchQueue.main.async {
            NetworkManager.shared.clockNightOfDay(dayTime ?? 0.0, nightTime ?? 0.0) { url in
                        NetworkManager.shared.gettingAnImage(from: url) { image in
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
                self.imageViewTree.image = image
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrayMonch = StorageManager.shared.realm.objects(ListInfoOfMonch.self)
        valueSettingTarget = StorageManager.shared.realm.objects(SettingTarget.self).first

   
        loadTargetImage()
        loadNightAndDayClock()
        loadStatisticToMonch()

    }
    
    @IBAction func addingOrEditingTargetButton(_ sender: UIButton) {
        alertSettingTarget()
    }
}

extension StatisticViewController {
    
    func alertSettingTarget (){
        let alertSettingTarget = UIAlertController.init(title: "Цель текущего месяца", message: nil, preferredStyle: .alert)
        alertSettingTarget.addTextField { textField in
            self.textFieldAlertValue = textField.text ?? ""
            textField.delegate = self
        }
        alertSettingTarget.addAction(.init(title: "Ок", style: .default, handler: { action in
            guard let target = self.valueSettingTarget else {
                let targetSetting = SettingTarget()
                targetSetting.targetMonch = Double(self.textFieldAlertValue) ?? 1.0
                StorageManager.shared.savwSettingTarget(target: targetSetting)
                return
            }
            StorageManager.shared.write {
                target.targetMonch = self.valueTarget
                print(target.targetMonch)
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
    
}
