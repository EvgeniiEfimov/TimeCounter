//
//  ModelJobDate.swift
//  kfcMyTime
//
//  Created by User on 27.10.2021.
//
import UIKit
import RealmSwift
// MARK: Info model
class InfoOfDayWork: Object {
    @objc dynamic var dateWorkShift = Date()
    @objc dynamic var timeStart = Date()
    @objc dynamic var timeStop =  Date()
    @objc dynamic var timeWorkString = ""
    @objc dynamic var lunchString = "-"
}

class DayOfMonth: Object {
    @objc dynamic var dateWorkShift = Date()
    @objc dynamic var lunchBool = Bool()
    @objc dynamic var timeWork = Double()
    @objc dynamic var timeWorkFormat = ""
    @objc dynamic var day: InfoOfDayWork?
}

class ListInfoOfMonch: Object {
    @objc dynamic var nameMonth = ""
    @objc dynamic var numberMonth = Int()
    @objc dynamic var allWorkTimeOfMonch = 0.0
    let monch = List<DayOfMonth>()
}
// MARK: Settings model

//class SettingNotification: Object {
//    @objc dynamic var switchNotification = Bool()
//    @objc dynamic var switchNotificationSound = Bool()
//    @objc dynamic var datePickerNotification = Date()
//}

class SettingLunch: Object {
    
    @objc dynamic var settingName = "Обед"
    @objc dynamic var rangeLunch = Bool()
}

class SettingNotification: Object {
    @objc dynamic var settingName = "Уведомления"
    @objc dynamic var switchNotification = Bool()
    @objc dynamic var switchNotificationSound = Bool()
    @objc dynamic var datePickerNotification = Date()
    //    @objc dynamic var settingLunch: SettingLunch?
}

class SettingNightTime: Object {
    
    @objc dynamic var settingName = "Уведомления"
    @objc dynamic var percent = Int()
}


class ListSettingsTableUser: Object {
//    @objc dynamic var nameSetting = String()
//    @objc dynamic var imageSetting = UIImage()
    @objc dynamic var settingNotification: SettingNotification?
    @objc dynamic var settingLunch: SettingLunch?
    @objc dynamic var settingNightTime: SettingNightTime?
    
}








class SettingsUser: Object, UIApplicationDelegate {
    @objc dynamic var rateTFOutlet = String()
    @objc dynamic var switchNotification = Bool()
    @objc dynamic var switchNotificationSound = Bool()
    @objc dynamic var datePickerNotification = Date()
    
}

