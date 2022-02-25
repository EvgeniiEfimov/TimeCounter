//
//  ModelJobDate.swift
//  kfcMyTime
//
//  Created by User on 27.10.2021.
//
import UIKit
import RealmSwift

class ListInfoDate: Object {
    @objc dynamic var dateWorkShift = Date()
    @objc dynamic var dayOfDateWorkShift = Int()
    @objc dynamic var timeWork =  TimeInterval()
    @objc dynamic var month = Int()
    @objc dynamic var timeStart = Date()
    @objc dynamic var timeStop =  Date()
    @objc dynamic var lunch = Double()
    
}

class SettingsUser: Object {
    @objc dynamic var automaticLunch = Bool()
    @objc dynamic var rateTFOutlet = String()
}
