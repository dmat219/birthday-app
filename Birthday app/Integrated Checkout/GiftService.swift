import Foundation
import SwiftUI

class GiftService: ObservableObject {
    @Published var availableGifts: [GiftOption] = []
    @Published var errorMessage: String?

    // TODO: For real gift card integration, we need to:
    // 1. Integrate with gift card aggregator APIs (e.g., GiftUp, GiftCard.com, etc.)
    // 2. Implement real-time inventory checking
    // 3. Handle actual gift card purchases
    // 4. Process real delivery (email/iMessage)
    // 5. Handle payment processing and order fulfillment
    
    init() { // Synchronous initialization
        print("🎁 GiftService: Initializing...")
        // Initialize synchronously with all categories
        let allGifts = mockGiftOptions(for: "food") + 
                      mockGiftOptions(for: "retail") + 
                      mockGiftOptions(for: "experience") + 
                      mockGiftOptions(for: "entertainment")
        
        self.availableGifts = allGifts
        print("🎁 GiftService: Initialized with \(allGifts.count) total gifts across all categories")
    }
    
    // MARK: - Gift Options
    
    func fetchGiftOptions(for category: String) async throws {
        print("🎁 GiftService: Starting to fetch gift options for category: \(category)")
        print("🎁 GiftService: Current availableGifts count: \(availableGifts.count)")
        
        // Simulate API call delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        let mockGifts = mockGiftOptions(for: category)
        print("🎁 GiftService: Mock data generated: \(mockGifts.count) gifts")
        
        await MainActor.run { 
            self.availableGifts = mockGifts
        }
        
        print("🎁 GiftService: Successfully updated availableGifts to: \(availableGifts.count)")
    }
    
    // MARK: - Gift Orders
    
    func createGiftOrder(
        gift: GiftOption,
        amount: Double,
        message: String,
        design: String,
        recipientEmail: String,
        recipientPhone: String,
        deliveryDate: Date?,
        orderId: String
    ) async throws -> GiftOrder {
        // For now, we'll create a mock order
        // Later this will call actual gift card aggregator APIs
        let order = GiftOrder(
            id: orderId,
            gift: gift,
            amount: amount,
            message: message,
            design: design,
            recipientEmail: recipientEmail,
            recipientPhone: recipientPhone,
            deliveryDate: deliveryDate ?? Date(),
            status: .processing,
            createdAt: Date()
        )
        
        // Simulate API call delay
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        return order
    }
    
    // MARK: - Mock Data (Replace with real API calls)
    
    private func mockGiftOptions(for category: String) -> [GiftOption] {
        switch category.lowercased() {
        case "food":
            return [
                GiftOption(id: "1", brandName: "Uber Eats", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/79/Uber_Eats_logo.svg/2560px-Uber_Eats_logo.svg.png", priceRange: "$15 - $200", isPopular: true, category: "Food", minAmount: 15, maxAmount: 200),
                GiftOption(id: "2", brandName: "DoorDash", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/DoorDash_Logo.svg/2560px-DoorDash_Logo.svg.png", priceRange: "$10 - $150", isPopular: true, category: "Food", minAmount: 10, maxAmount: 150),
                GiftOption(id: "3", brandName: "Grubhub", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/Grubhub_logo.svg/2560px-Grubhub_logo.svg.png", priceRange: "$20 - $100", isPopular: false, category: "Food", minAmount: 20, maxAmount: 100),
                GiftOption(id: "4", brandName: "Postmates", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/Postmates_logo.svg/2560px-Postmates_logo.svg.png", priceRange: "$15 - $120", isPopular: false, category: "Food", minAmount: 15, maxAmount: 120),
                GiftOption(id: "5", brandName: "Chipotle", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3b/Chipotle_logo.svg/2560px-Chipotle_logo.svg.png", priceRange: "$25 - $75", isPopular: true, category: "Food", minAmount: 25, maxAmount: 75),
                GiftOption(id: "6", brandName: "Starbucks", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d3/Starbucks_Corporation_Logo_2011.svg/2560px-Starbucks_Corporation_Logo_2011.svg.png", priceRange: "$10 - $100", isPopular: true, category: "Food", minAmount: 10, maxAmount: 100)
            ]
        case "retail":
            return [
                GiftOption(id: "7", brandName: "Amazon", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Amazon_logo.svg/2560px-Amazon_logo.svg.png", priceRange: "$25 - $500", isPopular: true, category: "Retail", minAmount: 25, maxAmount: 500),
                GiftOption(id: "8", brandName: "Target", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/Target_logo.svg/2560px-Target_logo.svg.png", priceRange: "$20 - $200", isPopular: true, category: "Retail", minAmount: 20, maxAmount: 200),
                GiftOption(id: "9", brandName: "Walmart", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/cf/Walmart_logo.svg/2560px-Walmart_logo.svg.png", priceRange: "$15 - $150", isPopular: false, category: "Retail", minAmount: 15, maxAmount: 150),
                GiftOption(id: "10", brandName: "Best Buy", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/Best_Buy_logo.svg/2560px-Best_Buy_logo.svg.png", priceRange: "$50 - $500", isPopular: false, category: "Retail", minAmount: 50, maxAmount: 500),
                GiftOption(id: "11", brandName: "Apple Store", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Apple_logo_black.svg/2560px-Apple_logo_black.svg.png", priceRange: "$25 - $1000", isPopular: true, category: "Retail", minAmount: 25, maxAmount: 1000),
                GiftOption(id: "12", brandName: "Nike", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Nike_Logo.svg/2560px-Nike_Logo.svg.png", priceRange: "$25 - $200", isPopular: true, category: "Retail", minAmount: 25, maxAmount: 200)
            ]
        case "experience":
            return [
                GiftOption(id: "13", brandName: "Airbnb", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/69/Airbnb_Logo_B%C3%A9lo.svg/2560px-Airbnb_Logo_B%C3%A9lo.svg.png", priceRange: "$50 - $500", isPopular: true, category: "Experience", minAmount: 50, maxAmount: 500),
                GiftOption(id: "14", brandName: "Groupon", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/Groupon_logo.svg/2560px-Groupon_logo.svg.png", priceRange: "$20 - $200", isPopular: false, category: "Experience", minAmount: 20, maxAmount: 200),
                GiftOption(id: "15", brandName: "ClassPass", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/ClassPass_logo.svg/2560px-ClassPass_logo.svg.png", priceRange: "$30 - $150", isPopular: false, category: "Experience", minAmount: 30, maxAmount: 150),
                GiftOption(id: "16", brandName: "MasterClass", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/MasterClass_logo.svg/2560px-MasterClass_logo.svg.png", priceRange: "$90 - $180", isPopular: true, category: "Experience", minAmount: 90, maxAmount: 180),
                GiftOption(id: "17", brandName: "Skillshare", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/Skillshare_logo.svg/2560px-Skillshare_logo.svg.png", priceRange: "$25 - $100", isPopular: false, category: "Experience", minAmount: 25, maxAmount: 100),
                GiftOption(id: "18", brandName: "Coursera", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/Coursera_logo.svg/2560px-Coursera_logo.svg.png", priceRange: "$30 - $200", isPopular: true, category: "Experience", minAmount: 30, maxAmount: 200)
            ]
        case "entertainment":
            return [
                GiftOption(id: "19", brandName: "Netflix", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/08/Netflix_2015_logo.svg/2560px-Netflix_2015_logo.svg.png", priceRange: "$15 - $100", isPopular: true, category: "Entertainment", minAmount: 15, maxAmount: 100),
                GiftOption(id: "20", brandName: "Spotify", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/84/Spotify_icon.svg/2560px-Spotify_icon.svg.png", priceRange: "$10 - $120", isPopular: true, category: "Entertainment", minAmount: 10, maxAmount: 120),
                GiftOption(id: "21", brandName: "Hulu", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e4/Hulu_Logo.svg/2560px-Hulu_Logo.svg.png", priceRange: "$12 - $120", isPopular: false, category: "Entertainment", minAmount: 12, maxAmount: 120),
                GiftOption(id: "22", brandName: "Disney+", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3e/Disney%2B_logo.svg/2560px-Disney%2B_logo.svg.png", priceRange: "$8 - $80", isPopular: true, category: "Entertainment", minAmount: 8, maxAmount: 80),
                GiftOption(id: "23", brandName: "HBO Max", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/HBO_Max_Logo.svg/2560px-HBO_Max_Logo.svg.png", priceRange: "$15 - $150", isPopular: false, category: "Entertainment", minAmount: 15, maxAmount: 150),
                GiftOption(id: "24", brandName: "YouTube Premium", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/09/YouTube_full-color_icon_%282017%29.svg/2560px-YouTube_full-color_icon_%282017%29.svg.png", priceRange: "$12 - $120", isPopular: true, category: "Entertainment", minAmount: 12, maxAmount: 120)
            ]
        default:
            return []
        }
    }
    
    // MARK: - Real API Integration (Future Implementation)
    
    /*
    // Example of how to integrate with a real gift card aggregator API
    private func fetchGiftsFromAPI(for category: String) async throws -> [GiftOption] {
        guard let url = URL(string: "https://api.giftup.com/gifts?category=\(category)") else {
            throw GiftServiceError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer YOUR_API_KEY", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw GiftServiceError.invalidResponse
        }
        
        let gifts = try JSONDecoder().decode([GiftOption].self, from: data)
        return gifts
    }
    
    private func createOrderWithAPI(order: GiftOrder) async throws -> GiftOrder {
        guard let url = URL(string: "https://api.giftup.com/orders") else {
            throw GiftServiceError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer YOUR_API_KEY", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let orderData = try JSONEncoder().encode(order)
        request.httpBody = orderData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 201 else {
            throw GiftServiceError.orderCreationFailed
        }
        
        let createdOrder = try JSONDecoder().decode(GiftOrder.self, from: data)
        return createdOrder
    }
    */
}

// MARK: - Data Models

struct GiftOrder: Identifiable, Codable {
    let id: String
    let gift: GiftOption
    let amount: Double
    let message: String
    let design: String
    let recipientEmail: String
    let recipientPhone: String
    let deliveryDate: Date
    let status: OrderStatus
    let createdAt: Date
    
    var totalAmount: Double {
        amount + 2.99 // Service fee
    }
}

enum OrderStatus: String, Codable, CaseIterable {
    case processing = "processing"
    case confirmed = "confirmed"
    case delivered = "delivered"
    case failed = "failed"
    
    var displayName: String {
        switch self {
        case .processing: return "Processing"
        case .confirmed: return "Confirmed"
        case .delivered: return "Delivered"
        case .failed: return "Failed"
        }
    }
    
    var color: Color {
        switch self {
        case .processing: return .orange
        case .confirmed: return .blue
        case .delivered: return .green
        case .failed: return .red
        }
    }
}

// MARK: - Errors

enum GiftServiceError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case orderCreationFailed
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .orderCreationFailed:
            return "Failed to create order"
        case .networkError:
            return "Network error occurred"
        }
    }
}

// MARK: - Extensions

extension GiftOption {
    var formattedPriceRange: String {
        return "$\(Int(minAmount)) - $\(Int(maxAmount))"
    }
    
    var isExpensive: Bool {
        return maxAmount > 100
    }
    
    var isBudgetFriendly: Bool {
        return maxAmount <= 50
    }
}
