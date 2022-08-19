//
//  SettingService.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 10.08.2022.
//

import Foundation
import RealmSwift

protocol SettingServiceProtocol: AnyObject {
    var settingData: SettingRateAndFormatDate? { get }
    var valueSettingNightTime: SettingNightTime? { get }
    func saveSettings(_ rateTF: String)
    
}

class SettingService: SettingServiceProtocol {
    let realm = try! Realm()
    var settingData: SettingRateAndFormatDate? {
        get {
            return realm.objects(SettingRateAndFormatDate.self).first
        }
    }
    
//    func saveSettingsRate (rate: SettingRateAndFormatDate) {
//        write {
//            realm.add(rate)
//        }
//    }
    
    func saveSettings(_ rateTF: String) {
        guard let rate = settingData else {
            let newValueSettingsUser = SettingRateAndFormatDate()
            newValueSettingsUser.rateTFOutlet = rateTF
            write {
                realm.add(newValueSettingsUser)
            }
            return
        }
        StorageManager.shared.write {
            rate.rateTFOutlet = rateTF
        }
    }
    
    var valueSettingNightTime: SettingNightTime? {
        realm.objects(SettingNightTime.self).first
    }
    
    
    
    
    func write (_ completion: () -> Void) {
       do {
           try realm.write {
           completion()
           }
       } catch let error {
           print(error)
       }
   }
}

