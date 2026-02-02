import SwiftUI

// MARK: - Glass Effect Container Demo

/// Demonstrates container-based glass grouping where multiple elements
/// share a common glass background for cohesive visual design.
struct GlassEffectContainerDemo: View {

    // MARK: - Properties

    @State private var selectedStyle: ContainerStyle = .horizontal
    @State private var itemCount: Int = 4
    @State private var spacing: CGFloat = 12
    @State private var cornerRadius: CGFloat = 16
    @State private var isAnimating = false

    private let icons = [
        "star.fill", "heart.fill", "bolt.fill", "flame.fill",
        "leaf.fill", "drop.fill", "wind", "snowflake"
    ]

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                descriptionSection
                previewSection
                styleSelector
                parameterControls
                codeExample
            }
            .padding()
        }
        .navigationTitle("Effect Container")
        .background(backgroundView)
    }

    // MARK: - Description

    private var descriptionSection: some View {
        VStack(spacing: 8) {
            Text("Glass Effect Container")
                .font(.title2.bold())
            Text("Group multiple glass elements under a single container to share backgrounds and reduce visual complexity.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Preview

    private var previewSection: some View {
        VStack(spacing: spacing) {
            switch selectedStyle {
            case .horizontal:
                horizontalLayout
            case .vertical:
                verticalLayout
            case .grid:
                gridLayout
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius))
        .frame(minHeight: 200)
    }

    // MARK: - Layouts

    private var horizontalLayout: some View {
        HStack(spacing: spacing) {
            ForEach(0..<itemCount, id: \.self) { index in
                glassItem(icon: icons[index % icons.count], index: index)
            }
        }
    }

    private var verticalLayout: some View {
        VStack(spacing: spacing) {
            ForEach(0..<itemCount, id: \.self) { index in
                HStack {
                    Image(systemName: icons[index % icons.count])
                        .font(.title2)
                    Text("Item \(index + 1)")
                        .font(.headline)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    private var gridLayout: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: spacing),
            GridItem(.flexible(), spacing: spacing)
        ], spacing: spacing) {
            ForEach(0..<itemCount, id: \.self) { index in
                glassItem(icon: icons[index % icons.count], index: index)
                    .frame(height: 80)
            }
        }
    }

    // MARK: - Glass Item

    private func glassItem(icon: String, index: Int) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(
                    .spring(response: 0.5).delay(Double(index) * 0.1),
                    value: isAnimating
                )
            Text("\(index + 1)")
                .font(.caption.bold())
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .onTapGesture {
            isAnimating.toggle()
        }
    }

    // MARK: - Style Selector

    private var styleSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Container Layout")
                .font(.headline)
            Picker("Style", selection: $selectedStyle) {
                ForEach(ContainerStyle.allCases, id: \.self) { style in
                    Text(style.rawValue).tag(style)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    // MARK: - Parameter Controls

    private var parameterControls: some View {
        VStack(spacing: 12) {
            Text("Parameters")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                Text("Items: \(itemCount)")
                    .font(.caption)
                Slider(value: Binding(
                    get: { Double(itemCount) },
                    set: { itemCount = Int($0) }
                ), in: 2...8, step: 1)
            }

            HStack {
                Text("Spacing: \(Int(spacing))")
                    .font(.caption)
                Slider(value: $spacing, in: 4...32)
            }

            HStack {
                Text("Corner Radius: \(Int(cornerRadius))")
                    .font(.caption)
                Slider(value: $cornerRadius, in: 0...32)
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Code Example

    private var codeExample: some View {
        CodeSnippetView(
            code: """
            // Group glass elements in a container
            GlassEffectContainer {
                HStack(spacing: 12) {
                    ForEach(items) { item in
                        Image(systemName: item.icon)
                            .glassEffect()
                    }
                }
            }
            """,
            language: "swift"
        )
    }

    // MARK: - Background

    private var backgroundView: some View {
        LinearGradient(
            colors: [.indigo.opacity(0.4), .purple.opacity(0.3), .black],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

// MARK: - Container Style

enum ContainerStyle: String, CaseIterable {
    case horizontal = "Horizontal"
    case vertical = "Vertical"
    case grid = "Grid"
}
