//
//  SettingService.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 10.08.2022.
//

import Foundation
import RealmSwift

protocol SettingServiceProtocol: AnyObject {
    var settingData: SettingRateAndFormatDate {get}
}

class SettingService: SettingServiceProtocol {
    let realm = try! Realm()
    var settingData: SettingRateAndFormatDate {
        get {
            guard let settings = realm.objects(SettingRateAndFormatDate.self).first else {
                return SettingRateAndFormatDate.init()
            }
            return settings
        }
    }
}
