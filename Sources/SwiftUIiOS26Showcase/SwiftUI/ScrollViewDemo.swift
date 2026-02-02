import SwiftUI

// MARK: - Scroll View Demo

/// Demonstrates new ScrollView features: position tracking,
/// paging behavior, scroll transitions, and content margins.
struct ScrollViewDemo: View {

    // MARK: - Properties

    @State private var scrollPosition: Int?
    @State private var isPagingEnabled = true
    @State private var showIndicators = true
    @State private var selectedMode: ScrollDemoMode = .paging

    private let items = (0..<20).map { index in
        ScrollDemoItem(
            id: index,
            title: "Card \(index + 1)",
            color: [Color.blue, .purple, .pink, .orange, .green, .cyan, .indigo, .mint][index % 8]
        )
    }

    // MARK: - Body

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 24) {
                headerSection
                scrollPreview
                positionIndicator
                modeSelector
                settingsSection
                codeSection
            }
            .padding()
        }
        .navigationTitle("Scroll View")
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Enhanced ScrollView")
                .font(.title2.bold())
            Text("iOS 26 brings position tracking, paging, and custom scroll transitions to ScrollView.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Scroll Preview

    private var scrollPreview: some View {
        ScrollView(.horizontal, showsIndicators: showIndicators) {
            LazyHStack(spacing: 16) {
                ForEach(items) { item in
                    RoundedRectangle(cornerRadius: 20)
                        .fill(item.color.gradient)
                        .frame(width: isPagingEnabled ? 300 : 200, height: 200)
                        .overlay {
                            VStack {
                                Text(item.title)
                                    .font(.title3.bold())
                                Text("Swipe to explore")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .foregroundStyle(.white)
                        }
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0.6)
                                .scaleEffect(phase.isIdentity ? 1 : 0.85)
                        }
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 220)
    }

    // MARK: - Position Indicator

    private var positionIndicator: some View {
        HStack {
            Text("Scroll Position:")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(scrollPosition.map { "Card \($0 + 1)" } ?? "Unknown")
                .font(.caption.bold())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: Capsule())
    }

    // MARK: - Mode Selector

    private var modeSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Demo Mode")
                .font(.headline)
            Picker("Mode", selection: $selectedMode) {
                ForEach(ScrollDemoMode.allCases, id: \.self) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    // MARK: - Settings

    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Options")
                .font(.headline)
            Toggle("Paging", isOn: $isPagingEnabled)
            Toggle("Show Indicators", isOn: $showIndicators)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Code

    private var codeSection: some View {
        CodeSnippetView(
            code: """
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(items) { item in
                        CardView(item: item)
                            .scrollTransition { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1 : 0.6)
                                    .scaleEffect(phase.isIdentity ? 1 : 0.85)
                            }
                    }
                }
            }
            .scrollTargetBehavior(.paging)
            """,
            language: "swift"
        )
    }
}

// MARK: - Supporting Types

struct ScrollDemoItem: Identifiable {
    let id: Int
    let title: String
    let color: Color
}

enum ScrollDemoMode: String, CaseIterable {
    case paging = "Paging"
    case freeScroll = "Free"
    case snapping = "Snapping"
}
