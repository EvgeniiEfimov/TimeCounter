//
//  ViewController.swift
//  kfcMyTime
//
//  Created by User on 11.02.2022.
//

import UIKit
import RealmSwift

class SettingsViewController: UIViewController {

//    var settingsUser: SettingsUser!
    var saveCompletionSettings: (() -> Void)?

    
    @IBOutlet weak var switchAutoLunchOutlet: UISwitch!
    @IBOutlet weak var rateTFOutlet: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readDataSettings()
    }
    
    private func isEmptyValueTF () -> Bool {
        if !settingsUser.rateTFOutlet.isEmpty {
            rateTFOutlet.text = settingsUser.rateTFOutlet
            return false
        } else { return true }
    }
    
//    private func readDataAndUpdateUI() {
//        settingsUser = StorageManager.shared.realm.objects(SettingsUser.self).first
//        guard settingsUser != nil else { return }
//        if !settingsUser.rateTFOutlet.isEmpty {
//            rateTFOutlet.text = settingsUser.rateTFOutlet
//            switchAutoLunchOutlet.isOn = settingsUser.automaticLunch
//
//        }
//    }
    
//    private func saveSettings() {
//
//        let valueSaveSattingUser = SettingsUser()
//        valueSaveSattingUser.automaticLunch = switchAutoLunchOutlet.isOn
//        valueSaveSattingUser.rateTFOutlet = rateTFOutlet.text ?? "Error 504"
//
////        guard settingsUser != nil else { return }
////        if settingsUser.rateTFOutlet != rateTFOutlet.text {
////            valueSaveSattingUser.rateTFOutlet = rateTFOutlet.text ?? ""
////        }
//
//        DispatchQueue.main.async {
//            StorageManager.shared.saveSettings(settings: valueSaveSattingUser)
//        }
//        print(valueSaveSattingUser)
//
//
//    }
    
    
    @IBAction func saveButtonAction(_ sender: UIButton) {

        deleteSettings()
        saveSettings()
        
        dismiss(animated: true, completion: saveCompletionSettings)
    }
    
    
}

extension SettingsViewController: SaveSettings {
    var settingsUser: SettingsUser! {
        get {
            StorageManager.shared.realm.objects(SettingsUser.self).first
        }
    }
    
    func readDataSettings() {
//        settingsUser = StorageManager.shared.realm.objects(SettingsUser.self).first
        guard settingsUser != nil else { return }
        if !settingsUser.rateTFOutlet.isEmpty {
            rateTFOutlet.text = settingsUser.rateTFOutlet
            switchAutoLunchOutlet.isOn = settingsUser.automaticLunch
        }
    }
    
    func deleteSettings() {
        if settingsUser != nil {
        StorageManager.shared.deleteSettings(settings: settingsUser)
        }
    }
    
    func saveSettings() {
        let valueSaveSattingUser = SettingsUser()
        valueSaveSattingUser.automaticLunch = switchAutoLunchOutlet.isOn
        valueSaveSattingUser.rateTFOutlet = rateTFOutlet.text ?? "Error 504"
        
        DispatchQueue.main.async {
            StorageManager.shared.saveSettings(settings: valueSaveSattingUser)
        }
    }
}
