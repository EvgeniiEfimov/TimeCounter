//
//  ViewController.swift
//  kfcMyTime
//
//  Created by User on 11.02.2022.
//

import UIKit
import RealmSwift

class SettingsViewController: UIViewController {

    var settingsUser: SettingsUser!
    var settingsUserArray: Results<SettingsUser>!
    var saveCompletionSettings: (() -> Void)?

    
    @IBOutlet weak var switchAutoLunchOutlet: UISwitch!
    @IBOutlet weak var rateTFOutlet: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readDataAndUpdateUI()
    }
    
    private func isEmptyValueTF () -> Bool {
        if !settingsUser.rateTFOutlet.isEmpty {
            rateTFOutlet.text = settingsUser.rateTFOutlet
            return false
        } else { return true }
    }
    
    private func readDataAndUpdateUI() {
        settingsUserArray = StorageManager.shared.realm.objects(SettingsUser.self).sorted(byKeyPath: "automaticLunch")
//        print(settingsUserArray)
        settingsUser = StorageManager.shared.realm.objects(SettingsUser.self).first
        guard settingsUser != nil else { return }
        if !settingsUser.rateTFOutlet.isEmpty {
            rateTFOutlet.text = settingsUser.rateTFOutlet
        }
    }
    
    private func saveSettings() {
        
        let valueSaveSattingUser = SettingsUser()
        valueSaveSattingUser.automaticLunch = switchAutoLunchOutlet.isOn
        valueSaveSattingUser.rateTFOutlet = rateTFOutlet.text ?? "Error 504"
        
//        guard settingsUser != nil else { return }
//        if settingsUser.rateTFOutlet != rateTFOutlet.text {
//            valueSaveSattingUser.rateTFOutlet = rateTFOutlet.text ?? ""
//        }
        
        DispatchQueue.main.async {
            StorageManager.shared.saveSettings(settings: valueSaveSattingUser)
        }
        print(valueSaveSattingUser)
        
        
    }
    
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
//        if settingsUser != nil {
//        StorageManager.shared.deleteSettings(settings: settingsUser)
//        }
        saveSettings()
        
        dismiss(animated: true, completion: saveCompletionSettings)
    }
    
    
}
