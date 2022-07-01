//
//  ProtocolsFile.swift
//  kfcMyTime
//
//  Created by User on 16.02.2022.
//

import Foundation
import RealmSwift

protocol SaveSettings {
    var settingsUser: SettingNotification! {get}
    func readDataSettings()
    func saveSettings()
}

protocol SaveSettingsRate {
    var settingsUser: SettingRateAndFormatDate! {get}
    func readDataSettings()
    func saveSettings()
}


protocol SettingName {
    var settingName: String! {get set}
}

