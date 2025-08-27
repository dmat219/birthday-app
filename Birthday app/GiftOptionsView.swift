//
//  GiftOptionsView.swift
//  Birthday app
//
//  Created by David Mathew on 7/4/25.
//

import SwiftUI
import SafariServices
import UIKit

// MARK: - Gift Option Model

struct GiftOption: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let category: GiftCategory
    let type: GiftType
    let webURL: String
    let icon: String
    let color: Color
    let giftCardURL: String // Added for Safari integration
    
    enum GiftType {
        case app
        case web
    }
    
    enum GiftCategory: String, CaseIterable { // New enum for categories
        case flowers = "Flowers & Gifts"
        case food = "Food & Delivery"
        case retail = "Retail & Shopping"
        case entertainment = "Entertainment"
        
        var icon: String {
            switch self {
            case .flowers: return "leaf.fill"
            case .food: return "car.fill"
            case .retail: return "bag.fill"
            case .entertainment: return "tv.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .flowers: return .pink
            case .food: return .green
            case .retail: return .orange
            case .entertainment: return .blue
            }
        }
    }
    
    static let allOptions: [GiftOption] = [
        GiftOption(title: "Uber Eats", subtitle: "Food Delivery", category: .food, type: .app, webURL: "https://www.ubereats.com", icon: "car.fill", color: .green, giftCardURL: "https://www.uber.com/gift-cards"),
        GiftOption(title: "Amazon", subtitle: "Online Shopping", category: .retail, type: .app, webURL: "https://www.amazon.com", icon: "bag.fill", color: .orange, giftCardURL: "https://www.amazon.com/gift-cards"),
        GiftOption(title: "DoorDash", subtitle: "Food Delivery", category: .food, type: .app, webURL: "https://www.doordash.com", icon: "car.fill", color: .red, giftCardURL: "https://www.doordash.com/gift-cards"),
        GiftOption(title: "Grubhub", subtitle: "Food Delivery", category: .food, type: .app, webURL: "https://www.grubhub.com", icon: "car.fill", color: .orange, giftCardURL: "https://www.grubhub.com"),
        GiftOption(title: "Postmates", subtitle: "Food Delivery", category: .food, type: .app, webURL: "https://www.postmates.com", icon: "car.fill", color: .blue, giftCardURL: "https://www.postmates.com"),
        GiftOption(title: "Target", subtitle: "Retail Store", category: .retail, type: .app, webURL: "https://www.target.com", icon: "bag.fill", color: .red, giftCardURL: "https://www.target.com/c/gift-cards"),
        GiftOption(title: "Walmart", subtitle: "Retail Store", category: .retail, type: .app, webURL: "https://www.walmart.com", icon: "bag.fill", color: .blue, giftCardURL: "https://www.walmart.com/c/gift-cards"),
        GiftOption(title: "Best Buy", subtitle: "Electronics", category: .retail, type: .app, webURL: "https://www.bestbuy.com", icon: "laptopcomputer", color: .blue, giftCardURL: "https://www.bestbuy.com/site/gift-cards"),
        GiftOption(title: "Starbucks", subtitle: "Coffee & Drinks", category: .food, type: .app, webURL: "https://www.starbucks.com", icon: "cup.and.saucer.fill", color: .green, giftCardURL: "https://www.starbucks.com/card"),
        GiftOption(title: "Netflix", subtitle: "Streaming", category: .entertainment, type: .app, webURL: "https://www.netflix.com", icon: "tv.fill", color: .red, giftCardURL: "https://www.netflix.com/gift-cards"),
        GiftOption(title: "Spotify", subtitle: "Music Streaming", category: .entertainment, type: .app, webURL: "https://www.spotify.com", icon: "music.note", color: .green, giftCardURL: "https://www.spotify.com/gift-cards"),
        GiftOption(title: "Apple", subtitle: "Technology", category: .retail, type: .app, webURL: "https://www.apple.com", icon: "applelogo", color: .gray, giftCardURL: "https://www.apple.com/gift-cards"),
        GiftOption(title: "Google Play", subtitle: "Digital Content", category: .entertainment, type: .app, webURL: "https://play.google.com", icon: "play.fill", color: .green, giftCardURL: "https://play.google.com/store/gift-cards"),
        GiftOption(title: "Steam", subtitle: "Gaming", category: .entertainment, type: .app, webURL: "https://store.steampowered.com", icon: "gamecontroller.fill", color: .blue, giftCardURL: "https://store.steampowered.com/digitalgiftcards"),
        GiftOption(title: "Xbox", subtitle: "Gaming", category: .entertainment, type: .app, webURL: "https://www.xbox.com", icon: "gamecontroller.fill", color: .green, giftCardURL: "https://www.xbox.com/en-US/gift-cards"),
        GiftOption(title: "PlayStation", subtitle: "Gaming", category: .entertainment, type: .app, webURL: "https://www.playstation.com", icon: "gamecontroller.fill", color: .blue, giftCardURL: "https://www.playstation.com/en-us/gift-cards/"),
        GiftOption(title: "Nintendo", subtitle: "Gaming", category: .entertainment, type: .app, webURL: "https://www.nintendo.com", icon: "gamecontroller.fill", color: .red, giftCardURL: "https://www.nintendo.com/gift-cards/"),
        GiftOption(title: "1-800-Flowers", subtitle: "Flower Delivery", category: .flowers, type: .web, webURL: "https://www.1800flowers.com", icon: "leaf.fill", color: .pink, giftCardURL: "https://www.1800flowers.com"),
        GiftOption(title: "FTD", subtitle: "Flower Delivery", category: .flowers, type: .web, webURL: "https://www.ftd.com", icon: "leaf.fill", color: .purple, giftCardURL: "https://www.ftd.com"),
        GiftOption(title: "ProFlowers", subtitle: "Flower Delivery", category: .flowers, type: .web, webURL: "https://www.proflowers.com", icon: "leaf.fill", color: .pink, giftCardURL: "https://www.proflowers.com"),
        GiftOption(title: "Teleflora", subtitle: "Flower Delivery", category: .flowers, type: .web, webURL: "https://www.teleflora.com", icon: "leaf.fill", color: .orange, giftCardURL: "https://www.teleflora.com"),
        GiftOption(title: "Bouqs", subtitle: "Flower Delivery", category: .flowers, type: .web, webURL: "https://www.bouqs.com", icon: "leaf.fill", color: .green, giftCardURL: "https://www.bouqs.com"),
        GiftOption(title: "UrbanStems", subtitle: "Flower Delivery", category: .flowers, type: .web, webURL: "https://www.urbanstems.com", icon: "leaf.fill", color: .pink, giftCardURL: "https://www.urbanstems.com")
    ]
}

struct GiftOptionsView: View {
    let birthdayEntry: BirthdayEntry
    @State private var showingSafari = false
    @State private var safariURL: URL?
    @State private var selectedCategory: GiftOption.GiftCategory = .flowers
    @State private var isViewLoaded = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with birthday person info
                VStack(spacing: 12) {
                    Text("🎁 Gift Options")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("for \(birthdayEntry.name)")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    
                    if let notes = birthdayEntry.notes, !notes.isEmpty {
                        Text(notes)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                .padding(.top)
                .padding(.bottom, 20)
                
                // Category Picker
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(GiftOption.GiftCategory.allCases, id: \.self) { category in
                            CategoryButton(
                                category: category,
                                isSelected: selectedCategory == category
                            ) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedCategory = category
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.05))
                
                // Gift Options Grid
                if isViewLoaded {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                            ForEach(filteredGiftOptions, id: \.id) { option in
                                GiftOptionCard(option: option) {
                                    openGiftOption(option)
                                }
                            }
                        }
                        .padding()
                    }
                } else {
                    // Loading state
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Loading gift options...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("Gift Options")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                print("🎁 GiftOptionsView: onAppear for \(birthdayEntry.name)")
                print("🎁 GiftOptionsView: Current gifts count: \(GiftOption.allOptions.count)")
                print("🎁 GiftOptionsView: Selected category: \(selectedCategory)")
                print("🎁 GiftOptionsView: Filtered gifts count: \(filteredGiftOptions.count)")
                print("🎁 GiftOptionsView: isViewLoaded before: \(isViewLoaded)")
                
                // Ensure view is loaded after a brief delay to avoid SwiftUI timing issues
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    print("🎁 GiftOptionsView: Setting isViewLoaded to true")
                    isViewLoaded = true
                    print("🎁 GiftOptionsView: isViewLoaded after: \(isViewLoaded)")
                    print("🎁 GiftOptionsView: View loaded, showing content")
                }
            }
            .onChange(of: isViewLoaded) { newValue in
                print("🎁 GiftOptionsView: isViewLoaded changed to: \(newValue)")
            }
            .onChange(of: selectedCategory) { newValue in
                print("🎁 GiftOptionsView: selectedCategory changed to: \(newValue)")
                print("🎁 GiftOptionsView: Filtered gifts count: \(filteredGiftOptions.count)")
            }
            .onChange(of: showingSafari) { newValue in
                print("🎁 GiftOptionsView: showingSafari changed to: \(newValue)")
                if newValue {
                    print("🎁 GiftOptionsView: Safari sheet is being presented")
                    print("🎁 GiftOptionsView: Current safariURL: \(safariURL?.absoluteString ?? "nil")")
                } else {
                    print("🎁 GiftOptionsView: Safari sheet is being dismissed")
                }
            }
            .onChange(of: safariURL) { newValue in
                print("🎁 GiftOptionsView: safariURL changed to: \(newValue?.absoluteString ?? "nil")")
            }
            .sheet(isPresented: $showingSafari) {
                if let url = safariURL {
                    SafariView(url: url)
                        .onAppear {
                            print("🎁 GiftOptionsView: SafariView appeared with URL: \(url)")
                        }
                        .onDisappear {
                            print("🎁 GiftOptionsView: SafariView disappeared")
                        }
                } else {
                    Text("Error: No URL to display")
                        .onAppear {
                            print("❌ GiftOptionsView: Error view appeared - no URL available")
                        }
                }
            }
        }
    }
    
    private var filteredGiftOptions: [GiftOption] {
        print("🎁 GiftOptionsView: filteredGiftOptions computed property called")
        print("🎁 GiftOptionsView: selectedCategory: \(selectedCategory)")
        
        let allOptions = GiftOption.allOptions
        print("🎁 GiftOptionsView: allOptions count: \(allOptions.count)")
        
        let filtered = allOptions.filter { $0.category == selectedCategory }
        
        print("🎁 GiftOptionsView: filtered count: \(filtered.count)")
        return filtered
    }
    
    private func openGiftOption(_ option: GiftOption) {
        print("🎁 GiftOptionsView: openGiftOption called for: \(option.title)")
        print("🎁 GiftOptionsView: Option details - category: \(option.category), type: \(option.type)")
        print("🎁 GiftOptionsView: Web URL: \(option.webURL)")
        print("🎁 GiftOptionsView: Gift card URL: \(option.giftCardURL)")
        
        // Go directly to Safari (no app deep linking)
        if let webURL = URL(string: option.giftCardURL) {
            print("🎁 GiftOptionsView: Opening web URL: \(webURL)")
            print("🎁 GiftOptionsView: Setting safariURL to: \(webURL)")
            safariURL = webURL
            print("🎁 GiftOptionsView: Setting showingSafari to true")
            showingSafari = true
            print("🎁 GiftOptionsView: Safari sheet should now be presented")
        } else {
            print("❌ GiftOptionsView: Failed to create URL from: \(option.giftCardURL)")
        }
    }
}

// MARK: - Supporting Views

struct CategoryButton: View {
    let category: GiftOption.GiftCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(size: 16, weight: .medium))
                Text(category.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(isSelected ? category.color : Color.gray.opacity(0.1))
                    .shadow(color: isSelected ? category.color.opacity(0.3) : Color.clear, radius: 4, x: 0, y: 2)
            )
            .foregroundColor(isSelected ? .white : .primary)
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct GiftOptionCard: View {
    let option: GiftOption
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                // Icon with background
                ZStack {
                    Circle()
                        .fill(option.color.opacity(0.15))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: option.icon)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(option.color)
                }
                
                // Content
                VStack(spacing: 8) {
                    Text(option.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    Text(option.subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                }
                
                // Removed action indicator arrow
            }
            .padding(20)
            .frame(height: 180)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(option.color.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(1.0)
        .animation(.easeInOut(duration: 0.1), value: true)
    }
}

// MARK: - Existing Supporting Views

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

#Preview {
    GiftOptionsView(birthdayEntry: BirthdayEntry.sampleData[0])
}
