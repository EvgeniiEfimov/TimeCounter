//
//  SettingsTableViewController.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 10.04.2022.
//

import UIKit
import RealmSwift

class SettingsTableViewController: UITableViewController {

    private var listSettingTableUser: ListSettingsTableUser!
    private let dataSetting = DataManager.shared.settingSet
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listSettingTableUser = StorageManager.shared.realm.objects(ListSettingsTableUser.self).first
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//
//    }

    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let callSattingNotification = tableView.dequeueReusableCell(withIdentifier: "callSattingNotification", for: indexPath)
//        callSattingNotification.backgroundColor = UIColor.systemYellow
//        var content = callSattingNotification.defaultContentConfiguration()
//
//        content.text = dataSetting[indexPath.row].0
//        content.textProperties.color = UIColor.black
//        content.textProperties.font = UIFont.systemFont(ofSize: 25)
//
//        content.image = UIImage.init(systemName: dataSetting[indexPath.row].1)
//        content.imageProperties.tintColor = UIColor.darkGray
//
//
//        callSattingNotification.contentConfiguration = content
//
////         Configure the cell...
//
//        return callSattingNotification
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let settingVC = segue.destination as? SettingsNotificationViewController else { return }
//        settingVC.tagSetting = tableView.indexPathForSelectedRow?.row
//    }


}
