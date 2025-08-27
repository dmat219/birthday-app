//
//  Date+BirthdayHelpers.swift
//  Birthday app
//
//  Created by David Mathew on 7/4/25.
//

import Foundation

extension Date {
    var formattedBirthday: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"  // Shows "January 15" instead of "January 15, 2000"
        return formatter.string(from: self)
    }
    
    var isTodayBirthday: Bool {
        let calendar = Calendar.current
        let today = calendar.dateComponents([.month, .day], from: Date())
        let birthday = calendar.dateComponents([.month, .day], from: self)
        return today.month == birthday.month && today.day == birthday.day
    }
    
    var nextBirthdayDate: Date {
        let calendar = Calendar.current
        let now = calendar.startOfDay(for: Date())
        let currentYear = calendar.component(.year, from: now)
        
        var nextBirthdayComponents = calendar.dateComponents([.month, .day], from: self)
        nextBirthdayComponents.year = currentYear
        
        let birthdayThisYear = calendar.date(from: nextBirthdayComponents)!
        let birthdayThisYearStart = calendar.startOfDay(for: birthdayThisYear)
        
        if birthdayThisYearStart < now {
            nextBirthdayComponents.year = currentYear + 1
            return calendar.date(from: nextBirthdayComponents)!
        } else {
            return birthdayThisYearStart
        }
    }
    
    var daysUntilNextBirthday: Int {
        let calendar = Calendar.current
        let now = calendar.startOfDay(for: Date())
        let nextBirthday = calendar.startOfDay(for: nextBirthdayDate)
        return calendar.dateComponents([.day], from: now, to: nextBirthday).day ?? 0
    }
}
