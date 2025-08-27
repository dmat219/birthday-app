//
//  BirthdayStore.swift
//  Birthday app
//
//  Created by David Mathew on 7/4/25.
//

import Foundation


class BirthdayStore: ObservableObject {
    // MARK: - Properties
    @Published var birthdays: [BirthdayEntry] = [] {
        didSet { save() }
    }
    
    private let saveKey = "SavedBirthdays"
    
    // MARK: - Init
    init(useSampleData: Bool = false) {
        if useSampleData {
            self.birthdays = BirthdayEntry.sampleData
        } else {
            load()
        }
    }
    
    // MARK: - Public Methods
    func addBirthday(_ birthday: BirthdayEntry) {
        birthdays.append(birthday)
    }
    
    var sectionedBirthdays: [BirthdaySection] {
        let todayBirthdays = birthdays.filter { $0.date.isTodayBirthday }
        let weekCutoff = 7
        let monthCutoff = 30
        
        let birthdaysThisWeek = birthdays.filter {
            !$0.date.isTodayBirthday && $0.date.daysUntilNextBirthday <= weekCutoff
        }
        let birthdaysThisMonth = birthdays.filter {
            $0.date.daysUntilNextBirthday > weekCutoff && $0.date.daysUntilNextBirthday <= monthCutoff
        }
        let futureBirthdays = birthdays.filter { $0.date.daysUntilNextBirthday > monthCutoff }
        
        return [
            BirthdaySection(title: "Today", birthdays: todayBirthdays.sorted { $0.date.daysUntilNextBirthday < $1.date.daysUntilNextBirthday }),
            BirthdaySection(title: "This Week", birthdays: birthdaysThisWeek.sorted { $0.date.daysUntilNextBirthday < $1.date.daysUntilNextBirthday }),
            BirthdaySection(title: "This Month", birthdays: birthdaysThisMonth.sorted { $0.date.daysUntilNextBirthday < $1.date.daysUntilNextBirthday }),
            BirthdaySection(title: "Upcoming", birthdays: futureBirthdays.sorted { $0.date.daysUntilNextBirthday < $1.date.daysUntilNextBirthday })
        ]
    }
    
    func deleteSorted(from section: BirthdaySection, at offsets: IndexSet) {
        for index in offsets {
            let entryToDelete = section.birthdays[index]
            if let originalIndex = birthdays.firstIndex(where: { $0.id == entryToDelete.id }) {
                birthdays.remove(at: originalIndex)
            }
        }
    }
    
    // MARK: - Private Helpers
    private func load() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([BirthdayEntry].self, from: data) {
                birthdays = decoded
            }
        }
    }
    
    private func save() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(birthdays) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
}
