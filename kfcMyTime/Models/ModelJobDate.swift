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
    @objc dynamic var dateWorkShift = String()
    @objc dynamic var timeStart = String()
    @objc dynamic var timeStartData = Date()
    @objc dynamic var timeStop = String()
    @objc dynamic var timeStopData = Date()
    @objc dynamic var timeWorkString = String()
    @objc dynamic var lunchString = "-"
    @objc dynamic var workNightTime = Double()
    @objc dynamic var workDayTime = Double()
    @objc dynamic var inform = String()
}

class DayOfMonth: Object {
    @objc dynamic var dateWorkShift = Date()
    @objc dynamic var lunchBool = Bool()
    @objc dynamic var nightTimeBool = Bool()
    @objc dynamic var timeWork = Double()
    @objc dynamic var timeWorkStringFormat = ""
    @objc dynamic var day: InfoOfDayWork?
}

class ListInfoOfMonch: Object {
    @objc dynamic var nameMonth = ""
    @objc dynamic var numberMonth = Int()
    @objc dynamic var targetMonth = Double()
    @objc dynamic var allWorkTimeOfMonch = 0.0
    @objc dynamic var allNightWorkTime = Double()
    @objc dynamic var allDayWorkTime = Double()
    let monch = List<DayOfMonth>()
}

// MARK: Settings model


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
    
    @objc dynamic var settingName = "Ночные часы"
    @objc dynamic var percent = 0.0
}


class SettingRateAndFormatDate: Object {
    @objc dynamic var rateTFOutlet = String()
    @objc dynamic var formatSegmentControl = Int()
//    @objc dynamic var settingNotification: SettingNotification?
//    @objc dynamic var settingLunch: SettingLunch?
//    @objc dynamic var settingNightTime: SettingNightTime?
    
}

class SettingTarget: Object {
    @objc dynamic var targetMonch = Double()
}







//class SettingsUser: Object {
//    @objc dynamic var rateTFOutlet = String()
//    @objc dynamic var switchNotification = Bool()
//    @objc dynamic var switchNotificationSound = Bool()
//    @objc dynamic var datePickerNotification = Date()
//
//}

//enum rangeTimeWork: String {
//    case fourHours = 
//}

