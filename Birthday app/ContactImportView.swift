//
//  ContactImportView.swift
//  Birthday app
//
//  Created by David Mathew on 7/4/25.
//

import SwiftUI

struct ContactImportView: View {
    @ObservedObject private var importer = ContactImporter()
    var onImport: ([BirthdayEntry]) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach(importer.contacts) { contact in
                    Toggle(isOn: Binding(
                        get: { importer.selectedContactIDs.contains(contact.id) },
                        set: { isSelected in
                            if isSelected {
                                importer.selectedContactIDs.insert(contact.id)
                            } else {
                                importer.selectedContactIDs.remove(contact.id)
                            }
                        }
                    )) {
                        VStack(alignment: .leading) {
                            Text(contact.name)
                            Text("Birthday: \(contact.date.formattedBirthday)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Import Contacts")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Import") {
                        let selected = importer.selectedBirthdays()
                        onImport(selected)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .onAppear {
                importer.requestAccessAndFetchBirthdays()
            }
        }
    }
}
