//
//  MonetizationView.swift
//  Birthday app
//
//  Created by David Mathew on 7/4/25.
//

import SwiftUI

struct MonetizationView: View {
    @State private var selectedPlan: SubscriptionPlan = .free
    @State private var showingPurchase = false
    
    enum SubscriptionPlan: String, CaseIterable {
        case free = "Free"
        case premium = "Premium"
        case family = "Family"
        
        var price: String {
            switch self {
            case .free: return "Free"
            case .premium: return "$2.99/month"
            case .family: return "$4.99/month"
            }
        }
        
        var features: [String] {
            switch self {
            case .free:
                return [
                    "Basic birthday tracking",
                    "Daily notifications",
                    "Simple e-cards",
                    "Contact import"
                ]
            case .premium:
                return [
                    "Everything in Free",
                    "Ad-free experience",
                    "Premium e-card designs",
                    "Gift suggestions",
                    "Advanced notifications",
                    "Birthday registry"
                ]
            case .family:
                return [
                    "Everything in Premium",
                    "Up to 5 family members",
                    "Shared birthday lists",
                    "Family gift coordination",
                    "Priority support"
                ]
            }
        }
        
        var color: Color {
            switch self {
            case .free: return .gray
            case .premium: return .blue
            case .family: return .purple
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("🌟 Premium Features")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Unlock the full potential of your birthday app")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top)
                    
                    // Current Plan
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Current Plan")
                            .font(.headline)
                        
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("You're currently on the \(selectedPlan.rawValue) plan")
                                .font(.subheadline)
                            Spacer()
                        }
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    // Subscription Plans
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Choose Your Plan")
                            .font(.headline)
                        
                        ForEach(SubscriptionPlan.allCases, id: \.self) { plan in
                            PlanCard(
                                plan: plan,
                                isSelected: selectedPlan == plan,
                                onSelect: { selectedPlan = plan }
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Premium Features Demo
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Premium Features Preview")
                            .font(.headline)
                        
                        VStack(spacing: 12) {
                            PremiumFeatureRow(
                                icon: "star.fill",
                                title: "Premium E-Cards",
                                description: "Beautiful, animated e-cards with custom themes",
                                color: .yellow
                            )
                            
                            PremiumFeatureRow(
                                icon: "gift.fill",
                                title: "Birthday Registry",
                                description: "Create and share birthday wish lists",
                                color: .red
                            )
                            
                            PremiumFeatureRow(
                                icon: "bell.fill",
                                title: "Smart Reminders",
                                description: "Advanced notification scheduling and customization",
                                color: .blue
                            )
                            
                            PremiumFeatureRow(
                                icon: "chart.line.uptrend.xyaxis",
                                title: "Gift Analytics",
                                description: "Track your gift-giving history and preferences",
                                color: .green
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Purchase Button
                    Button(action: {
                        showingPurchase = true
                    }) {
                        HStack {
                            Image(systemName: "cart.fill")
                            Text("Upgrade to \(selectedPlan.rawValue)")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedPlan.color)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .disabled(selectedPlan == .free)
                    
                    // Ad Integration Demo
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Ad-Free Experience")
                            .font(.headline)
                        
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                Text("No banner ads")
                                Spacer()
                            }
                            
                            HStack {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                Text("No pop-up interruptions")
                                Spacer()
                            }
                            
                            HStack {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                Text("No sponsored content")
                                Spacer()
                            }
                        }
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 30)
                }
            }
            .navigationTitle("Premium")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingPurchase) {
                PurchaseView(plan: selectedPlan)
            }
        }
    }
}

struct PlanCard: View {
    let plan: MonetizationView.SubscriptionPlan
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(plan.rawValue)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(plan.price)
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(plan.color)
                            .font(.title2)
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(plan.features, id: \.self) { feature in
                        HStack {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                                .font(.caption)
                            Text(feature)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? plan.color.opacity(0.1) : Color.gray.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? plan.color : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PremiumFeatureRow: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

struct PurchaseView: View {
    let plan: MonetizationView.SubscriptionPlan
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Image(systemName: "creditcard.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("Upgrade to \(plan.rawValue)")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("You'll be charged \(plan.price) monthly")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("What you'll get:")
                        .font(.headline)
                    
                    ForEach(plan.features, id: \.self) { feature in
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text(feature)
                            Spacer()
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                
                Spacer()
                
                Button("Complete Purchase") {
                    // In a real app, this would integrate with StoreKit
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(plan.color)
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("Purchase")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    MonetizationView()
}
