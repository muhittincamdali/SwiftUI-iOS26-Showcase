import SwiftUI

// MARK: - Glass Tab Bar Demo

/// Demonstrates tab bars rendered with translucent glass effects,
/// showing how to create modern bottom navigation with glass materials.
struct GlassTabBarDemo: View {

    // MARK: - Properties

    @State private var selectedTab = 0
    @State private var showBadge = true
    @State private var tabStyle: TabBarStyle = .standard

    private let tabs: [(String, String, Color)] = [
        ("house.fill", "Home", .blue),
        ("magnifyingglass", "Search", .purple),
        ("plus.circle.fill", "Create", .green),
        ("bell.fill", "Alerts", .orange),
        ("person.fill", "Profile", .pink)
    ]

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                descriptionSection
                tabBarPreview
                styleControls
                codeSnippet
            }
            .padding()
        }
        .navigationTitle("Glass Tab Bar")
        .background(backgroundGradient)
    }

    // MARK: - Description

    private var descriptionSection: some View {
        VStack(spacing: 8) {
            Text("Translucent Tab Bars")
                .font(.title2.bold())
            Text("Create tab bars with frosted glass appearance that blend seamlessly with the content below.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Tab Bar Preview

    private var tabBarPreview: some View {
        VStack(spacing: 0) {
            // Content area
            RoundedRectangle(cornerRadius: 0)
                .fill(.blue.opacity(0.1))
                .frame(height: 200)
                .overlay {
                    VStack {
                        Image(systemName: tabs[selectedTab].0)
                            .font(.system(size: 40))
                            .foregroundStyle(tabs[selectedTab].2)
                        Text(tabs[selectedTab].1)
                            .font(.title3.bold())
                    }
                }

            // Glass tab bar
            HStack {
                ForEach(0..<tabs.count, id: \.self) { index in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            selectedTab = index
                        }
                    } label: {
                        VStack(spacing: 4) {
                            ZStack(alignment: .topTrailing) {
                                Image(systemName: tabs[index].0)
                                    .font(.title3)
                                if showBadge && index == 3 {
                                    Circle()
                                        .fill(.red)
                                        .frame(width: 8, height: 8)
                                        .offset(x: 4, y: -4)
                                }
                            }
                            Text(tabs[index].1)
                                .font(.caption2)
                        }
                        .foregroundStyle(selectedTab == index ? tabs[index].2 : .secondary)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.vertical, 10)
            .background(.ultraThinMaterial)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.white.opacity(0.15), lineWidth: 1)
        )
    }

    // MARK: - Style Controls

    private var styleControls: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Options")
                .font(.headline)
            Toggle("Show Badge", isOn: $showBadge)
            Picker("Style", selection: $tabStyle) {
                ForEach(TabBarStyle.allCases, id: \.self) { style in
                    Text(style.rawValue).tag(style)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Code

    private var codeSnippet: some View {
        CodeSnippetView(
            code: """
            TabView {
                HomeView()
                    .tabItem { Label("Home", systemImage: "house") }
            }
            .tabBarGlassEffect(.prominent)
            """,
            language: "swift"
        )
    }

    // MARK: - Background

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [.black, .mint.opacity(0.2)],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

// MARK: - Tab Bar Style

enum TabBarStyle: String, CaseIterable {
    case standard = "Standard"
    case compact = "Compact"
    case floating = "Floating"
}
