//
//  ViewController.swift
//  kfcMyTime
//
//  Created by User on 11.02.2022.
//

import UIKit
import RealmSwift

class SettingsViewController: UIViewController {

    var saveCompletionSettings: (() -> Void)?
    var realm = try! Realm()

    
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
 
    @IBAction func saveButtonAction(_ sender: UIButton) {

        saveSettings()
        
        dismiss(animated: true, completion: saveCompletionSettings)
    }
    
    
}

extension SettingsViewController: SaveSettings {
    func deleteSettings() {
    }
    
    var settingsUser: SettingsUser! {
        get {
            StorageManager.shared.realm.objects(SettingsUser.self).first
        }
    }
    
    func readDataSettings() {
        guard settingsUser != nil else { return }
      
        if !settingsUser.rateTFOutlet.isEmpty {
            rateTFOutlet.text = settingsUser.rateTFOutlet
        }
        switchAutoLunchOutlet.isOn = settingsUser.automaticLunch
    }
    
    func saveSettings() {
        if settingsUser != nil {
            StorageManager.shared.write {
                settingsUser.automaticLunch = switchAutoLunchOutlet.isOn
                settingsUser.rateTFOutlet = rateTFOutlet.text ?? "Error"
            }
        }
        else {
            let newValueSettingsUser = SettingsUser()
            newValueSettingsUser.automaticLunch = switchAutoLunchOutlet.isOn
            newValueSettingsUser.rateTFOutlet = rateTFOutlet.text ?? "Error"
            StorageManager.shared.saveSettings(settings: newValueSettingsUser)
        }
    }
}
