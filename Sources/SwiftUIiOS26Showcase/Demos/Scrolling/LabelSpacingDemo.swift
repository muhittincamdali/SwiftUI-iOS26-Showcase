import SwiftUI

struct LabelSpacingDemo: View {
    private static let items = [
        ("Wi-Fi", "wifi"),
        ("Bluetooth", "dot.radiowaves.left.and.right"),
        ("Battery", "battery.100percent"),
        ("Notifications", "bell.badge"),
        ("Privacy", "hand.raised")
    ]

    @State private var spacing: CGFloat = 8

    var body: some View {
        DemoPage(demo: .labelSpacing) {
            DemoSection(title: "Spacing") {
                LabeledContent("Icon to title", value: spacing, format: .number.precision(.fractionLength(0)))
                Slider(value: $spacing, in: 0...40)
            }
            DemoSection(title: "Preview") {
                VStack(alignment: .leading, spacing: 14) {
                    ForEach(Self.items, id: \.0) { title, symbol in
                        Label(title, systemImage: symbol)
                    }
                }
                .labelIconToTitleSpacing(spacing)
                .animation(.snappy, value: spacing)
            }
        }
    }
}

#Preview {
    NavigationStack { LabelSpacingDemo() }
}
