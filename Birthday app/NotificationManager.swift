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
        
        var dateComponents = DateComponents()
        dateComponents.hour = 9  // Notify at 9:00 AM
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "birthdayReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Birthday notification scheduled successfully for daily at 9 AM.")
            }
        }
    }
    
    /// Schedule recurring daily notification at 9 AM (only if not already scheduled)
    func scheduleRecurringDailyNotification() {
        let center = UNUserNotificationCenter.current()
        
        // Check if notification is already scheduled
        center.getPendingNotificationRequests { requests in
            let hasDailyNotification = requests.contains { $0.identifier == "dailyBirthdayCheck" }
            
            if !hasDailyNotification {
                let content = UNMutableNotificationContent()
                content.title = "Birthday Check 🎂"
                content.body = "Check today's birthdays and send your wishes!"
                content.sound = .default
                
                var dateComponents = DateComponents()
                dateComponents.hour = 9
                dateComponents.minute = 0
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(identifier: "dailyBirthdayCheck", content: content, trigger: trigger)
                
                center.add(request) { error in
                    if let error = error {
                        print("Error scheduling daily notification: \(error)")
                    } else {
                        print("Daily birthday check notification scheduled successfully.")
                    }
                }
            } else {
                print("Daily birthday check notification already scheduled.")
            }
        }
    }
}

