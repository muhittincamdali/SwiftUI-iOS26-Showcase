import SwiftUI

struct GlassButtonsDemo: View {
    @State private var tapCount = 0

    var body: some View {
        DemoPage(demo: .glassButtons) {
            DemoSection(title: "Glass styles") {
                ShowcaseBackdrop()
                    .frame(height: 200)
                    .overlay {
                        VStack(spacing: 16) {
                            Button("Glass") { tapCount += 1 }
                                .buttonStyle(.glass)
                            Button("Glass Prominent") { tapCount += 1 }
                                .buttonStyle(.glassProminent)
                            Button("Tinted Prominent") { tapCount += 1 }
                                .buttonStyle(.glassProminent)
                                .tint(.orange)
                        }
                        .controlSize(.large)
                    }
                    .clipShape(.rect(cornerRadius: 24))
            }

            DemoSection(title: "Classic styles for comparison") {
                HStack {
                    Button("Bordered") { tapCount += 1 }
                        .buttonStyle(.bordered)
                    Button("Prominent") { tapCount += 1 }
                        .buttonStyle(.borderedProminent)
                }
            }

            DemoSection(title: "Icon buttons") {
                HStack(spacing: 12) {
                    ForEach(["play.fill", "forward.fill", "heart", "square.and.arrow.up"], id: \.self) { symbol in
                        Button {
                            tapCount += 1
                        } label: {
                            Image(systemName: symbol)
                                .frame(width: 24, height: 24)
                        }
                        .buttonStyle(.glass)
                        .buttonBorderShape(.circle)
                    }
                }
                .controlSize(.large)
            }

            Text("Buttons tapped: \(tapCount)")
                .font(.footnote.monospacedDigit())
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NavigationStack { GlassButtonsDemo() }
}
