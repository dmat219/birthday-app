import SwiftUI

struct UnifiedCheckoutView: View {
    let birthdayEntry: BirthdayEntry
    let gift: GiftOption
    let amount: Double
    let message: String
    let design: String
    
    @EnvironmentObject var giftService: GiftService
    @Environment(\.presentationMode) var presentationMode
    @State private var recipientEmail: String = ""
    @State private var recipientPhone: String = ""
    @State private var deliveryDate: Date = Date()
    @State private var isScheduled: Bool = false
    @State private var showPaymentSheet = false
    @State private var isProcessing = false
    @State private var showSuccess = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    giftDetailsSection
                    recipientSection
                    deliverySection
                    orderSummarySection
                    termsSection
                    checkoutSection
                }
                .padding(.vertical)
            }
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .onAppear {
                // Prepopulate recipient fields with existing data
                if let phone = birthdayEntry.phoneNumber, !phone.isEmpty {
                    recipientPhone = phone
                }
                // Note: We don't have email in BirthdayEntry, so we can't prepopulate that
            }
            .sheet(isPresented: $showPaymentSheet) {
                PaymentView(
                    amount: amount + 2.99,
                    onSuccess: { orderId in
                        Task {
                            await processOrder(orderId: orderId)
                        }
                    }
                )
            }
            .sheet(isPresented: $showSuccess) {
                OrderSuccessView(
                    birthdayEntry: birthdayEntry,
                    gift: gift,
                    amount: amount
                )
            }
        }
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Text("🎁 Gift Order Summary")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("for \(birthdayEntry.name)")
                .font(.title2)
                .foregroundColor(.secondary)
        }
        .padding(.top)
    }
    
    private var giftDetailsSection: some View {
        GiftDetailsCard(
            gift: gift,
            amount: amount,
            message: message,
            design: design
        )
        .padding(.horizontal)
    }
    
    private var recipientSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recipient Information")
                .font(.headline)
                .padding(.horizontal)
            
            Text("💡 Provide either email or phone number for gift delivery")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            VStack(spacing: 16) {
                // Email
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email Address")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    TextField("recipient@email.com", text: $recipientEmail)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                // Phone
                VStack(alignment: .leading, spacing: 8) {
                    Text("Phone Number")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    TextField("(555) 123-4567", text: $recipientPhone)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.phonePad)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var deliverySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Delivery Options")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(spacing: 16) {
                // Immediate vs Scheduled
                HStack {
                    Button(action: { isScheduled = false }) {
                        HStack {
                            Image(systemName: isScheduled ? "circle" : "checkmark.circle.fill")
                                .foregroundColor(isScheduled ? .gray : .blue)
                            Text("Send Immediately")
                                .fontWeight(.medium)
                        }
                        .foregroundColor(isScheduled ? .gray : .primary)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                    
                    Button(action: { isScheduled = true }) {
                        HStack {
                            Image(systemName: isScheduled ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(isScheduled ? .blue : .gray)
                            Text("Schedule for Later")
                                .fontWeight(.medium)
                        }
                        .foregroundColor(isScheduled ? .primary : .gray)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // Date Picker (if scheduled)
                if isScheduled {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Delivery Date")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        DatePicker("", selection: $deliveryDate, in: Date()..., displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .labelsHidden()
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var orderSummarySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Order Summary")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                OrderSummaryRow(label: "\(gift.brandName) Gift Card", value: "$\(String(format: "%.2f", amount))")
                OrderSummaryRow(label: "Service Fee", value: "$2.99")
                OrderSummaryRow(label: "Tax", value: "$0.00")
                
                Divider()
                
                OrderSummaryRow(label: "Total", value: "$\(String(format: "%.2f", amount + 2.99))", isTotal: true)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.05))
            )
            .padding(.horizontal)
        }
    }
    
    private var termsSection: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
                Text("By continuing, you agree to our Terms of Service and Privacy Policy")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal)
            
            Text("Gift cards are typically delivered within 24 hours")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
    
    private var checkoutSection: some View {
        VStack(spacing: 16) {
            // Apple Pay Button
            Button(action: {
                showPaymentSheet = true
            }) {
                HStack {
                    if isProcessing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "applelogo")
                            .font(.title2)
                        Text("Pay with Apple Pay")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(canProceed ? Color.black : Color.gray)
                )
            }
            .disabled(!canProceed || isProcessing)
            .padding(.horizontal)
            
            // Alternative payment option
            Button(action: {
                showPaymentSheet = true
            }) {
                Text("Other Payment Methods")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            .disabled(!canProceed || isProcessing)
            
            if !canProceed {
                Text("Please provide either email or phone number")
                    .font(.caption)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
    }
    
    private var canProceed: Bool {
        // Require either email OR phone number, plus valid amount
        let hasValidEmail = !recipientEmail.isEmpty && recipientEmail.contains("@")
        let hasValidPhone = !recipientPhone.isEmpty && recipientPhone.count >= 10
        
        return (hasValidEmail || hasValidPhone) && amount > 0
    }
    
    private func processOrder(orderId: String) async {
        isProcessing = true
        
        do {
            let _ = try await giftService.createGiftOrder(
                gift: gift,
                amount: amount,
                message: message,
                design: design,
                recipientEmail: recipientEmail,
                recipientPhone: recipientPhone,
                deliveryDate: isScheduled ? deliveryDate : nil,
                orderId: orderId
            )
            
            DispatchQueue.main.async {
                isProcessing = false
                showSuccess = true
            }
        } catch {
            DispatchQueue.main.async {
                isProcessing = false
                // Show error alert
                print("Error processing order: \(error)")
            }
        }
    }
}

// MARK: - Supporting Views

struct GiftDetailsCard: View {
    let gift: GiftOption
    let amount: Double
    let message: String
    let design: String
    
    var body: some View {
        VStack(spacing: 16) {
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
                    
                    Text("$\(Int(amount))")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
                
                Spacer()
            }
            
            if !message.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Personal Message")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text(message)
                        .font(.body)
                        .foregroundColor(.primary)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue.opacity(0.1))
                        )
                }
            }
            
            HStack {
                Text("Design:")
                    .fontWeight(.medium)
                Text(design)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("Category:")
                    .fontWeight(.medium)
                Text(gift.category.capitalized)
                    .foregroundColor(.secondary)
            }
            .font(.subheadline)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

struct OrderSummaryRow: View {
    let label: String
    let value: String
    let isTotal: Bool
    
    init(label: String, value: String, isTotal: Bool = false) {
        self.label = label
        self.value = value
        self.isTotal = isTotal
    }
    
    var body: some View {
        HStack {
            Text(label)
                .fontWeight(isTotal ? .bold : .medium)
                .foregroundColor(isTotal ? .primary : .secondary)
            
            Spacer()
            
            Text(value)
                .fontWeight(isTotal ? .bold : .medium)
                .foregroundColor(isTotal ? .primary : .secondary)
        }
        .font(isTotal ? .headline : .subheadline)
    }
}

// MARK: - Placeholder Views (to be implemented)

struct PaymentView: View {
    let amount: Double
    let onSuccess: (String) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    // TODO: For real Apple Pay integration, we need to:
    // 1. Import PassKit framework
    // 2. Implement PKPaymentAuthorizationControllerDelegate
    // 3. Create PKPaymentRequest with merchant ID, payment networks, etc.
    // 4. Handle real payment authorization
    // 5. Process actual payment through payment processor
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Payment")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Total Amount")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("$\(String(format: "%.2f", amount))")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                }
                .padding(.top)
                
                Spacer()
                
                // Apple Pay Button (Primary)
                Button(action: {
                    // Simulate Apple Pay success
                    onSuccess("ORDER_\(Int.random(in: 100000...999999))")
                }) {
                    HStack {
                        Image(systemName: "applelogo")
                            .font(.title2)
                        Text("Pay with Apple Pay")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.black)
                    )
                }
                .padding(.horizontal)
                
                // Alternative payment methods
                VStack(spacing: 16) {
                    Text("Other Payment Methods")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Button("Credit/Debit Card") {
                        // Simulate card payment
                        onSuccess("ORDER_\(Int.random(in: 100000...999999))")
                    }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)
                    
                    Button("PayPal") {
                        // Simulate PayPal payment
                        onSuccess("ORDER_\(Int.random(in: 100000...999999))")
                    }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Security info
                HStack {
                    Image(systemName: "lock.shield")
                        .foregroundColor(.green)
                    Text("Secure payment powered by Apple Pay")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom)
            }
            .navigationTitle("Payment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct OrderSuccessView: View {
    let birthdayEntry: BirthdayEntry
    let gift: GiftOption
    let amount: Double
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
            
            Text("Gift Order Successful! 🎉")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 8) {
                Text("Your \(gift.brandName) gift card")
                Text("for \(birthdayEntry.name) has been ordered")
                Text("Amount: $\(Int(amount))")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            
            VStack(spacing: 12) {
                Text("What happens next?")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                VStack(alignment: .leading, spacing: 8) {
                    SuccessStep(icon: "envelope", text: "Gift card will be sent")
                    SuccessStep(icon: "clock", text: "Delivery within 24 hours")
                    SuccessStep(icon: "bell", text: "You'll receive delivery confirmation")
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.green.opacity(0.1))
            )
            
            Button("Done") {
                // Dismiss and return to main app
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

struct SuccessStep: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.green)
                .frame(width: 20)
            
            Text(text)
                .font(.subheadline)
            
            Spacer()
        }
    }
}

#Preview {
    UnifiedCheckoutView(
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
        ),
        amount: 50,
        message: "Happy Birthday! Enjoy your coffee!",
        design: "Birthday"
    )
}
