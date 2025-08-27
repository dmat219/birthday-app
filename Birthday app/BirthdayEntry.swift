//
//  BirthdayEntry.swift
//  Birthday app
//
//  Created by David Mathew on 7/4/25.
//

import Foundation

struct BirthdayEntry: Identifiable, Codable {
    let id: UUID
    var name: String
    var date: Date
    var phoneNumber: String? = nil  // Optional
    var isCloseFriend: Bool = false  // New: Close friend flag
    var preferredECardStyle: String? = nil  // New: E-card preference
    var notes: String? = nil  // New: Personal notes
}

struct BirthdaySection: Identifiable {
    let id = UUID()
    let title: String
    let birthdays: [BirthdayEntry]
}

extension BirthdayEntry {
    static let sampleData: [BirthdayEntry] = [
        BirthdayEntry(
            id: UUID(),
            name: "Alice Johnson",
            date: Calendar.current.date(byAdding: .day, value: 0, to: Date())!,
            phoneNumber: "1234567890",
            isCloseFriend: true,
            preferredECardStyle: "Birthday Cake",
            notes: "Loves chocolate cake and flowers"
        ),
        BirthdayEntry(
            id: UUID(),
            name: "Bob Smith",
            date: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
            phoneNumber: "9876543210",
            isCloseFriend: false,
            preferredECardStyle: "Balloons",
            notes: "Work colleague"
        ),
        BirthdayEntry(
            id: UUID(),
            name: "Charlie Davis",
            date: Calendar.current.date(byAdding: .day, value: 15, to: Date())!,
            isCloseFriend: true,
            preferredECardStyle: "Gift Box",
            notes: "Best friend since college"
        )
    ]
}
