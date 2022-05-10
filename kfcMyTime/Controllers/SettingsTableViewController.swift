//
//  SettingsTableViewController.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 10.04.2022.
//

import UIKit
import RealmSwift

class SettingsTableViewController: UITableViewController {
        
    @IBOutlet weak var rateButton: UIButton!
    private var listSettingTableUser: ListSettingsTableUser!
    var rateTF: String = ""
    
    private let storageManager = StorageManager.shared

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listSettingTableUser = StorageManager.shared.realm.objects(ListSettingsTableUser.self).first
        if listSettingTableUser != nil {
            rateButton.setTitle(listSettingTableUser.rateTFOutlet, for: .normal)
        } else {
            rateButton.setTitle("Ставка", for: .normal)
        }
            rateButton.setTitleColor(.systemYellow, for: .normal)
    }
    
    private func alertRate() {
        let alertRate = UIAlertController.init(title: "Часовая ставка",
                                                message: nil,
                                                preferredStyle: .alert)
        alertRate.addTextField { (textField) in
            textField.placeholder = "Руб/час"
            self.rateTF = textField.text ?? "0"
            print(self.rateTF)
            textField.delegate = self
        }
        
        alertRate.addAction(.init(title: "Сохранить",
                                  style: .default,
                                  handler: { (action) in
            guard self.listSettingTableUser != nil else {
                let setting = ListSettingsTableUser()
                setting.rateTFOutlet = self.rateTF
                print(setting.rateTFOutlet)
                self.storageManager.saveSettingRate(settings: setting)
                self.rateButton.setTitle(setting.rateTFOutlet, for: .normal)
                return
            }
            self.storageManager.write {
                self.listSettingTableUser.rateTFOutlet = self.rateTF
                self.rateButton.setTitle(self.listSettingTableUser.rateTFOutlet, for: .normal)
                print(self.listSettingTableUser.rateTFOutlet)
            }
        }))
        present(alertRate,
                animated: true,
                completion: nil)
    }
    
    @IBAction func rateButtonAction(_ sender: UIButton) {
        alertRate()
    }
}

extension SettingsTableViewController: UITextFieldDelegate {
     func textFieldDidEndEditing(_ textField: UITextField) {
         rateTF = textField.text ?? ""
    }
}
