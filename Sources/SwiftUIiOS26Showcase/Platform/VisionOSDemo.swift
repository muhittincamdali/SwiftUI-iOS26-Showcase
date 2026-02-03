import SwiftUI

// MARK: - VisionOS Demo

/// Demonstrates visionOS-specific features including volumetric content,
/// immersive spaces, and spatial interaction patterns.
struct VisionOSDemo: View {

    // MARK: - Properties

    @State private var selectedFeature: VisionFeature = .volumes
    @State private var depthOffset: CGFloat = 0
    @State private var showImmersive = false
    @State private var objectScale: CGFloat = 1.0

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                featureSelector
                previewSection
                controlsSection
                capabilitiesSection
                codeSection
            }
            .padding()
        }
        .navigationTitle("visionOS")
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "visionpro")
                .font(.system(size: 40))
                .foregroundStyle(.blue.gradient)
            Text("Spatial Computing")
                .font(.title2.bold())
            Text("Build immersive experiences with volumetric content, ornaments, and spatial audio for Apple Vision Pro.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Feature Selector

    private var featureSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Feature")
                .font(.headline)
            Picker("Feature", selection: $selectedFeature) {
                ForEach(VisionFeature.allCases, id: \.self) { feature in
                    Text(feature.rawValue).tag(feature)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    // MARK: - Preview

    private var previewSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.black)
                .frame(height: 250)

            VStack(spacing: 16) {
                Image(systemName: selectedFeature.icon)
                    .font(.system(size: 60))
                    .foregroundStyle(.white.opacity(0.8))
                    .scaleEffect(objectScale)
                    .offset(y: depthOffset)
                    .animation(.spring(response: 0.4), value: objectScale)

                Text(selectedFeature.description)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
            }

            // Simulated depth grid
            ForEach(0..<5, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2)
                    .stroke(.white.opacity(0.05), lineWidth: 1)
                    .frame(width: 280 - CGFloat(index) * 30, height: 200 - CGFloat(index) * 20)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    // MARK: - Controls

    private var controlsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Spatial Controls")
                .font(.headline)

            VStack(alignment: .leading, spacing: 4) {
                Text("Depth: \(Int(depthOffset))")
                    .font(.caption)
                Slider(value: $depthOffset, in: -50...50)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Scale: \(objectScale, specifier: "%.1f")x")
                    .font(.caption)
                Slider(value: $objectScale, in: 0.5...2.0)
            }

            Toggle("Immersive Mode", isOn: $showImmersive)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Capabilities

    private var capabilitiesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Platform Capabilities")
                .font(.headline)

            ForEach(capabilities, id: \.title) { cap in
                HStack(spacing: 12) {
                    Image(systemName: cap.icon)
                        .font(.title3)
                        .foregroundStyle(cap.color)
                        .frame(width: 28)
                    VStack(alignment: .leading) {
                        Text(cap.title)
                            .font(.subheadline.bold())
                        Text(cap.detail)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private var capabilities: [PlatformCapability] {
        [
            PlatformCapability(icon: "cube.fill", title: "Volumes", detail: "3D content in bounded spaces", color: .blue),
            PlatformCapability(icon: "mountain.2.fill", title: "Immersive Spaces", detail: "Full spatial experiences", color: .green),
            PlatformCapability(icon: "hand.point.up.fill", title: "Gestures", detail: "Tap, pinch, and gaze input", color: .purple),
            PlatformCapability(icon: "speaker.wave.3.fill", title: "Spatial Audio", detail: "3D positioned sound", color: .orange)
        ]
    }

    // MARK: - Code

    private var codeSection: some View {
        CodeSnippetView(
            code: """
            @main
            struct MyApp: App {
                var body: some Scene {
                    WindowGroup {
                        ContentView()
                    }
                    .windowStyle(.volumetric)

                    ImmersiveSpace(id: "immersive") {
                        ImmersiveView()
                    }
                }
            }
            """,
            language: "swift"
        )
    }
}

// MARK: - Supporting Types

enum VisionFeature: String, CaseIterable {
    case volumes = "Volumes"
    case immersive = "Immersive"
    case ornaments = "Ornaments"

    var icon: String {
        switch self {
        case .volumes: return "cube.fill"
        case .immersive: return "mountain.2.fill"
        case .ornaments: return "tag.fill"
        }
    }

    var description: String {
        switch self {
        case .volumes: return "Bounded 3D content within a defined volume"
        case .immersive: return "Full immersive space surrounding the user"
        case .ornaments: return "Floating UI elements attached to windows"
        }
    }
}

struct PlatformCapability {
    let icon: String
    let title: String
    let detail: String
    let color: Color
}
