import SwiftUI

struct ScrollEdgeEffectDemo: View {
    enum Style: String, CaseIterable, Identifiable {
        case automatic, soft, hard
        var id: Self { self }

        var value: ScrollEdgeEffectStyle {
            switch self {
            case .automatic: .automatic
            case .soft: .soft
            case .hard: .hard
            }
        }
    }

    /// How many rows the page shows, enough to scroll under the bar on any screen.
    static let rowCount = 30

    @State private var style: Style = .soft

    var body: some View {
        DemoScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                Text(ShowcaseDemo.scrollEdgeEffect.summary)
                    .foregroundStyle(.secondary)
                ForEach(0..<Self.rowCount, id: \.self) { index in
                    row(index)
                }
                APIList(demo: .scrollEdgeEffect)
            }
            .padding()
        }
        .safeAreaBar(edge: .top) {
            Picker("Edge effect", selection: $style) {
                ForEach(Style.allCases) { Text($0.rawValue.capitalized).tag($0) }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .scrollEdgeEffectStyle(style.value, for: .top)
    }

    private func row(_ index: Int) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hue: Double(index) / Double(Self.rowCount), saturation: 0.7, brightness: 0.9).gradient)
                .frame(width: 44, height: 44)
            VStack(alignment: .leading) {
                Text("Row \(index + 1)")
                    .font(.headline)
                Text("Scroll up to see content pass under the bar.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    NavigationStack { ScrollEdgeEffectDemo() }
}
