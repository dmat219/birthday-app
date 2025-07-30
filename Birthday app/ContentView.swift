//
//  ContentView.swift
//  Birthday app
//
//  Created by David Mathew on 7/4/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var store = BirthdayStore()
    @State private var showingAddBirthday = false
    @State private var showingContactImporter = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.sectionedBirthdays) { section in
                    Section(header: sectionHeader(for: section.title)) {
                        ForEach(section.birthdays) { entry in
                            birthdayRow(for: entry)
                        }
                        .onDelete { indexSet in
                            store.deleteSorted(from: section, at: indexSet)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)
            .background(Color(.systemBackground))
            .navigationTitle("Birthdays")
            .toolbar {
                HStack {
                    Button(action: { showingAddBirthday = true }) {
                        Image(systemName: "plus")
                    }
                    Button(action: { showingContactImporter = true }) {
                        Image(systemName: "person.crop.circle.badge.plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddBirthday) {
                AddBirthdayView { newEntry in
                    store.birthdays.append(newEntry)
                }
            }
            .sheet(isPresented: $showingContactImporter) {
                ContactImportView { importedBirthdays in
                    store.birthdays.append(contentsOf: importedBirthdays)
                }
            }
            .onAppear {
                UIApplication.shared.applicationIconBadgeNumber = 0
                NotificationManager.shared.requestPermission()
                NotificationManager.shared.scheduleDailyBirthdayReminder(birthdays: store.birthdays)
            }
        }
    }
    
    // ✅ Section Header with Emojis
    func sectionHeader(for title: String) -> some View {
        let emoji: String
        switch title {
        case "Today": emoji = "🎉"
        case "This Week": emoji = "📅"
        case "This Month": emoji = "🗓️"
        case "Future": emoji = "🔮"
        default: emoji = ""
        }
        
        return HStack {
            Text("\(emoji) \(title)")
                .font(.headline)
                .foregroundColor(title == "Today" ? .red : .primary)
            Spacer()
        }
        .padding(.top, 12)
        .padding(.bottom, 4)
    }
    
    // ✅ Birthday Row with Quick Message Button (Today Only), Days Remaining, No Background Fill
    func birthdayRow(for entry: BirthdayEntry) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(entry.name)
                    .font(.system(.body, weight: .medium))
                Spacer()
                if entry.date.isTodayBirthday {
                    Image(systemName: "gift.fill")
                        .foregroundColor(.red)
                }
            }
            
            Text("Birthday: \(entry.date.formattedBirthday)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            if !entry.date.isTodayBirthday {
                Text("In \(entry.date.daysUntilNextBirthday) days")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if entry.date.isTodayBirthday, let phone = entry.phoneNumber, !phone.isEmpty {
                Button(action: {
                    sendMessage(to: phone)
                }) {
                    Label("Message", systemImage: "message.fill")
                        .font(.subheadline)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
    }
    
    // ✅ Quick Message Button Action
    func sendMessage(to phoneNumber: String) {
        let sms = "sms:\(phoneNumber)"
        if let url = URL(string: sms) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
}



/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/
