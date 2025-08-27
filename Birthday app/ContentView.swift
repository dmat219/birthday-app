//
//  ContentView.swift
//  Birthday app
//
//  Created by David Mathew on 7/4/25.
//
import SwiftUI
import MessageUI

struct ContentView: View {
    @EnvironmentObject var store: BirthdayStore
    @State private var showAddBirthday = false
    @State private var showContactImporter = false
    
    // Consolidated state management for all actions
    @State private var selectedBirthdayEntry: BirthdayEntry?
    @State private var showMessageView = false
    @State private var showECardView = false
    @State private var showGiftOptions = false
    
    // Computed properties for sheet presentation
    private var canShowMessage: Bool {
        selectedBirthdayEntry?.phoneNumber != nil && !selectedBirthdayEntry!.phoneNumber!.isEmpty
    }
    
    private var canShowECard: Bool {
        selectedBirthdayEntry != nil
    }
    
    private var canShowGifts: Bool {
        selectedBirthdayEntry != nil
    }

    var body: some View {
        NavigationView {
            birthdayList
                .navigationTitle("Birthday Reminders")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: { showContactImporter = true }) {
                            Label("Import Contacts", systemImage: "person.2.fill")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showAddBirthday = true }) {
                            Label("Add Birthday", systemImage: "plus")
                        }
                    }
                }
                .onChange(of: showMessageView) { newValue in
                    if newValue {
                        print("📱 ContentView: showMessageView changed to: true")
                        print("📱 ContentView: selectedBirthdayEntry: \(selectedBirthdayEntry?.name ?? "nil")")
                        print("📱 ContentView: canShowMessage: \(canShowMessage)")
                    }
                }
                .onChange(of: showECardView) { newValue in
                    if newValue {
                        print("🎴 ContentView: showECardView changed to: true")
                        print("🎴 ContentView: selectedBirthdayEntry: \(selectedBirthdayEntry?.name ?? "nil")")
                        print("🎴 ContentView: canShowECard: \(canShowECard)")
                    }
                }
                .onChange(of: showGiftOptions) { newValue in
                    if newValue {
                        print("🎁 ContentView: showGiftOptions changed to: true")
                        print("🎁 ContentView: selectedBirthdayEntry: \(selectedBirthdayEntry?.name ?? "nil")")
                        print("🎁 ContentView: canShowGifts: \(canShowGifts)")
                    }
                }
                .sheet(isPresented: $showAddBirthday) {
                    AddBirthdayView { newEntry in
                        store.addBirthday(newEntry)
                    }
                }
                .sheet(isPresented: $showContactImporter) {
                    ContactImportView { importedEntries in
                        for entry in importedEntries {
                            store.addBirthday(entry)
                        }
                    }
                }
                .sheet(isPresented: $showMessageView) {
                    if canShowMessage, let entry = selectedBirthdayEntry {
                        MessageComposeView(recipients: [entry.phoneNumber!], body: "Happy Birthday! 🎉")
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 48))
                                .foregroundColor(.orange)
                            Text("No Phone Number Available")
                                .font(.headline)
                            Text("This contact doesn't have a phone number saved. Please add a phone number to send messages.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            Button("OK") {
                                showMessageView = false
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                    }
                }
                .sheet(isPresented: $showECardView) {
                    if canShowECard, let entry = selectedBirthdayEntry {
                        ECardView(birthdayEntry: entry)
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 48))
                                .foregroundColor(.orange)
                            Text("No Birthday Entry Selected")
                                .font(.headline)
                            Text("Unable to load birthday information. Please try again.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            Button("OK") {
                                showECardView = false
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                    }
                }
                .sheet(isPresented: $showGiftOptions) {
                    if canShowGifts, let entry = selectedBirthdayEntry {
                        GiftOptionsView(birthdayEntry: entry)
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 48))
                                .foregroundColor(.orange)
                            Text("No Birthday Entry Selected")
                                .font(.headline)
                            Text("Unable to load birthday information for gifts. Please try again.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            Button("OK") {
                                showGiftOptions = false
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                    }
                }
        }
    }
    
    private var birthdayList: some View {
        List {
            ForEach(store.sectionedBirthdays) { section in
                Section(header: Text(headerTitle(for: section.title))) {
                    ForEach(section.birthdays) { entry in
                        EnhancedBirthdayRowView(
                            entry: entry,
                            store: store,
                            onMessage: {
                                print("📱 ContentView: onMessage called for: \(entry.name)")
                                selectedBirthdayEntry = entry
                                showMessageView = true
                            },
                            onECard: {
                                print("🎴 ContentView: onECard called for: \(entry.name)")
                                selectedBirthdayEntry = entry
                                showECardView = true
                            },
                            onGifts: {
                                print("🎁 ContentView: onGifts called for: \(entry.name)")
                                selectedBirthdayEntry = entry
                                showGiftOptions = true
                            }
                        )
                    }
                    .onDelete { offsets in
                        store.deleteSorted(from: section, at: offsets)
                    }
                }
            }
        }
    }
    
    private func headerTitle(for title: String) -> String {
        switch title {
        case "Today":
            return "🎉 Today's Birthdays"
        case "This Week":
            return "📅 This Week"
        case "This Month":
            return "📆 This Month"
        case "Upcoming":
            return "🔮 Upcoming"
        default:
            return title
        }
    }
}
