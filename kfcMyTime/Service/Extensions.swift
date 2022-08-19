//
//  File.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 10.08.2022.
//

import Foundation
import UIKit
import SwiftUI

extension TableDateViewController {
    /// Метод форматирования представления даты рабочей смены
    func dateFormatterDay (_ dateDay: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd / MM, EEE"
        dateFormatter.locale = Locale(identifier: "Ru_Ru")
        return dateFormatter.string(from: dateDay)
    }
    /// Форматирование рабочего времени в формат Часы - минуты
    func timeWorkOfFormatString(_ timeInterval: Double) -> String {
    let formatter = DateComponentsFormatter()
        formatter.calendar?.locale = Locale(identifier: "Ru-ru")
    formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        let formattedString = formatter.string(from: TimeInterval(timeInterval * 3600.0))
        return formattedString ?? "-"
    }
}

extension UITableView {
    func scrollToBottom() {
        self.reloadData()
        let section = self.numberOfSections
        guard (section > 0) else {
            return
        }
        let row = self.numberOfRows(inSection: self.numberOfSections - 1) - 1;
        guard (section > 0) && (row > 0) else { // check bounds
            return
        }
        let indexPath = IndexPath(row: row-1, section: section-1)
        self.scrollToRow(at: indexPath, at: .middle, animated: false)
    }
}


protocol GetNameAndNumberDate {
    var getNameMonth: String { get }
    var getNumberMonth: Int { get }
}

extension Date: GetNameAndNumberDate {
    var getNameMonth: String {
        let dateFormatMonthName = DateFormatter()
        dateFormatMonthName.dateFormat = "LLLL"
        dateFormatMonthName.locale = Locale(identifier: "Ru-ru")
        return dateFormatMonthName.string(from: self)
    }
    
    var getNumberMonth: Int {
        return Calendar.current.dateComponents([.month], from: self).month ?? 0
    }
    
     func timeDateFormatter(_ dateFormat: String) -> String {
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.dateFormat = dateFormat
        dateFormatterTime.locale = Locale(identifier: "RU_RU")
        return dateFormatterTime.string(from: self)
    }
}

extension Double {
    var formattingTimeWorkOfString: String {
        let formatter = DateComponentsFormatter()
            formatter.calendar?.locale = Locale(identifier: "Ru-ru")
            formatter.allowedUnits = [.hour, .minute]
            formatter.unitsStyle = .abbreviated
            return formatter.string(from: TimeInterval(self * 3600)) ?? "-"
    }
}

extension String {
    static let numberFormatter = NumberFormatter()
    var doubleValue: Double {
        String.numberFormatter.decimalSeparator = "."
        if let result =  String.numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result = String.numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
}

// MARK: - Struct

struct AddDataStruct {
    let note: String?
    let timeStart: Date
    let timeStop: Date
    let lunch: Bool
    let nightTime: Bool
}

struct Transition {
    let segue: UIStoryboardSegue
    let sender:  Any?
}
