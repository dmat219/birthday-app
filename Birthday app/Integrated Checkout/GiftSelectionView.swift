import SwiftUI

struct GiftSelectionView: View {
    let birthdayEntry: BirthdayEntry
    @ObservedObject var giftService: GiftService
    @State private var selectedCategory: GiftCategory = .food
    @State private var selectedBrand: GiftOption?
    @State private var showGiftAmount = false
    @State private var currentFilteredGifts: [GiftOption] = []
    
    // Remove the computed property and use @State instead
    
    private func updateFilteredGifts() {
        let gifts = giftService.availableGifts.filter { $0.category.lowercased() == selectedCategory.rawValue.lowercased() }
        currentFilteredGifts = gifts
        print("🎁 GiftSelectionView: Updated filtered gifts to \(gifts.count) for category: \(selectedCategory.rawValue)")
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 12) {
                    Text("🎁 Choose a Gift")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("for \(birthdayEntry.name)")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 24)
                .padding(.horizontal, 20)
                
                // Category Selection
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(GiftCategory.allCases, id: \.self) { category in
                            CategoryButton(
                                category: category,
                                isSelected: selectedCategory == category,
                                action: {
                                    selectedCategory = category
                                    print("🎁 GiftSelectionView: Category changed to: \(category.rawValue)")
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 24)
                
                // Brand Grid
                if currentFilteredGifts.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "gift")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("No gifts available for this category.")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2), spacing: 24) {
                        ForEach(currentFilteredGifts, id: \.id) { gift in
                            BrandCard(
                                gift: gift,
                                action: {
                                    print("🎁 GiftSelectionView: BrandCard tapped for: \(gift.brandName)")
                                    selectedBrand = gift
                                    print("🎁 GiftSelectionView: selectedBrand set to: \(gift.brandName)")
                                    showGiftAmount = true
                                    print("🎁 GiftSelectionView: showGiftAmount set to true")
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                print("🎁 GiftSelectionView: View appeared for \(birthdayEntry.name)")
                print("🎁 GiftSelectionView: Current gifts count: \(giftService.availableGifts.count)")
                print("🎁 GiftSelectionView: Selected category: \(selectedCategory.rawValue)")
                print("🎁 GiftSelectionView: Filtered gifts count: \(currentFilteredGifts.count)")
                updateFilteredGifts()
            }
            .onChange(of: selectedCategory) { newCategory in
                print("🎁 GiftSelectionView: Category changed to \(newCategory.rawValue)")
                updateFilteredGifts()
            }
            .onChange(of: showGiftAmount) { newValue in
                print("🎁 GiftSelectionView: showGiftAmount changed to: \(newValue)")
                if newValue {
                    print("🎁 GiftSelectionView: About to present sheet, selectedBrand: \(selectedBrand?.brandName ?? "nil")")
                }
            }
            .sheet(isPresented: $showGiftAmount) {
                if let brand = selectedBrand {
                    GiftAmountView(
                        birthdayEntry: birthdayEntry,
                        gift: brand
                    )
                    .environmentObject(giftService)
                } else {
                    Text("Error: No brand selected")
                        .onAppear {
                            print("❌ GiftSelectionView: Error view appeared - selectedBrand is nil")
                        }
                }
            }
        }
    }
    
    private func loadGiftsForCategory(_ category: GiftCategory) async {
        print("🎁 GiftSelectionView: Loading gifts for category: \(category.rawValue)")
        do {
            try await giftService.fetchGiftOptions(for: category.rawValue)
            print("🎁 GiftSelectionView: Successfully loaded \(giftService.availableGifts.count) gifts")
        } catch {
            print("❌ GiftSelectionView: Error loading gifts: \(error)")
        }
    }
}

// MARK: - Supporting Views

struct CategoryButton: View {
    let category: GiftCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: category.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : category.color)
                
                Text(category.displayName)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .primary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 90, height: 90)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? category.color : Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? category.color : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct BrandCard: View {
    let gift: GiftOption
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                // Brand Logo/Image with better spacing
                AsyncImage(url: URL(string: gift.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 50)
                } placeholder: {
                    // Clean placeholder with no background
                    Image(systemName: "gift")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .frame(height: 50)
                }
                .frame(maxWidth: .infinity)
                
                // Brand Name with consistent height
                Text(gift.brandName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .frame(height: 32) // Fixed height for consistency
                
                // Price Range
                Text(gift.priceRange)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .frame(height: 16) // Fixed height for consistency
                
                // Popular Badge with consistent spacing
                if gift.isPopular {
                    Text("🔥 Popular")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.orange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.orange.opacity(0.1))
                        )
                        .frame(height: 20) // Fixed height for consistency
                } else {
                    // Invisible spacer to maintain consistent height
                    Spacer()
                        .frame(height: 20)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .frame(height: 180)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(.separator), lineWidth: 0.5)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Data Models

enum GiftCategory: String, CaseIterable {
    case food = "food"
    case retail = "retail"
    case experience = "experience"
    case entertainment = "entertainment"
    
    var displayName: String {
        switch self {
        case .food: return "Food & Dining"
        case .retail: return "Shopping"
        case .experience: return "Experiences"
        case .entertainment: return "Entertainment"
        }
    }
    
    var icon: String {
        switch self {
        case .food: return "fork.knife"
        case .retail: return "bag"
        case .experience: return "ticket"
        case .entertainment: return "play.circle"
        }
    }
    
    var color: Color {
        switch self {
        case .food: return .orange
        case .retail: return .blue
        case .experience: return .purple
        case .entertainment: return .pink
        }
    }
}

struct GiftOption: Identifiable, Codable {
    let id: String
    let brandName: String
    let imageURL: String
    let priceRange: String
    let isPopular: Bool
    let category: String
    let minAmount: Double
    let maxAmount: Double
}

#Preview {
    GiftSelectionView(
        birthdayEntry: BirthdayEntry.sampleData[0],
        giftService: GiftService()
    )
}
