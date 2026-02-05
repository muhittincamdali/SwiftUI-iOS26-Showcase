// MARK: - TabViewMinimizeDemo.swift
// iOS 26 TabView Minimize & Bottom Accessory
// Created by Muhittin Camdali

import SwiftUI

// MARK: - TabView Minimize Showcase

@available(iOS 26.0, macOS 26.0, *)
public struct TabViewMinimizeShowcase: View {
    @State private var selectedTab = 0
    @State private var minimizeBehavior: TabBarMinimizeBehavior = .onScrollDown
    
    public init() {}
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            Tab("Home", systemImage: "house.fill", value: 0) {
                HomeTabContent()
            }
            
            // Search Tab
            Tab("Search", systemImage: "magnifyingglass", value: 1) {
                SearchTabContent()
            }
            
            // Library Tab
            Tab("Library", systemImage: "square.stack.fill", value: 2) {
                LibraryTabContent()
            }
            
            // Settings Tab
            Tab("Settings", systemImage: "gearshape.fill", value: 3) {
                SettingsTabContent(minimizeBehavior: $minimizeBehavior)
            }
        }
        .tabBarMinimizeBehavior(minimizeBehavior)
        .tabViewBottomAccessory {
            NowPlayingAccessory()
        }
    }
}

// MARK: - TabBar Minimize Behavior

@available(iOS 26.0, *)
public enum TabBarMinimizeBehavior: String, CaseIterable, Identifiable {
    case automatic = "Automatic"
    case onScrollDown = "On Scroll Down"
    case onScrollUp = "On Scroll Up"
    case never = "Never"
    
    public var id: String { rawValue }
}

// MARK: - View Extensions for TabView

@available(iOS 26.0, *)
extension View {
    public func tabBarMinimizeBehavior(_ behavior: TabBarMinimizeBehavior) -> some View {
        self.environment(\.tabBarMinimizeBehavior, behavior)
    }
    
    public func tabViewBottomAccessory<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        self.safeAreaInset(edge: .bottom) {
            content()
        }
    }
}

// MARK: - Environment Key

@available(iOS 26.0, *)
private struct TabBarMinimizeBehaviorKey: EnvironmentKey {
    static let defaultValue: TabBarMinimizeBehavior = .automatic
}

@available(iOS 26.0, *)
extension EnvironmentValues {
    var tabBarMinimizeBehavior: TabBarMinimizeBehavior {
        get { self[TabBarMinimizeBehaviorKey.self] }
        set { self[TabBarMinimizeBehaviorKey.self] = newValue }
    }
}

// MARK: - Home Tab Content

@available(iOS 26.0, *)
struct HomeTabContent: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    // Featured Section
                    FeaturedCard(
                        title: "iOS 26 TabView",
                        subtitle: "Scroll to see minimize behavior",
                        gradient: [.blue, .purple]
                    )
                    
                    // Info Card
                    InfoBanner(
                        icon: "arrow.down.circle.fill",
                        text: "Scroll down to minimize the tab bar"
                    )
                    
                    // Content Grid
                    ForEach(0..<20) { index in
                        ContentCard(index: index)
                    }
                }
                .padding()
            }
            .navigationTitle("Home")
        }
    }
}

// MARK: - Search Tab Content

@available(iOS 26.0, *)
struct SearchTabContent: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    // Categories
                    Text("Categories")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ForEach(Category.samples) { category in
                            CategoryCard(category: category)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Search")
            .searchable(text: $searchText, prompt: "Search anything")
        }
    }
}

// MARK: - Library Tab Content

@available(iOS 26.0, *)
struct LibraryTabContent: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Recent") {
                    ForEach(0..<5) { index in
                        LibraryItem(title: "Item \(index + 1)", subtitle: "Recently added")
                    }
                }
                
                Section("Favorites") {
                    ForEach(5..<10) { index in
                        LibraryItem(title: "Favorite \(index - 4)", subtitle: "Added to favorites")
                    }
                }
                
                Section("All Items") {
                    ForEach(10..<30) { index in
                        LibraryItem(title: "Library Item \(index - 9)", subtitle: "In your library")
                    }
                }
            }
            .navigationTitle("Library")
        }
    }
}

// MARK: - Settings Tab Content

@available(iOS 26.0, *)
struct SettingsTabContent: View {
    @Binding var minimizeBehavior: TabBarMinimizeBehavior
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Tab Bar Behavior") {
                    Picker("Minimize Behavior", selection: $minimizeBehavior) {
                        ForEach(TabBarMinimizeBehavior.allCases) { behavior in
                            Text(behavior.rawValue).tag(behavior)
                        }
                    }
                    
                    Text("Controls when the tab bar minimizes during scrolling")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Section("Code Example") {
                    Text("""
                    TabView {
                        // Tabs...
                    }
                    .tabBarMinimizeBehavior(.onScrollDown)
                    .tabViewBottomAccessory {
                        NowPlayingView()
                    }
                    """)
                    .font(.system(.caption, design: .monospaced))
                }
                
                Section("Features") {
                    Label("Floating Tab Bar", systemImage: "dock.rectangle")
                    Label("Minimize on Scroll", systemImage: "arrow.down.to.line")
                    Label("Bottom Accessory", systemImage: "rectangle.bottomthird.inset.filled")
                    Label("Liquid Glass Effect", systemImage: "drop.fill")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

// MARK: - Now Playing Accessory

@available(iOS 26.0, *)
struct NowPlayingAccessory: View {
    @State private var isPlaying = false
    @Environment(\.tabViewBottomAccessoryPlacement) private var placement
    
    var body: some View {
        HStack(spacing: 12) {
            // Album Art
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    LinearGradient(
                        colors: [.purple, .pink],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: placement == .collapsed ? 32 : 48, height: placement == .collapsed ? 32 : 48)
                .overlay {
                    Image(systemName: "music.note")
                        .foregroundStyle(.white)
                }
            
            if placement != .collapsed {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Now Playing")
                        .font(.subheadline.bold())
                    Text("Artist Name")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // Controls
                HStack(spacing: 16) {
                    Button {
                        // Previous
                    } label: {
                        Image(systemName: "backward.fill")
                    }
                    
                    Button {
                        isPlaying.toggle()
                    } label: {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .font(.title3)
                    }
                    
                    Button {
                        // Next
                    } label: {
                        Image(systemName: "forward.fill")
                    }
                }
                .foregroundStyle(.primary)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}

// MARK: - TabView Bottom Accessory Placement

@available(iOS 26.0, *)
public enum TabViewBottomAccessoryPlacement {
    case expanded
    case collapsed
}

@available(iOS 26.0, *)
private struct TabViewBottomAccessoryPlacementKey: EnvironmentKey {
    static let defaultValue: TabViewBottomAccessoryPlacement = .expanded
}

@available(iOS 26.0, *)
extension EnvironmentValues {
    var tabViewBottomAccessoryPlacement: TabViewBottomAccessoryPlacement {
        get { self[TabViewBottomAccessoryPlacementKey.self] }
        set { self[TabViewBottomAccessoryPlacementKey.self] = newValue }
    }
}

// MARK: - Supporting Views

@available(iOS 26.0, *)
struct FeaturedCard: View {
    let title: String
    let subtitle: String
    let gradient: [Color]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title.bold())
            Text(subtitle)
                .font(.subheadline)
                .opacity(0.8)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(
            LinearGradient(colors: gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

@available(iOS 26.0, *)
struct InfoBanner: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.blue)
            
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.blue.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

@available(iOS 26.0, *)
struct ContentCard: View {
    let index: Int
    
    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hue: Double(index) / 20, saturation: 0.6, brightness: 0.9))
                .frame(width: 60, height: 60)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Content Item \(index + 1)")
                    .font(.headline)
                Text("Description for item \(index + 1)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

@available(iOS 26.0, *)
struct CategoryCard: View {
    let category: Category
    
    var body: some View {
        VStack {
            Image(systemName: category.icon)
                .font(.largeTitle)
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(category.color.gradient)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(alignment: .bottomLeading) {
            Text(category.name)
                .font(.headline)
                .foregroundStyle(.white)
                .padding(8)
        }
    }
}

struct Category: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    
    static let samples: [Category] = [
        Category(name: "Music", icon: "music.note", color: .pink),
        Category(name: "Movies", icon: "film", color: .purple),
        Category(name: "Books", icon: "book.fill", color: .orange),
        Category(name: "Games", icon: "gamecontroller.fill", color: .blue),
        Category(name: "Podcasts", icon: "mic.fill", color: .green),
        Category(name: "News", icon: "newspaper.fill", color: .red)
    ]
}

@available(iOS 26.0, *)
struct LibraryItem: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.blue.gradient)
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: "doc.fill")
                        .foregroundStyle(.white)
                }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - Code Example View

@available(iOS 26.0, *)
public struct TabViewMinimizeCodeExample: View {
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("TabView iOS 26 APIs")
                    .font(.title.bold())
                
                CodeBlock(
                    title: "Basic Minimize Behavior",
                    code: """
                    TabView {
                        Tab("Home", systemImage: "house") {
                            HomeView()
                        }
                        Tab("Search", systemImage: "magnifyingglass") {
                            SearchView()
                        }
                    }
                    .tabBarMinimizeBehavior(.onScrollDown)
                    """
                )
                
                CodeBlock(
                    title: "Bottom Accessory",
                    code: """
                    TabView { ... }
                    .tabViewBottomAccessory {
                        // This view appears above the tab bar
                        NowPlayingView()
                    }
                    """
                )
                
                CodeBlock(
                    title: "Accessory Placement",
                    code: """
                    struct NowPlayingView: View {
                        @Environment(\\.tabViewBottomAccessoryPlacement) 
                        private var placement
                        
                        var body: some View {
                            if placement == .collapsed {
                                CompactView()
                            } else {
                                ExpandedView()
                            }
                        }
                    }
                    """
                )
            }
            .padding()
        }
    }
}

@available(iOS 26.0, *)
struct CodeBlock: View {
    let title: String
    let code: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            
            Text(code)
                .font(.system(.caption, design: .monospaced))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

#Preview {
    if #available(iOS 26.0, *) {
        TabViewMinimizeShowcase()
    }
}
