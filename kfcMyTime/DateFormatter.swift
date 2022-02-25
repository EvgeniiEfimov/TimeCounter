//
//  DateFormatter.swift
//  kfcMyTime
//
//  Created by User on 20.02.2022.
//

import UIKit

class DateFormatterClass  {
     func timeDateFormatter(_ time: Date) -> String {
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.dateFormat = "HH:mm"
        dateFormatterTime.locale = Locale(identifier: "RU_RU")
        return dateFormatterTime.string(from: time)
    }
    
     func dayDateFormatter(_ day: Date) -> String  {
        let dateFormatterDay = DateFormatter()
        dateFormatterDay.dateFormat = "dd.MM.yy"
        dateFormatterDay.locale = Locale(identifier: "RU_RU")
        return dateFormatterDay.string(from: day)
    }
}

