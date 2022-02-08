//
//  DataManager.swift
//  kfcMyTime
//
//  Created by User on 28.10.2021.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    init() {}
    
    let monthArray = [1: "Январь",2: "Февраль",3: "Март",4: "Апрель",5: "Май",6: "Июнь",7: "Июль",8: "Август",9: "Сентябрь",10: "Октябрь",11: "Ноябрь",12: "Декабрь"]
    
    func dayDateFormatterDay(_ day: Date) -> String  {
        let dateFormatterDay = DateFormatter()
        dateFormatterDay.dateFormat = "dd"
        dateFormatterDay.locale = Locale(identifier: "RU_RU")
        return dateFormatterDay.string(from: day)
    }
}
