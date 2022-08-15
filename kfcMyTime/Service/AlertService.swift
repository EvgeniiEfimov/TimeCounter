//
//  AlertService.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 10.08.2022.
//

import Foundation

protocol AlertServiceProtocol {
    var spAlertDelete: String { get }
}

class AlertService: AlertServiceProtocol {
    var spAlertDelete: String {
        get {
            "Удалено"
        }
    }
    
    
}


