//
//  ModelJobDate.swift
//  kfcMyTime
//
//  Created by User on 27.10.2021.
//
import UIKit
import RealmSwift

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

class SettingsUser: Object {
    @objc dynamic var rateTFOutlet = String()
}

