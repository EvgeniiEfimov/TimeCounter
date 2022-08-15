//
//  SettingService.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 10.08.2022.
//

import Foundation
import RealmSwift

protocol SettingServiceProtocol: AnyObject {
    var settingData: Results<SettingRateAndFormatDate>? {get}
}

class SettingService: SettingServiceProtocol {
    let realm = try! Realm()
    var settingData: Results<SettingRateAndFormatDate>? {
        get {
            return realm.objects(SettingRateAndFormatDate.self)
        }
    }
}
