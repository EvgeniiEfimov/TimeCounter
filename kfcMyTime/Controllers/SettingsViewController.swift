//
//  ViewController.swift
//  kfcMyTime
//
//  Created by User on 11.02.2022.
//

import UIKit
import RealmSwift

class SettingsViewController: UIViewController {

    var realm = try! Realm()

    
    @IBOutlet weak var rateTFOutlet: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readDataSettings()
    }
 
    @IBAction func saveButtonAction(_ sender: UIButton) {
        saveSettings()
        dismiss(animated: true, completion: nil)
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
    }
    
    func saveSettings() {
        if settingsUser != nil {
            StorageManager.shared.write {
                settingsUser.rateTFOutlet = rateTFOutlet.text ?? "Error"
            }
        }
        else {
            let newValueSettingsUser = SettingsUser()
            newValueSettingsUser.rateTFOutlet = rateTFOutlet.text ?? "Error"
            StorageManager.shared.saveSettings(settings: newValueSettingsUser)
        }
    }
}
