import SwiftUI

// MARK: - Mesh Gradient Demo

/// Interactive demo of 2D mesh gradients with draggable control points.
/// Shows how MeshGradient creates complex color blends across a grid.
struct MeshGradientDemo: View {

    // MARK: - Properties

    @State private var gridWidth = 3
    @State private var gridHeight = 3
    @State private var isAnimating = false
    @State private var colorScheme: GradientColorScheme = .sunset

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                gradientPreview
                colorSchemeSelector
                parameterSection
                codeSection
            }
            .padding()
        }
        .navigationTitle("Mesh Gradient")
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("2D Mesh Gradients")
                .font(.title2.bold())
            Text("Create rich, multi-point color gradients with a mesh grid. Each point can have its own color and position.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Gradient Preview

    private var gradientPreview: some View {
        meshGradientView
            .frame(height: 300)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            )
            .onTapGesture {
                withAnimation(.easeInOut(duration: 2.0)) {
                    isAnimating.toggle()
                }
            }
    }

    // MARK: - Mesh View

    @ViewBuilder
    private var meshGradientView: some View {
        let colors = colorScheme.colors
        Canvas { context, size in
            let cellWidth = size.width / CGFloat(gridWidth - 1)
            let cellHeight = size.height / CGFloat(gridHeight - 1)

            for row in 0..<gridHeight {
                for col in 0..<gridWidth {
                    let index = row * gridWidth + col
                    let color = colors[index % colors.count]
                    let rect = CGRect(
                        x: CGFloat(col) * cellWidth - cellWidth / 2,
                        y: CGFloat(row) * cellHeight - cellHeight / 2,
                        width: cellWidth * 1.5,
                        height: cellHeight * 1.5
                    )
                    context.fill(
                        Path(ellipseIn: rect),
                        with: .color(color.opacity(0.6))
                    )
                }
            }
        }
    }

    // MARK: - Color Scheme Selector

    private var colorSchemeSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Color Scheme")
                .font(.headline)
            Picker("Scheme", selection: $colorScheme) {
                ForEach(GradientColorScheme.allCases, id: \.self) { scheme in
                    Text(scheme.rawValue).tag(scheme)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    // MARK: - Parameters

    private var parameterSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Grid Size")
                .font(.headline)

            Stepper("Width: \(gridWidth)", value: $gridWidth, in: 2...5)
            Stepper("Height: \(gridHeight)", value: $gridHeight, in: 2...5)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Code

    private var codeSection: some View {
        CodeSnippetView(
            code: """
            MeshGradient(
                width: 3, height: 3,
                points: [
                    [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                    [0.0, 0.5], [0.5, 0.5], [1.0, 0.5],
                    [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
                ],
                colors: [
                    .red, .orange, .yellow,
                    .green, .blue, .purple,
                    .pink, .mint, .cyan
                ]
            )
            """,
            language: "swift"
        )
    }
}

// MARK: - Gradient Color Scheme

enum GradientColorScheme: String, CaseIterable {
    case sunset = "Sunset"
    case ocean = "Ocean"
    case forest = "Forest"
    case neon = "Neon"

    var colors: [Color] {
        switch self {
        case .sunset: return [.red, .orange, .yellow, .pink, .orange, .red, .purple, .pink, .orange]
        case .ocean: return [.blue, .cyan, .teal, .mint, .blue, .indigo, .cyan, .teal, .blue]
        case .forest: return [.green, .mint, .teal, .brown, .green, .yellow, .teal, .green, .mint]
        case .neon: return [.pink, .purple, .blue, .cyan, .green, .yellow, .orange, .red, .pink]
        }
    }
}
