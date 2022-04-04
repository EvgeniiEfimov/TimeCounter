//
//  Notifications.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 28.03.2022.
//

import Foundation
import UserNotifications

class Notifications: NSObject, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func notificationRequest() {
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
    }
    
    func scheduleNotification( _ dateSetting: Date, _ soundValue: Bool) {
        let content = UNMutableNotificationContent()
        
        content.title = "⚠️"
        content.body = " Уже отработал или всё еще впереди? Не забудь забить рабочую смену! "
        content.sound = soundValue ? UNNotificationSound.default : nil
        content.badge = 1
        
        let date = dateSetting
        let triggerDaily = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: false)
        let identifier = "Local Notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            if let error = error {
                print ("Error \(error.localizedDescription)")
            }
        }
    }
    
    
    
}
