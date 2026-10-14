import SwiftUI

struct AnimatableMacroDemo: View {
    private static let presets: [(amplitude: Double, frequency: Double)] = [
        (0.2, 1.5), (0.8, 2), (0.5, 4), (0.9, 6), (0.35, 3)
    ]

    @State private var presetIndex = 0
    @State private var sampleCount = 80

    private var preset: (amplitude: Double, frequency: Double) { Self.presets[presetIndex] }

    var body: some View {
        DemoPage(demo: .animatableMacro) {
            DemoSection(title: "Wave shape") {
                WaveShape(amplitude: preset.amplitude, frequency: preset.frequency, sampleCount: sampleCount)
                    .stroke(.tint, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                    .frame(height: 160)
                    .padding(.vertical, 8)
                    .animation(.smooth(duration: 0.8), value: presetIndex)

                Button("Next wave", systemImage: "waveform") {
                    presetIndex = (presetIndex + 1) % Self.presets.count
                }
                .buttonStyle(.glassProminent)

                LabeledContent("Amplitude", value: preset.amplitude, format: .number.precision(.fractionLength(2)))
                LabeledContent("Frequency", value: preset.frequency, format: .number.precision(.fractionLength(1)))
            }

            DemoSection(title: "Ignored property") {
                Stepper("Samples: \(sampleCount)", value: $sampleCount, in: 8...160, step: 8)
                Text("""
                    Amplitude and frequency animate because @Animatable builds the shape's animatableData \
                    from them. The sample count is marked @AnimatableIgnored, so it changes in one step.
                    """)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

/// A sine wave across the full width of its rectangle.
///
/// `@Animatable` synthesizes `animatableData` from `amplitude` and `frequency`.
@Animatable
struct WaveShape: Shape {
    /// Peak height as a fraction of half the rectangle's height, in `0...1`.
    var amplitude: Double
    /// Number of full periods across the width.
    var frequency: Double
    /// How many line segments approximate the curve.
    @AnimatableIgnored var sampleCount: Int

    func path(in rect: CGRect) -> Path {
        Path { path in
            let points = points(in: rect)
            guard let first = points.first else { return }
            path.move(to: first)
            for point in points.dropFirst() {
                path.addLine(to: point)
            }
        }
    }

    /// The points the path connects, from the left edge to the right edge.
    func points(in rect: CGRect) -> [CGPoint] {
        guard sampleCount > 0, rect.width > 0 else { return [] }
        let halfHeight = rect.height / 2
        return (0...sampleCount).map { index in
            let progress = Double(index) / Double(sampleCount)
            let angle = progress * frequency * 2 * .pi
            return CGPoint(
                x: rect.minX + progress * rect.width,
                y: rect.midY - sin(angle) * amplitude * halfHeight
            )
        }
    }
}

#Preview {
    NavigationStack { AnimatableMacroDemo() }
}
