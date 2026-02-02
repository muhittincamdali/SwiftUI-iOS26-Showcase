import SwiftUI

// MARK: - Content View

/// Root content view with tab-based navigation across all demo categories.
struct ContentView: View {

    // MARK: - Properties

    @Binding var selectedTab: AppTab
    @State private var showingAbout = false

    // MARK: - Body

    var body: some View {
        TabView(selection: $selectedTab) {
            glassTab
            swiftUITab
            intelligenceTab
            swift62Tab
            platformTab
        }
        .sheet(isPresented: $showingAbout) {
            aboutSheet
        }
    }

    // MARK: - Glass Tab

    private var glassTab: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    DemoCard(title: "Basic Glass", subtitle: "Core glass effect modifier", systemImage: "sparkles", gradient: .blue) {
                        GlassBasicDemo()
                    }
                    DemoCard(title: "Effect Container", subtitle: "Grouped glass elements", systemImage: "square.on.square", gradient: .purple) {
                        GlassEffectContainerDemo()
                    }
                    DemoCard(title: "Glass Navigation", subtitle: "Translucent navigation bars", systemImage: "sidebar.left", gradient: .cyan) {
                        GlassNavigationDemo()
                    }
                    DemoCard(title: "Glass Tab Bar", subtitle: "Frosted tab bar styling", systemImage: "dock.rectangle", gradient: .mint) {
                        GlassTabBarDemo()
                    }
                    DemoCard(title: "Glass Cards", subtitle: "Card components with glass", systemImage: "rectangle.portrait", gradient: .indigo) {
                        GlassCardDemo()
                    }
                }
                .padding()
            }
            .navigationTitle("🧊 Liquid Glass")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showingAbout = true } label: {
                        Image(systemName: "info.circle")
                    }
                }
            }
        }
        .tabItem { Label(AppTab.glass.rawValue, systemImage: AppTab.glass.systemImage) }
        .tag(AppTab.glass)
    }

    // MARK: - SwiftUI Tab

    private var swiftUITab: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    NavigationLink("Mesh Gradient") { MeshGradientDemo() }
                    NavigationLink("Scroll View") { ScrollViewDemo() }
                    NavigationLink("Animation") { AnimationDemo() }
                    NavigationLink("Navigation") { NavigationDemo() }
                }
                .padding()
            }
            .navigationTitle("🎨 SwiftUI")
        }
        .tabItem { Label(AppTab.swiftUI.rawValue, systemImage: AppTab.swiftUI.systemImage) }
        .tag(AppTab.swiftUI)
    }

    // MARK: - Intelligence Tab

    private var intelligenceTab: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    NavigationLink("Foundation Models") { FoundationModelsDemo() }
                    NavigationLink("Text Generation") { TextGenerationDemo() }
                }
                .padding()
            }
            .navigationTitle("🤖 Intelligence")
        }
        .tabItem { Label(AppTab.intelligence.rawValue, systemImage: AppTab.intelligence.systemImage) }
        .tag(AppTab.intelligence)
    }

    // MARK: - Swift 6.2 Tab

    private var swift62Tab: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    NavigationLink("Concurrency") { ConcurrencyDemo() }
                    NavigationLink("Typed Throws") { TypedThrowsDemo() }
                }
                .padding()
            }
            .navigationTitle("⚡ Swift 6.2")
        }
        .tabItem { Label(AppTab.swift62.rawValue, systemImage: AppTab.swift62.systemImage) }
        .tag(AppTab.swift62)
    }

    // MARK: - Platform Tab

    private var platformTab: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    NavigationLink("visionOS") { VisionOSDemo() }
                }
                .padding()
            }
            .navigationTitle("🥽 Platform")
        }
        .tabItem { Label(AppTab.platform.rawValue, systemImage: AppTab.platform.systemImage) }
        .tag(AppTab.platform)
    }

    // MARK: - About Sheet

    private var aboutSheet: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "cube.transparent.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.blue.gradient)
                Text("SwiftUI iOS 26 Showcase")
                    .font(.title.bold())
                Text("50+ interactive demos covering Liquid Glass, SwiftUI enhancements, Foundation Models, and Swift 6.2 features.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .padding()
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { showingAbout = false }
                }
            }
        }
    }
}
