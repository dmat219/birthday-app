//
//  EnhancedBirthdayRowView.swift
//  Birthday app
//
//  Created by David Mathew on 7/4/25.
//

import SwiftUI

struct EnhancedBirthdayRowView: View {
    let entry: BirthdayEntry
    @ObservedObject var store: BirthdayStore
    let onMessage: () -> Void
    let onECard: () -> Void
    let onGifts: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header with name and close friend indicator
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(entry.name)
                            .font(.headline)
                        
                        if entry.isCloseFriend {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.caption)
                        }
                    }
                    
                    Text("Birthday: \(entry.date.formattedBirthday)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    if let notes = entry.notes, !notes.isEmpty {
                        Text(notes)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .italic()
                    }
                }
                
                Spacer()
                
                if entry.date.isTodayBirthday {
                    Image(systemName: "gift.fill")
                        .foregroundColor(.red)
                        .font(.title2)
                }
            }
            
            // Action Buttons - Available to everyone
            HStack(spacing: 8) {
                if let phone = entry.phoneNumber, !phone.isEmpty {
                    Button("💬 Message") {
                        onMessage()
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.caption)
                }
                
                Button("🎂 E-Card") {
                    onECard()
                }
                .buttonStyle(.bordered)
                .font(.caption)
                
                Button("🎁 Gifts") {
                    onGifts()
                }
                .buttonStyle(.bordered)
                .font(.caption)
                
                // Quick toggle for close friend status
                Button(action: {
                    toggleCloseFriendStatus()
                }) {
                    Image(systemName: entry.isCloseFriend ? "star.fill" : "star")
                        .foregroundColor(entry.isCloseFriend ? .yellow : .gray)
                        .font(.caption)
                }
                .buttonStyle(.bordered)
                .help(entry.isCloseFriend ? "Remove from close friends" : "Mark as close friend")
            }
        }
        .padding(.vertical, 4)
    }
    
    private func toggleCloseFriendStatus() {
        if let index = store.birthdays.firstIndex(where: { $0.id == entry.id }) {
            store.birthdays[index].isCloseFriend.toggle()
        }
    }
}

#Preview {
    EnhancedBirthdayRowView(
        entry: BirthdayEntry.sampleData[0],
        store: BirthdayStore(useSampleData: true),
        onMessage: {},
        onECard: {},
        onGifts: {}
    )
}
