//
//  Birthday_appApp.swift
//  Birthday app
//
//  Created by David Mathew on 7/4/25.
//

import SwiftUI

@main
struct Birthday_appApp: App {
    @StateObject private var store = BirthdayStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .onAppear {
                    // Defer heavy operations to improve app launch performance
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        setupNotifications()
                    }
                }
        }
    }
    
    private func setupNotifications() {
        // Request notification permissions (only once)
        NotificationManager.shared.requestPermission()
        
        // Schedule recurring daily notification at 9 AM (only once)
        NotificationManager.shared.scheduleRecurringDailyNotification()
        
        // Schedule today's birthday notification if any exist
        if !store.birthdays.isEmpty {
            NotificationManager.shared.scheduleDailyBirthdayReminder(birthdays: store.birthdays)
        }
    }
}
