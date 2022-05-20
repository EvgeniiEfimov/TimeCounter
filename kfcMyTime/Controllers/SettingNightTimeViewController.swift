//
//  SettingNightTimeViewController.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 16.04.2022.
//

import UIKit
import RealmSwift

class SettingNightTimeViewController: UIViewController, UITextFieldDelegate {

    var dataSettingNightTime: SettingNightTime!
    var dataSettingsIsNotEmpty: Bool!
    let storageManager = StorageManager.shared
    
    
    
    @IBOutlet weak var percentTFOutlet: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSettingsIsNotEmpty = completionTextField()
        self.percentTFOutlet.delegate = self
//        dataSettingNightTime = StorageManager.shared.realm.objects(SettingNightTime.self).first
    }
    
    private func completionTextField () -> Bool {
         dataSettingNightTime = StorageManager.shared.realm.objects(SettingNightTime.self).first
        if dataSettingNightTime != nil {
            percentTFOutlet.text = String(dataSettingNightTime.percent)
            return true
        } else { return false }
    }
    
    private func writeData() {
        storageManager.write {
            dataSettingNightTime.percent = Double(percentTFOutlet.text ?? "0.0") ?? 0.0
        }
    }
    
    private func saveData () {
        let newValueOfSettingNightTime = SettingNightTime()
        newValueOfSettingNightTime.percent = Double(percentTFOutlet.text ?? "0.0") ?? 0.0
        storageManager.saveSettingsOfNightTime(settings: newValueOfSettingNightTime)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func saveButtonSetting(_ sender: UIButton) {
        dataSettingsIsNotEmpty ? writeData() : saveData()
        dismiss(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
