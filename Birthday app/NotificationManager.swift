//
//  NotificationManager.swift
//  Birthday app
//
//  Created by David Mathew on 7/4/25.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    /// Ask the user for notification permission.
    func requestPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }
    
    /// Schedule a daily notification for today's birthdays.
    func scheduleDailyBirthdayReminder(birthdays: [BirthdayEntry]) {
        let todayBirthdays = birthdays.filter { $0.date.isTodayBirthday }
        let names = todayBirthdays.map { $0.name }.joined(separator: ", ")
        
        guard !names.isEmpty else {
            print("No birthdays today—skipping notification.")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Today's Birthdays 🎉"
        content.body = "Wish a happy birthday to: \(names)"
        content.sound = .default
        content.badge = NSNumber(value: todayBirthdays.count)
        
        /*var dateComponents = DateComponents()
        dateComponents.hour = 9  // Notify at 9:00 AM
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)*/
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(identifier: "birthdayReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Birthday notification scheduled successfully.")
            }
        }
    }
}

