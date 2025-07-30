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
    
    var onSave: (BirthdayEntry) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("Enter name", text: $name)
                }
                Section(header: Text("Birthday")) {
                    DatePicker("Select date", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle("Add Birthday")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newEntry = BirthdayEntry(id: UUID(), name: name, date: date)
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
