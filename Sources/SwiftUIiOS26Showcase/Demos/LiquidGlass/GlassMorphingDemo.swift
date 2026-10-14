import SwiftUI

struct GlassMorphingDemo: View {
    private struct Action: Identifiable {
        let id: String
        let systemImage: String
    }

    private static let actions = [
        Action(id: "camera", systemImage: "camera"),
        Action(id: "photo", systemImage: "photo"),
        Action(id: "mic", systemImage: "mic")
    ]
    private static let toggleID = "toggle"
    private static let pointsFormat = FloatingPointFormatStyle<CGFloat>().precision(.fractionLength(0))

    @Namespace private var namespace
    @State private var isExpanded = false
    @State private var containerSpacing: CGFloat = 24
    @State private var itemSpacing: CGFloat = 16

    var body: some View {
        DemoPage(demo: .glassMorphing) {
            DemoSection(title: "Morph with glassEffectID") {
                ShowcaseBackdrop()
                    .frame(height: 180)
                    .overlay { expandingMenu }
                    .clipShape(.rect(cornerRadius: 24))
                Text("Tap the button. New glass shapes grow out of it and merge back when collapsed.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            DemoSection(title: "Blend distance") {
                ShowcaseBackdrop()
                    .frame(height: 160)
                    .overlay { blendingRow }
                    .clipShape(.rect(cornerRadius: 24))
                LabeledContent("Container spacing", value: containerSpacing, format: Self.pointsFormat)
                Slider(value: $containerSpacing, in: 0...60)
                LabeledContent("Item spacing", value: itemSpacing, format: Self.pointsFormat)
                Slider(value: $itemSpacing, in: 0...60)
                Text("Shapes closer than the container spacing visually blend into one piece of glass.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            DemoSection(title: "Union") {
                ShowcaseBackdrop()
                    .frame(height: 140)
                    .overlay { unionRow }
                    .clipShape(.rect(cornerRadius: 24))
            }
        }
    }

    private var expandingMenu: some View {
        GlassEffectContainer(spacing: 24) {
            HStack(spacing: 16) {
                if isExpanded {
                    ForEach(Self.actions) { action in
                        Image(systemName: action.systemImage)
                            .font(.title2)
                            .frame(width: 56, height: 56)
                            .glassEffect(.regular.interactive())
                            .glassEffectID(action.id, in: namespace)
                    }
                }
                Button {
                    withAnimation(.bouncy) { isExpanded.toggle() }
                } label: {
                    Image(systemName: isExpanded ? "xmark" : "plus")
                        .font(.title2.bold())
                        .frame(width: 56, height: 56)
                }
                .buttonStyle(.plain)
                .glassEffect(.regular.tint(.blue).interactive())
                .glassEffectID(Self.toggleID, in: namespace)
                .accessibilityLabel(isExpanded ? "Collapse" : "Expand")
            }
        }
    }

    private var blendingRow: some View {
        GlassEffectContainer(spacing: containerSpacing) {
            HStack(spacing: itemSpacing) {
                ForEach(["sun.max", "cloud", "moon"], id: \.self) { symbol in
                    Image(systemName: symbol)
                        .font(.title)
                        .frame(width: 64, height: 64)
                        .glassEffect()
                }
            }
        }
    }

    private var unionRow: some View {
        GlassEffectContainer {
            HStack(spacing: 12) {
                ForEach(0..<4) { index in
                    Text("\(index + 1)")
                        .font(.title3.bold())
                        .frame(width: 48, height: 48)
                        .glassEffect()
                        .glassEffectUnion(id: index < 2 ? "first" : "second", namespace: namespace)
                }
            }
        }
    }
}

#Preview {
    NavigationStack { GlassMorphingDemo() }
}
