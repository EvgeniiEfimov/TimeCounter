//
//  ViewController.swift
//  kfcMyTime
//
//  Created by User on 11.02.2022.
//

import UIKit
import RealmSwift

class SettingsNotificationViewController: UIViewController, UITextFieldDelegate {
    
    var realm = try! Realm()
    
    let notifications = Notifications()

    
//    @IBOutlet weak var rateTFOutlet: UITextField!
    @IBOutlet weak var switchNotification: UISwitch!
    @IBOutlet weak var switchNotificationSound: UISwitch!
    @IBOutlet weak var datePickerNotification: UIDatePicker!
    @IBOutlet weak var soundNotificationAction: UISwitch!
  
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readDataSettings()
        viewOfaction(switchNotification)
        viewOfaction(switchNotificationSound)
        
//        self.rateTFOutlet.delegate = self
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    //MARK: Notification setting
    
    @IBAction func notificationAction(_ sender: UISwitch) {
        soundNotificationAction.isEnabled = sender.isOn
        datePickerNotification.isEnabled = sender.isOn
    viewOfaction(sender)
    }
    
    @IBAction func actionSwitchNotificationSound(_ sender: UISwitch) {
        viewOfaction(sender)
    }
    
    
    func viewOfaction(_ sender: UISwitch) {
        if sender.isOn == true {
            sender.tintColor = UIColor.systemYellow
            sender.thumbTintColor = UIColor.darkGray
        } else {
            sender.tintColor = UIColor.darkGray
            sender.thumbTintColor = UIColor.systemOrange
        }

    }
    

    
    //MARK:
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        saveSettings()
        if settingsUser.switchNotification {
            notifications.scheduleNotification(settingsUser.datePickerNotification, settingsUser.switchNotificationSound)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension SettingsNotificationViewController: SaveSettings {
    func deleteSettings() {
    }
    
    var settingsUser: SettingNotification! {
        get {
            StorageManager.shared.realm.objects(SettingNotification.self).first
        }
    }
    
    func readDataSettings() {
        guard settingsUser != nil else { return }
        switchNotification.isOn = settingsUser.switchNotification
        switchNotificationSound.isOn = settingsUser.switchNotificationSound
        switchNotificationSound.isEnabled = settingsUser.switchNotification
        datePickerNotification.isEnabled = settingsUser.switchNotification
        datePickerNotification.setDate(settingsUser.datePickerNotification, animated: true)
    }
    
    func saveSettings() {
        if settingsUser != nil {
            StorageManager.shared.write {
//                settingsUser.rateTFOutlet = rateTFOutlet.text ?? "Error"
                settingsUser.switchNotification = switchNotification.isOn
                settingsUser.switchNotificationSound = switchNotificationSound.isOn
                settingsUser.datePickerNotification = datePickerNotification.date
            }
        }
        else {
            let newValueSettingsUser = SettingNotification()
//            newValueSettingsUser.rateTFOutlet = rateTFOutlet.text ?? "Error"
            newValueSettingsUser.switchNotification = switchNotification.isOn
            newValueSettingsUser.switchNotificationSound = switchNotificationSound.isOn
            newValueSettingsUser.datePickerNotification = datePickerNotification.date
            StorageManager.shared.saveSettings(settings: newValueSettingsUser)
        }
    }
}


