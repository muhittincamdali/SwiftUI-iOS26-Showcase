// ObservationFrameworkDemo.swift
// SwiftUI-iOS26-Showcase
//
// Demonstrates the Observation framework in iOS 26
// Includes @Observable, @Bindable, and reactive state patterns

import SwiftUI
import Observation

// MARK: - Observable Models

/// A user profile model using @Observable
@Observable
final class UserProfile {
    var name: String
    var email: String
    var avatarColor: Color
    var isVerified: Bool
    var followerCount: Int
    var followingCount: Int
    var bio: String
    var joinDate: Date
    
    init(
        name: String = "Alex Johnson",
        email: String = "alex@example.com",
        avatarColor: Color = .blue,
        isVerified: Bool = true,
        followerCount: Int = 1234,
        followingCount: Int = 567,
        bio: String = "iOS Developer & SwiftUI Enthusiast",
        joinDate: Date = Date()
    ) {
        self.name = name
        self.email = email
        self.avatarColor = avatarColor
        self.isVerified = isVerified
        self.followerCount = followerCount
        self.followingCount = followingCount
        self.bio = bio
        self.joinDate = joinDate
    }
    
    var initials: String {
        let components = name.split(separator: " ")
        let initials = components.prefix(2).compactMap { $0.first }
        return String(initials)
    }
    
    var formattedJoinDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: joinDate)
    }
}

/// A settings model using @Observable
@Observable
final class AppSettings {
    var isDarkMode: Bool = true
    var notificationsEnabled: Bool = true
    var soundEnabled: Bool = true
    var hapticEnabled: Bool = true
    var fontSize: Double = 16
    var accentColorIndex: Int = 0
    var language: String = "English"
    var autoSave: Bool = true
    
    static let accentColors: [Color] = [.blue, .purple, .pink, .orange, .green, .red]
    static let languages = ["English", "Spanish", "French", "German", "Japanese", "Chinese"]
    
    var accentColor: Color {
        Self.accentColors[accentColorIndex % Self.accentColors.count]
    }
}

/// A shopping cart using @Observable
@Observable
final class ShoppingCart {
    var items: [CartItem] = []
    
    var totalItems: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
    
    var subtotal: Double {
        items.reduce(0) { $0 + $1.total }
    }
    
    var tax: Double {
        subtotal * 0.08
    }
    
    var total: Double {
        subtotal + tax
    }
    
    func addItem(_ item: CartItem) {
        if let index = items.firstIndex(where: { $0.name == item.name }) {
            items[index].quantity += 1
        } else {
            items.append(item)
        }
    }
    
    func removeItem(_ item: CartItem) {
        items.removeAll { $0.id == item.id }
    }
    
    func updateQuantity(for item: CartItem, quantity: Int) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            if quantity > 0 {
                items[index].quantity = quantity
            } else {
                items.remove(at: index)
            }
        }
    }
    
    func clearCart() {
        items.removeAll()
    }
}

struct CartItem: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    let icon: String
    var quantity: Int
    
    var total: Double {
        price * Double(quantity)
    }
    
    static let sampleItems: [CartItem] = [
        CartItem(name: "Wireless Earbuds", price: 149.99, icon: "airpodspro", quantity: 1),
        CartItem(name: "Smart Watch", price: 399.99, icon: "applewatch", quantity: 1),
        CartItem(name: "Laptop Stand", price: 79.99, icon: "desktopcomputer", quantity: 2),
        CartItem(name: "USB-C Cable", price: 19.99, icon: "cable.connector", quantity: 3),
        CartItem(name: "Power Adapter", price: 49.99, icon: "powerplug", quantity: 1)
    ]
}

// MARK: - Profile View

/// Profile editor using @Bindable
struct ProfileEditorView: View {
    @Bindable var profile: UserProfile
    @State private var isEditing = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Avatar
            ZStack {
                Circle()
                    .fill(profile.avatarColor.gradient)
                    .frame(width: 100, height: 100)
                
                Text(profile.initials)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(.white)
                
                if profile.isVerified {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.title2)
                        .foregroundStyle(.blue)
                        .background(Circle().fill(.white).padding(-2))
                        .offset(x: 35, y: 35)
                }
            }
            
            // Info display / edit
            if isEditing {
                editingView
            } else {
                displayView
            }
            
            // Stats
            HStack(spacing: 32) {
                StatView(value: profile.followerCount, label: "Followers")
                StatView(value: profile.followingCount, label: "Following")
            }
            
            // Edit button
            Button {
                withAnimation(.spring(response: 0.3)) {
                    isEditing.toggle()
                }
            } label: {
                HStack {
                    Image(systemName: isEditing ? "checkmark" : "pencil")
                    Text(isEditing ? "Done" : "Edit Profile")
                }
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(isEditing ? Color.green.opacity(0.3) : Color.blue.opacity(0.3))
                        )
                )
            }
        }
        .padding()
    }
    
    private var displayView: some View {
        VStack(spacing: 8) {
            Text(profile.name)
                .font(.title2.bold())
                .foregroundStyle(.white)
            
            Text(profile.email)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
            
            Text(profile.bio)
                .font(.body)
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.top, 4)
            
            Text("Joined \(profile.formattedJoinDate)")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.5))
                .padding(.top, 8)
        }
    }
    
    private var editingView: some View {
        VStack(spacing: 16) {
            ObservableTextField("Name", text: $profile.name, icon: "person")
            ObservableTextField("Email", text: $profile.email, icon: "envelope")
            ObservableTextField("Bio", text: $profile.bio, icon: "text.quote")
            
            // Color picker
            HStack {
                Text("Avatar Color")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
                
                Spacer()
                
                HStack(spacing: 8) {
                    ForEach([Color.blue, .purple, .pink, .orange, .green], id: \.self) { color in
                        Circle()
                            .fill(color)
                            .frame(width: 28, height: 28)
                            .overlay(
                                Circle()
                                    .strokeBorder(.white, lineWidth: profile.avatarColor == color ? 2 : 0)
                            )
                            .onTapGesture {
                                withAnimation {
                                    profile.avatarColor = color
                                }
                            }
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
            )
            
            // Verified toggle
            Toggle(isOn: $profile.isVerified) {
                HStack {
                    Image(systemName: "checkmark.seal")
                        .foregroundStyle(.blue)
                    Text("Verified Badge")
                        .foregroundStyle(.white)
                }
            }
            .tint(.blue)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
            )
        }
    }
}

struct ObservableTextField: View {
    let title: String
    @Binding var text: String
    let icon: String
    
    init(_ title: String, text: Binding<String>, icon: String) {
        self.title = title
        self._text = text
        self.icon = icon
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.white.opacity(0.5))
                .frame(width: 20)
            
            TextField(title, text: $text)
                .foregroundStyle(.white)
                .textFieldStyle(.plain)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

struct StatView: View {
    let value: Int
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.title2.bold())
                .foregroundStyle(.white)
            
            Text(label)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.6))
        }
    }
}

// MARK: - Settings View

/// Settings view using @Observable
struct SettingsObservableView: View {
    @Bindable var settings: AppSettings
    
    var body: some View {
        VStack(spacing: 16) {
            // Toggles section
            VStack(spacing: 12) {
                SettingsToggle(
                    title: "Dark Mode",
                    icon: "moon.fill",
                    isOn: $settings.isDarkMode
                )
                
                SettingsToggle(
                    title: "Notifications",
                    icon: "bell.fill",
                    isOn: $settings.notificationsEnabled
                )
                
                SettingsToggle(
                    title: "Sound",
                    icon: "speaker.wave.2.fill",
                    isOn: $settings.soundEnabled
                )
                
                SettingsToggle(
                    title: "Haptic Feedback",
                    icon: "hand.tap.fill",
                    isOn: $settings.hapticEnabled
                )
                
                SettingsToggle(
                    title: "Auto Save",
                    icon: "arrow.clockwise.icloud.fill",
                    isOn: $settings.autoSave
                )
            }
            
            Divider()
                .background(Color.white.opacity(0.1))
            
            // Font size slider
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "textformat.size")
                        .foregroundStyle(.white.opacity(0.7))
                    
                    Text("Font Size")
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Text("\(Int(settings.fontSize))pt")
                        .font(.subheadline.monospacedDigit())
                        .foregroundStyle(.white.opacity(0.7))
                }
                
                Slider(value: $settings.fontSize, in: 12...24, step: 1)
                    .tint(settings.accentColor)
                
                // Preview
                Text("Preview Text")
                    .font(.system(size: settings.fontSize))
                    .foregroundStyle(.white.opacity(0.8))
                    .frame(maxWidth: .infinity)
                    .padding(.top, 4)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(.ultraThinMaterial)
            )
            
            // Accent color picker
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "paintpalette.fill")
                        .foregroundStyle(.white.opacity(0.7))
                    
                    Text("Accent Color")
                        .foregroundStyle(.white)
                }
                
                HStack(spacing: 12) {
                    ForEach(0..<AppSettings.accentColors.count, id: \.self) { index in
                        Circle()
                            .fill(AppSettings.accentColors[index])
                            .frame(width: 36, height: 36)
                            .overlay(
                                Circle()
                                    .strokeBorder(.white, lineWidth: settings.accentColorIndex == index ? 3 : 0)
                            )
                            .scaleEffect(settings.accentColorIndex == index ? 1.1 : 1)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3)) {
                                    settings.accentColorIndex = index
                                }
                            }
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(.ultraThinMaterial)
            )
            
            // Language picker
            HStack {
                Image(systemName: "globe")
                    .foregroundStyle(.white.opacity(0.7))
                
                Text("Language")
                    .foregroundStyle(.white)
                
                Spacer()
                
                Picker("", selection: $settings.language) {
                    ForEach(AppSettings.languages, id: \.self) { lang in
                        Text(lang).tag(lang)
                    }
                }
                .tint(.white)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(.ultraThinMaterial)
            )
        }
        .padding()
    }
}

struct SettingsToggle: View {
    let title: String
    let icon: String
    @Binding var isOn: Bool
    
    var body: some View {
        Toggle(isOn: $isOn) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(isOn ? .blue : .white.opacity(0.5))
                    .frame(width: 24)
                
                Text(title)
                    .foregroundStyle(.white)
            }
        }
        .tint(.blue)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

// MARK: - Shopping Cart View

/// Shopping cart using @Observable
struct ShoppingCartView: View {
    @Bindable var cart: ShoppingCart
    
    var body: some View {
        VStack(spacing: 16) {
            if cart.items.isEmpty {
                emptyCartView
            } else {
                cartItemsList
                cartSummary
                checkoutButton
            }
        }
        .padding()
    }
    
    private var emptyCartView: some View {
        VStack(spacing: 16) {
            Image(systemName: "cart")
                .font(.system(size: 64))
                .foregroundStyle(.white.opacity(0.3))
            
            Text("Your cart is empty")
                .font(.headline)
                .foregroundStyle(.white.opacity(0.6))
            
            Button("Add Sample Items") {
                withAnimation {
                    for item in CartItem.sampleItems.prefix(3) {
                        cart.addItem(item)
                    }
                }
            }
            .font(.subheadline.bold())
            .foregroundStyle(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(Color.blue.opacity(0.4))
            )
        }
        .frame(maxHeight: .infinity)
    }
    
    private var cartItemsList: some View {
        VStack(spacing: 12) {
            ForEach(cart.items) { item in
                CartItemRow(item: item) { newQuantity in
                    withAnimation {
                        cart.updateQuantity(for: item, quantity: newQuantity)
                    }
                } onRemove: {
                    withAnimation {
                        cart.removeItem(item)
                    }
                }
            }
        }
    }
    
    private var cartSummary: some View {
        VStack(spacing: 12) {
            Divider()
                .background(Color.white.opacity(0.1))
            
            HStack {
                Text("Subtotal")
                    .foregroundStyle(.white.opacity(0.7))
                Spacer()
                Text("$\(cart.subtotal, specifier: "%.2f")")
                    .foregroundStyle(.white)
            }
            
            HStack {
                Text("Tax (8%)")
                    .foregroundStyle(.white.opacity(0.7))
                Spacer()
                Text("$\(cart.tax, specifier: "%.2f")")
                    .foregroundStyle(.white)
            }
            
            Divider()
                .background(Color.white.opacity(0.1))
            
            HStack {
                Text("Total")
                    .font(.headline)
                    .foregroundStyle(.white)
                Spacer()
                Text("$\(cart.total, specifier: "%.2f")")
                    .font(.title2.bold())
                    .foregroundStyle(.green)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
    
    private var checkoutButton: some View {
        HStack {
            Button {
                withAnimation {
                    cart.clearCart()
                }
            } label: {
                Text("Clear")
                    .font(.headline)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(.ultraThinMaterial)
                    )
            }
            
            Button {
                // Checkout action
            } label: {
                HStack {
                    Image(systemName: "creditcard")
                    Text("Checkout (\(cart.totalItems))")
                }
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.green.opacity(0.5))
                )
            }
        }
    }
}

struct CartItemRow: View {
    let item: CartItem
    let onQuantityChange: (Int) -> Void
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: item.icon)
                    .font(.title3)
                    .foregroundStyle(.blue)
            }
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                
                Text("$\(item.price, specifier: "%.2f")")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.6))
            }
            
            Spacer()
            
            // Quantity controls
            HStack(spacing: 8) {
                Button {
                    onQuantityChange(item.quantity - 1)
                } label: {
                    Image(systemName: "minus")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .frame(width: 28, height: 28)
                        .background(Circle().fill(Color.white.opacity(0.1)))
                }
                
                Text("\(item.quantity)")
                    .font(.subheadline.monospacedDigit().bold())
                    .foregroundStyle(.white)
                    .frame(width: 24)
                
                Button {
                    onQuantityChange(item.quantity + 1)
                } label: {
                    Image(systemName: "plus")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .frame(width: 28, height: 28)
                        .background(Circle().fill(Color.white.opacity(0.1)))
                }
            }
            
            // Remove
            Button {
                onRemove()
            } label: {
                Image(systemName: "trash")
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.ultraThinMaterial)
        )
    }
}

// MARK: - Main Demo View

/// Comprehensive Observation framework demonstration
public struct ObservationFrameworkDemo: View {
    @State private var profile = UserProfile()
    @State private var settings = AppSettings()
    @State private var cart = ShoppingCart()
    @State private var selectedTab = 0
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text("Observation Framework")
                    .font(.title.bold())
                    .foregroundStyle(.white)
                
                Text("SwiftUI's modern state management with @Observable and @Bindable")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            // Tab selector
            HStack(spacing: 0) {
                ObservationTabButton(title: "Profile", icon: "person", index: 0, selected: $selectedTab)
                ObservationTabButton(title: "Settings", icon: "gear", index: 1, selected: $selectedTab)
                ObservationTabButton(title: "Cart", icon: "cart", index: 2, selected: $selectedTab)
            }
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
            )
            .padding(.horizontal)
            
            // Content
            TabView(selection: $selectedTab) {
                ScrollView {
                    ProfileEditorView(profile: profile)
                }
                .tag(0)
                
                ScrollView {
                    SettingsObservableView(settings: settings)
                }
                .tag(1)
                
                ScrollView {
                    ShoppingCartView(cart: cart)
                }
                .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .background(backgroundGradient)
        .navigationTitle("Observation")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 0.1, green: 0.12, blue: 0.18),
                Color(red: 0.12, green: 0.1, blue: 0.22)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

struct ObservationTabButton: View {
    let title: String
    let icon: String
    let index: Int
    @Binding var selected: Int
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3)) {
                selected = index
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                
                Text(title)
                    .font(.subheadline.bold())
            }
            .foregroundStyle(selected == index ? .white : .white.opacity(0.5))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(selected == index ? Color.blue.opacity(0.4) : Color.clear)
            )
        }
    }
}

// MARK: - Preview

#Preview("Observation Framework Demo") {
    NavigationStack {
        ObservationFrameworkDemo()
    }
}
