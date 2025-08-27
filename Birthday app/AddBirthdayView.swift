//
//  AddBirthdayView.swift
//  Birthday app
//
//  Created by David Mathew on 7/4/25.
//

import SwiftUI

struct AddBirthdayView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var date: Date = Date()
    @State private var phoneNumber: String = ""
    @State private var isCloseFriend: Bool = false
    @State private var preferredECardStyle: String = "Birthday Cake"
    @State private var notes: String = ""
    
    private let cardStyles = [
        "Birthday Cake", "Balloons", "Gift Box", "Party Hat", "Flowers", "Stars"
    ]
    
    var onSave: (BirthdayEntry) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Information")) {
                    TextField("Enter name", text: $name)
                    DatePicker("Select date", selection: $date, displayedComponents: .date)
                    TextField("Phone number (optional)", text: $phoneNumber)
                        .keyboardType(.phonePad)
                }
                
                Section(header: Text("Relationship")) {
                    Toggle("⭐ Close Friend", isOn: $isCloseFriend)
                    
                    if isCloseFriend {
                        Picker("Preferred E-Card Style", selection: $preferredECardStyle) {
                            ForEach(cardStyles, id: \.self) { style in
                                Text(style).tag(style)
                            }
                        }
                    }
                }
                
                Section(header: Text("Notes")) {
                    TextField("Add personal notes (optional)", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Add Birthday")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newEntry = BirthdayEntry(
                            id: UUID(),
                            name: name,
                            date: date,
                            phoneNumber: phoneNumber.isEmpty ? nil : phoneNumber,
                            isCloseFriend: isCloseFriend,
                            preferredECardStyle: isCloseFriend ? preferredECardStyle : nil,
                            notes: notes.isEmpty ? nil : notes
                        )
                        onSave(newEntry)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(name.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
