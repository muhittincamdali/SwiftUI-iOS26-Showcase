import SwiftUI

// MARK: - Glass Navigation Demo

/// Showcases navigation bars with glass material styling,
/// demonstrating toolbar glass effects and translucent headers.
struct GlassNavigationDemo: View {

    // MARK: - Properties

    @State private var items = (1...20).map { "Item \($0)" }
    @State private var searchText = ""
    @State private var showLargeTitle = true
    @State private var glassIntensity: Double = 0.8
    @State private var selectedItem: String?

    private var filteredItems: [String] {
        if searchText.isEmpty {
            return items
        }
        return items.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                infoSection
                navigationPreview
                settingsSection
                codeSection
            }
            .padding()
        }
        .navigationTitle("Glass Navigation")
        .background(backgroundGradient)
    }

    // MARK: - Info

    private var infoSection: some View {
        VStack(spacing: 8) {
            Text("Navigation Bar Glass")
                .font(.title2.bold())
            Text("Apply glass material to navigation bars and toolbars for a modern translucent appearance that blends with content beneath.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Navigation Preview

    private var navigationPreview: some View {
        VStack(spacing: 0) {
            // Simulated nav bar
            HStack {
                Image(systemName: "chevron.left")
                    .font(.body.bold())
                Spacer()
                Text("Glass Nav Bar")
                    .font(.headline)
                Spacer()
                Image(systemName: "ellipsis.circle")
            }
            .padding()
            .background(.ultraThinMaterial)

            // Content list
            VStack(spacing: 1) {
                ForEach(filteredItems.prefix(8), id: \.self) { item in
                    HStack {
                        Circle()
                            .fill(.blue.gradient)
                            .frame(width: 32, height: 32)
                            .overlay {
                                Text(String(item.last ?? "?"))
                                    .font(.caption.bold())
                                    .foregroundStyle(.white)
                            }
                        Text(item)
                            .font(.body)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(selectedItem == item ? Color.blue.opacity(0.1) : .clear)
                    .onTapGesture { selectedItem = item }
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.white.opacity(0.1), lineWidth: 1)
        )
    }

    // MARK: - Settings

    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Configuration")
                .font(.headline)

            Toggle("Large Title", isOn: $showLargeTitle)

            VStack(alignment: .leading, spacing: 4) {
                Text("Glass Intensity: \(glassIntensity, specifier: "%.1f")")
                    .font(.caption)
                Slider(value: $glassIntensity, in: 0...1)
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Code

    private var codeSection: some View {
        CodeSnippetView(
            code: """
            NavigationStack {
                List { ... }
                    .navigationTitle("Glass Nav")
                    .toolbarBackgroundVisibility(
                        .visible, for: .navigationBar
                    )
            }
            """,
            language: "swift"
        )
    }

    // MARK: - Background

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [.black, .cyan.opacity(0.2), .blue.opacity(0.15)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
