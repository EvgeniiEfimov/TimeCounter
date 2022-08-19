//
//  AlertService.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 10.08.2022.
//

import Foundation

protocol AlertServiceProtocol {
    var spAlertDelete: String { get }
    var alertAttention: Alert { get }
    var alertSaveRate: Alert { get }
}

struct Alert {
    let title: String?
    let message: String?
    let buttonTitleFirst: String?
    let buttonTitleLast: String?
}

class AlertService: AlertServiceProtocol {
    var spAlertDelete: String {
        get {
            "Удалено"
        }
    }
    
    var alertAttention: Alert {
            Alert.init(title: "Внимание!",
                       message: "Не корректная продолжительность смены! \n✷проверь время начала и конца смены! \n✷00:00 является следующим днём \n✷Продолжительность смены не может превышать 24 часа",
                       buttonTitleFirst: "Ок",
                       buttonTitleLast: nil)
    }
    
    var alertSaveRate: Alert {
        Alert.init(title: "Часовая ставка",
                   message: "Введи вашу часовую ставку в формате рубли.копейки",
                   buttonTitleFirst: "Ок",
                   buttonTitleLast: nil)
    }
    
    
}


