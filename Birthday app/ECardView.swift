//
//  ECardView.swift
//  Birthday app
//
//  Created by David Mathew on 7/4/25.
//

import SwiftUI
import MessageUI

struct ECardView: View {
    let birthdayEntry: BirthdayEntry
    @State private var selectedCardStyle: String = "Birthday Cake"
    @State private var personalMessage: String = ""
    @State private var showMessageView = false
    
    private let cardStyles = [
        "Birthday Cake": "🎂",
        "Balloons": "🎈",
        "Gift Box": "🎁",
        "Party Hat": "🎉",
        "Flowers": "🌸",
        "Stars": "⭐"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text("🎂 Birthday E-Card")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("for \(birthdayEntry.name)")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top)
                    
                    // Card Style Selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Choose E-Card Style")
                            .font(.headline)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
                            ForEach(Array(cardStyles.keys.sorted()), id: \.self) { style in
                                Button(action: {
                                    selectedCardStyle = style
                                }) {
                                    VStack(spacing: 8) {
                                        Text(cardStyles[style] ?? "")
                                            .font(.system(size: 40))
                                        Text(style)
                                            .font(.caption)
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(height: 80)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedCardStyle == style ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(selectedCardStyle == style ? Color.blue : Color.clear, lineWidth: 2)
                                            )
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Personal Message
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Personal Message")
                            .font(.headline)
                        
                        TextField("Add a personal touch...", text: $personalMessage, axis: .vertical)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .lineLimit(3...6)
                        
                        if !personalMessage.isEmpty {
                            Text("Preview:")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text("\(personalMessage)")
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                    
                    // E-Card Preview
                    VStack(spacing: 12) {
                        Text("E-Card Preview")
                            .font(.headline)
                        
                        VStack(spacing: 16) {
                            Text(cardStyles[selectedCardStyle] ?? "")
                                .font(.system(size: 60))
                            
                            Text("Happy Birthday!")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                            
                            if !personalMessage.isEmpty {
                                Text(personalMessage)
                                    .font(.body)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            
                            Text("🎉 \(birthdayEntry.name) 🎉")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(LinearGradient(
                                    colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                    .padding(.horizontal)
                    
                    // Send Button
                    Button(action: {
                        showMessageView = true
                    }) {
                        HStack {
                            Image(systemName: "paperplane.fill")
                            Text("Send E-Card")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("E-Card")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showMessageView) {
                let messageBody = createECardMessage()
                MessageComposeView(
                    recipients: [birthdayEntry.phoneNumber ?? ""],
                    body: messageBody
                )
            }
        }
    }
    
    private func createECardMessage() -> String {
        var message = "🎂 Happy Birthday \(birthdayEntry.name)! 🎂\n\n"
        message += "\(cardStyles[selectedCardStyle] ?? "🎉") "
        message += "Wishing you a wonderful day filled with joy and happiness! "
        message += "\(cardStyles[selectedCardStyle] ?? "🎉")\n\n"
        
        if !personalMessage.isEmpty {
            message += "\(personalMessage)\n\n"
        }
        
        message += "🎁 Have an amazing birthday! 🎁"
        return message
    }
}

#Preview {
    ECardView(birthdayEntry: BirthdayEntry.sampleData[0])
}
