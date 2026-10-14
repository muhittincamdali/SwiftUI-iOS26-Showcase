import SwiftUI

struct SymbolDrawDemo: View {
    enum Granularity: String, CaseIterable, Identifiable {
        case byLayer, wholeSymbol, individually
        var id: Self { self }
    }

    private static let symbols = ["signature", "scribble.variable", "heart", "checkmark.circle", "paperplane"]

    @State private var isHidden = false
    @State private var granularity: Granularity = .byLayer
    @State private var progress = 0.6

    var body: some View {
        DemoPage(demo: .symbolDraw) {
            DemoSection(title: "Draw off / draw back on") {
                HStack(spacing: 20) {
                    ForEach(Self.symbols, id: \.self) { symbol in
                        Image(systemName: symbol)
                            .font(.system(size: 40))
                            .symbolEffect(drawOff, isActive: isHidden)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 80)

                Picker("Granularity", selection: $granularity) {
                    ForEach(Granularity.allCases) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                Button(isHidden ? "Draw on" : "Draw off") { isHidden.toggle() }
                    .buttonStyle(.glassProminent)
            }

            DemoSection(title: "Variable value drawn as progress") {
                HStack(spacing: 24) {
                    ForEach(["thermometer.high", "wifi", "speaker.wave.3.fill"], id: \.self) { symbol in
                        Image(systemName: symbol, variableValue: progress)
                            .font(.system(size: 40))
                    }
                }
                .symbolVariableValueMode(.draw)
                .frame(maxWidth: .infinity)
                LabeledContent("Value", value: progress, format: .percent.precision(.fractionLength(0)))
                Slider(value: $progress, in: 0...1)
            }
        }
    }

    private var drawOff: DrawOffSymbolEffect {
        switch granularity {
        case .byLayer: .drawOff.byLayer
        case .wholeSymbol: .drawOff.wholeSymbol
        case .individually: .drawOff.individually
        }
    }
}

#Preview {
    NavigationStack { SymbolDrawDemo() }
}
