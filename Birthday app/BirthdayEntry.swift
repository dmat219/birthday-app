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
            phoneNumber: "1234567890"
        ),
        BirthdayEntry(
            id: UUID(),
            name: "Bob Smith",
            date: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
            phoneNumber: "9876543210"
        ),
        BirthdayEntry(
            id: UUID(),
            name: "Charlie Davis",
            date: Calendar.current.date(byAdding: .day, value: 15, to: Date())!
        )
    ]
}
