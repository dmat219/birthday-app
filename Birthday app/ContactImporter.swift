//
//  ContactImporter.swift
//  Birthday app
//
//  Created by David Mathew on 7/4/25.
//

import Foundation
import Contacts

struct ContactBirthdayEntry: Identifiable {
    let id = UUID()
    var name: String
    var date: Date
    var phoneNumber: String?
}

class ContactImporter: ObservableObject {
    @Published var contacts: [ContactBirthdayEntry] = []
    @Published var selectedContactIDs: Set<UUID> = []
    
    private let store = CNContactStore()
    
    func requestAccessAndFetchBirthdays() {
        store.requestAccess(for: .contacts) { granted, error in
            if granted {
                self.fetchContacts()
            } else {
                print("Access to contacts denied.")
            }
        }
    }
    
    private func fetchContacts() {
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactBirthdayKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        
        let request = CNContactFetchRequest(keysToFetch: keys)
        var fetched: [ContactBirthdayEntry] = []
        
        do {
            try store.enumerateContacts(with: request) { contact, _ in
                if let birthday = contact.birthday,
                   let month = birthday.month,
                   let day = birthday.day {
                    // Use current year (or adjust later)
                    var components = DateComponents()
                    components.month = month
                    components.day = day
                    components.year = 2000  // Dummy year, since we only care about month/day
                    
                    if let date = Calendar.current.date(from: components) {
                        let name = "\(contact.givenName) \(contact.familyName)".trimmingCharacters(in: .whitespaces)
                        let phone = contact.phoneNumbers.first?.value.stringValue
                        
                        fetched.append(ContactBirthdayEntry(name: name, date: date, phoneNumber: phone))
                    }
                }
            }
        } catch {
            print("Failed to fetch contacts: \(error)")
        }
        
        DispatchQueue.main.async {
            self.contacts = fetched
            self.selectedContactIDs = Set(fetched.map { $0.id })  // Default: all selected
        }
    }
    
    func selectedBirthdays() -> [BirthdayEntry] {
        contacts
            .filter { selectedContactIDs.contains($0.id) }
            .map { contact in
                BirthdayEntry(id: UUID(), name: contact.name, date: contact.date, phoneNumber: contact.phoneNumber)
            }
    }
}

