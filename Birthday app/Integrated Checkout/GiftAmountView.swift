import SwiftUI

struct GiftAmountView: View {
    let birthdayEntry: BirthdayEntry
    let gift: GiftOption
    @EnvironmentObject var giftService: GiftService
    @State private var selectedAmount: Double = 25.0
    @State private var personalMessage: String = ""
    @State private var selectedDesign: String = "Classic"
    @State private var showCheckout = false
    @State private var isLoading = false
    
    private let presetAmounts: [Double] = [15, 25, 50, 75, 100, 150, 200]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header with Gift Info
                    VStack(spacing: 16) {
                        // Gift Brand Info
                        HStack(spacing: 16) {
                            AsyncImage(url: URL(string: gift.imageURL)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.2))
                                    .overlay(
                                        Image(systemName: "gift")
                                            .foregroundColor(.gray)
                                    )
                            }
                            .frame(width: 80, height: 80)
                            .cornerRadius(12)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(gift.brandName)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Text("Gift Card")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text("for \(birthdayEntry.name)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.gray.opacity(0.05))
                        )
                    }
                    
                    // Amount Selection
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Select Amount")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(presetAmounts, id: \.self) { amount in
                                    AmountButton(
                                        amount: amount,
                                        isSelected: selectedAmount == amount,
                                        action: { selectedAmount = amount }
                                    )
                                }
                                
                                // Custom Amount
                                CustomAmountButton(
                                    amount: selectedAmount,
                                    isSelected: !presetAmounts.contains(selectedAmount),
                                    action: { /* Show custom amount picker */ }
                                )
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Personal Message
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Personal Message")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        TextField("Add a personal message...", text: $personalMessage, axis: .vertical)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .lineLimit(3...6)
                            .padding(.horizontal)
                    }
                    
                    // Gift Card Design
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Gift Card Design")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(giftCardDesigns, id: \.self) { design in
                                    DesignButton(
                                        design: design,
                                        isSelected: selectedDesign == design,
                                        action: { selectedDesign = design }
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Preview
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Preview")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        GiftCardPreview(
                            brandName: gift.brandName,
                            amount: selectedAmount,
                            message: personalMessage,
                            design: selectedDesign
                        )
                        .padding(.horizontal)
                    }
                    
                    // Checkout Button
                    VStack(spacing: 16) {
                        Button(action: {
                            showCheckout = true
                        }) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Text("Continue to Checkout")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(selectedAmount > 0 ? Color.blue : Color.gray)
                            )
                        }
                        .disabled(selectedAmount <= 0 || isLoading)
                        .padding(.horizontal)
                        
                        Text("You'll be able to review and pay on the next screen")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Gift Amount")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        // Dismiss view
                    }
                }
            }
            .sheet(isPresented: $showCheckout) {
                UnifiedCheckoutView(
                    birthdayEntry: birthdayEntry,
                    gift: gift,
                    amount: selectedAmount,
                    message: personalMessage,
                    design: selectedDesign
                )
                .environmentObject(giftService)
            }
        }
    }
}

// MARK: - Supporting Views

struct AmountButton: View {
    let amount: Double
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("$\(Int(amount))")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(isSelected ? .white : .primary)
                .frame(width: 80, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? Color.blue : Color.gray.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CustomAmountButton: View {
    let amount: Double
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("$\(Int(amount))")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(isSelected ? .white : .primary)
                .frame(width: 80, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? Color.blue : Color.gray.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct DesignButton: View {
    let design: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(designColor(for: design))
                    .frame(width: 60, height: 40)
                    .overlay(
                        Text("🎨")
                            .font(.title3)
                    )
                
                Text(design)
                    .font(.caption)
                    .foregroundColor(isSelected ? .blue : .primary)
            }
            .frame(width: 80, height: 70)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func designColor(for design: String) -> Color {
        switch design {
        case "Classic": return .blue
        case "Birthday": return .pink
        case "Elegant": return .purple
        case "Fun": return .orange
        case "Minimal": return .gray
        default: return .blue
        }
    }
}

struct GiftCardPreview: View {
    let brandName: String
    let amount: Double
    let message: String
    let design: String
    
    var body: some View {
        VStack(spacing: 16) {
            // Gift Card Visual
            RoundedRectangle(cornerRadius: 16)
                .fill(designColor(for: design))
                .frame(height: 120)
                .overlay(
                    VStack(spacing: 8) {
                        Text(brandName)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("$\(Int(amount))")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        if !message.isEmpty {
                            Text(message)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                    }
                )
            
            // Summary
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Gift Card Amount:")
                    Spacer()
                    Text("$\(Int(amount))")
                        .fontWeight(.semibold)
                }
                
                HStack {
                    Text("Design:")
                    Spacer()
                    Text(design)
                        .fontWeight(.semibold)
                }
                
                if !message.isEmpty {
                    HStack {
                        Text("Message:")
                        Spacer()
                        Text(message)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                    }
                }
            }
            .font(.subheadline)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.05))
            )
        }
    }
    
    private func designColor(for design: String) -> Color {
        switch design {
        case "Classic": return .blue
        case "Birthday": return .pink
        case "Elegant": return .purple
        case "Fun": return .orange
        case "Minimal": return .gray
        default: return .blue
        }
    }
}

// MARK: - Data

private let giftCardDesigns = ["Classic", "Birthday", "Elegant", "Fun", "Minimal"]

#Preview {
    GiftAmountView(
        birthdayEntry: BirthdayEntry.sampleData[0],
        gift: GiftOption(
            id: "1",
            brandName: "Starbucks",
            imageURL: "",
            priceRange: "$15 - $200",
            isPopular: true,
            category: "food",
            minAmount: 15,
            maxAmount: 200
        )
    )
}
