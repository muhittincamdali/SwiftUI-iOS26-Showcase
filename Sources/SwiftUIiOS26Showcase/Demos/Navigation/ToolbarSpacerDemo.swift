import SwiftUI

struct ToolbarSpacerDemo: View {
    enum Sizing: String, CaseIterable, Identifiable {
        case fixed, flexible
        var id: Self { self }

        var value: SpacerSizing {
            switch self {
            case .fixed: .fixed
            case .flexible: .flexible
            }
        }
    }

    @State private var sizing: Sizing = .fixed
    @State private var hidesSharedBackground = false
    @State private var lastAction = "None"

    var body: some View {
        DemoPage(demo: .toolbarSpacer) {
            DemoSection(title: "Options") {
                Picker("Spacer between groups", selection: $sizing) {
                    ForEach(Sizing.allCases) { Text($0.rawValue.capitalized).tag($0) }
                }
                .pickerStyle(.segmented)
                Toggle("Hide the shared glass background of the share button", isOn: $hidesSharedBackground)
            }
            DemoSection(title: "Last toolbar action") {
                Text(lastAction)
                    .font(.body.monospaced())
            }
            Text("""
                Items inside one group share a single glass background. \
                A spacer splits the toolbar into separate groups.
                """)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Share", systemImage: "square.and.arrow.up") { lastAction = "Share" }
            }
            .sharedBackgroundVisibility(hidesSharedBackground ? .hidden : .automatic)

            ToolbarSpacer(sizing.value, placement: .primaryAction)

            ToolbarItemGroup(placement: .primaryAction) {
                Button("Undo", systemImage: "arrow.uturn.backward") { lastAction = "Undo" }
                Button("Redo", systemImage: "arrow.uturn.forward") { lastAction = "Redo" }
            }

            #if os(iOS)
            ToolbarItem(placement: .bottomBar) {
                Button("Filter", systemImage: "line.3.horizontal.decrease") { lastAction = "Filter" }
            }
            ToolbarSpacer(.flexible, placement: .bottomBar)
            ToolbarItem(placement: .bottomBar) {
                Button("Compose", systemImage: "square.and.pencil") { lastAction = "Compose" }
            }
            #endif
        }
    }
}

#Preview {
    NavigationStack { ToolbarSpacerDemo() }
}
