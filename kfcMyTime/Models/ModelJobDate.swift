//
//  ModelJobDate.swift
//  kfcMyTime
//
//  Created by User on 27.10.2021.
//
import UIKit
import RealmSwift


//class InfoJobDate: Object {
//    @objc dynamic var dateWorkShift = Date()
//    @objc dynamic var timeStart = Date()
//    @objc dynamic var timeStop =  Date()
//    @objc dynamic var timeWork =  TimeInterval()
//    @objc dynamic var lunch = false
//    @objc dynamic var doublePayment = false
//}

class ListInfoDate: Object {
    @objc dynamic var dateWorkShift = Date()
    @objc dynamic var timeWork =  TimeInterval()
    @objc dynamic var month = Int()
    @objc dynamic var timeStart = Date()
    @objc dynamic var timeStop =  Date()
    @objc dynamic var lunch = Double()
//    @objc dynamic var doublePayment = false
//    var info: InfoJobDate?
}
