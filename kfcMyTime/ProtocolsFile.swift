//
//  ProtocolsFile.swift
//  kfcMyTime
//
//  Created by User on 16.02.2022.
//

import Foundation
import RealmSwift

protocol SaveSettings {
    var settingsUser: SettingsUser! {get}
    func readDataSettings()
    func saveSettings()
}


