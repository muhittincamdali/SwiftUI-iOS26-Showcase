import SwiftUI

struct GlassEffectDemo: View {
    enum Variant: String, CaseIterable, Identifiable {
        case regular, clear, identity
        var id: Self { self }

        var glass: Glass {
            switch self {
            case .regular: .regular
            case .clear: .clear
            case .identity: .identity
            }
        }
    }

    enum Tint: String, CaseIterable, Identifiable {
        case none, blue, orange, green
        var id: Self { self }

        var color: Color? {
            switch self {
            case .none: nil
            case .blue: .blue
            case .orange: .orange
            case .green: .green
            }
        }
    }

    enum ShapeOption: String, CaseIterable, Identifiable {
        case capsule, rounded, circle
        var id: Self { self }

        var shape: AnyShape {
            switch self {
            case .capsule: AnyShape(.capsule)
            case .rounded: AnyShape(.rect(cornerRadius: 20))
            case .circle: AnyShape(.circle)
            }
        }
    }

    @State private var variant: Variant = .regular
    @State private var tint: Tint = .none
    @State private var shape: ShapeOption = .capsule
    @State private var isInteractive = true

    private var configuredGlass: Glass {
        variant.glass
            .tint(tint.color)
            .interactive(isInteractive)
    }

    var body: some View {
        DemoPage(demo: .glassEffect) {
            preview
            DemoSection(title: "Configuration") {
                Picker("Variant", selection: $variant) {
                    ForEach(Variant.allCases) { Text($0.rawValue.capitalized).tag($0) }
                }
                .pickerStyle(.segmented)

                Picker("Shape", selection: $shape) {
                    ForEach(ShapeOption.allCases) { Text($0.rawValue.capitalized).tag($0) }
                }
                .pickerStyle(.segmented)

                Picker("Tint", selection: $tint) {
                    ForEach(Tint.allCases) { Text($0.rawValue.capitalized).tag($0) }
                }
                .pickerStyle(.segmented)

                Toggle("Interactive (reacts to touch)", isOn: $isInteractive)
            }
        }
    }

    private var preview: some View {
        ShowcaseBackdrop()
            .frame(height: 260)
            .overlay {
                Label("Liquid Glass", systemImage: "drop.fill")
                    .font(.title2.bold())
                    .padding(shape == .circle ? 44 : 24)
                    .glassEffect(configuredGlass, in: shape.shape)
            }
            .clipShape(.rect(cornerRadius: 24))
            .animation(.smooth, value: shape)
    }
}

#Preview {
    NavigationStack { GlassEffectDemo() }
}
