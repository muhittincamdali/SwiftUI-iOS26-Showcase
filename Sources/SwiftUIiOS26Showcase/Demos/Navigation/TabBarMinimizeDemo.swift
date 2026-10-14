#if os(iOS)
import SwiftUI

struct TabBarMinimizeDemo: View {
    enum Behavior: String, CaseIterable, Identifiable {
        case automatic, onScrollDown, onScrollUp, never
        var id: Self { self }

        var value: TabBarMinimizeBehavior {
            switch self {
            case .automatic: .automatic
            case .onScrollDown: .onScrollDown
            case .onScrollUp: .onScrollUp
            case .never: .never
            }
        }
    }

    @State private var behavior: Behavior = .onScrollDown
    @State private var showsAccessory = true
    @State private var isPresented = false

    var body: some View {
        DemoPage(demo: .tabBarMinimize) {
            DemoSection(title: "Options") {
                Picker("Minimize behavior", selection: $behavior) {
                    ForEach(Behavior.allCases) { Text($0.rawValue).tag($0) }
                }
                Toggle("Bottom accessory (mini player)", isOn: $showsAccessory)
            }
            Button("Open tab view") { isPresented = true }
                .buttonStyle(.glassProminent)
                .controlSize(.large)
        }
        .fullScreenCover(isPresented: $isPresented) {
            SampleTabView(behavior: behavior.value, showsAccessory: showsAccessory)
        }
    }
}

private struct SampleTabView: View {
    let behavior: TabBarMinimizeBehavior
    let showsAccessory: Bool

    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""

    private var searchResults: [String] {
        SampleData.songs.filter { searchText.isEmpty || $0.localizedStandardContains(searchText) }
    }

    var body: some View {
        TabView {
            Tab("Listen Now", systemImage: "play.circle") {
                tabContent(title: "Listen Now")
            }
            Tab("Library", systemImage: "square.stack") {
                tabContent(title: "Library")
            }
            Tab(role: .search) {
                NavigationStack {
                    List(searchResults, id: \.self) { Text($0) }
                        .navigationTitle("Search")
                }
                .searchable(text: $searchText)
            }
        }
        .tabBarMinimizeBehavior(behavior)
        .modifier(MiniPlayerAccessory(isEnabled: showsAccessory))
    }

    private func tabContent(title: String) -> some View {
        NavigationStack {
            List(SampleData.songs, id: \.self) { song in
                Label(song, systemImage: "music.note")
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", systemImage: "xmark") { dismiss() }
                }
            }
        }
    }
}

/// Adds the mini player as the tab view's bottom accessory when enabled.
private struct MiniPlayerAccessory: ViewModifier {
    let isEnabled: Bool

    func body(content: Content) -> some View {
        if #available(iOS 26.1, *) {
            content.tabViewBottomAccessory(isEnabled: isEnabled) { MiniPlayer() }
        } else if isEnabled {
            // iOS 26.0 has no isEnabled parameter, so the modifier is left out instead.
            content.tabViewBottomAccessory { MiniPlayer() }
        } else {
            content
        }
    }
}

private struct MiniPlayer: View {
    @Environment(\.tabViewBottomAccessoryPlacement) private var placement
    @State private var isPlaying = false

    var body: some View {
        HStack {
            Image(systemName: "music.note")
            Text("Midnight City")
                .lineLimit(1)
            Spacer()
            Button(isPlaying ? "Pause" : "Play", systemImage: isPlaying ? "pause.fill" : "play.fill") {
                isPlaying.toggle()
            }
            .labelStyle(.iconOnly)
            if placement == .expanded {
                Button("Next", systemImage: "forward.fill") {}
                    .labelStyle(.iconOnly)
            }
        }
        .padding(.horizontal)
    }
}

private enum SampleData {
    static let songs = (1...40).map { "Track \($0)" }
}

#Preview {
    NavigationStack { TabBarMinimizeDemo() }
}
#endif
