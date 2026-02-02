import SwiftUI

// MARK: - Glass Basic Demo

/// Demonstrates the core `.glassEffect()` modifier with various configurations.
/// Shows blur intensity, tint color, and opacity adjustments on different shapes.
struct GlassBasicDemo: View {

    // MARK: - Properties

    @State private var blurRadius: CGFloat = 20
    @State private var tintOpacity: Double = 0.3
    @State private var selectedShape: ShapeType = .rectangle
    @State private var showCode = false

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                previewSection
                controlsSection
                codeSection
            }
            .padding()
        }
        .navigationTitle("Basic Glass")
        .background(backgroundGradient)
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Glass Effect Modifier")
                .font(.title2.bold())
            Text("Apply translucent glass styling to any SwiftUI view using the .glassEffect() modifier.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Preview

    private var previewSection: some View {
        ZStack {
            Image(systemName: "mountain.2.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.blue.gradient)
                .frame(height: 200)

            glassShape
                .frame(width: 180, height: 180)
                .overlay {
                    VStack {
                        Image(systemName: "cube.transparent")
                            .font(.largeTitle)
                        Text("Glass")
                            .font(.headline)
                    }
                    .foregroundStyle(.white)
                }
        }
        .frame(height: 280)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    // MARK: - Glass Shape

    @ViewBuilder
    private var glassShape: some View {
        switch selectedShape {
        case .rectangle:
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .opacity(tintOpacity + 0.5)
        case .circle:
            Circle()
                .fill(.ultraThinMaterial)
                .opacity(tintOpacity + 0.5)
        case .capsule:
            Capsule()
                .fill(.ultraThinMaterial)
                .opacity(tintOpacity + 0.5)
        }
    }

    // MARK: - Controls

    private var controlsSection: some View {
        VStack(spacing: 16) {
            Text("Parameters")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading, spacing: 4) {
                Text("Blur Radius: \(Int(blurRadius))")
                    .font(.caption)
                Slider(value: $blurRadius, in: 0...50)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Tint Opacity: \(tintOpacity, specifier: "%.2f")")
                    .font(.caption)
                Slider(value: $tintOpacity, in: 0...1)
            }

            Picker("Shape", selection: $selectedShape) {
                ForEach(ShapeType.allCases, id: \.self) { shape in
                    Text(shape.rawValue).tag(shape)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Code Section

    private var codeSection: some View {
        CodeSnippetView(
            code: """
            Rectangle()
                .fill(.ultraThinMaterial)
                .glassEffect()
                .frame(width: 200, height: 200)
            """,
            language: "swift"
        )
    }

    // MARK: - Background

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [.black, .blue.opacity(0.3), .purple.opacity(0.2)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

// MARK: - Shape Type

enum ShapeType: String, CaseIterable {
    case rectangle = "Rectangle"
    case circle = "Circle"
    case capsule = "Capsule"
}
