import SwiftUI

/// A colorful backdrop. Liquid Glass samples what is behind it, so the glass
/// demos need something more interesting than a flat background.
struct ShowcaseBackdrop: View {
    var body: some View {
        MeshGradient(
            width: 3,
            height: 3,
            points: [
                [0, 0], [0.5, 0], [1, 0],
                [0, 0.5], [0.6, 0.4], [1, 0.5],
                [0, 1], [0.5, 1], [1, 1]
            ],
            colors: [
                .indigo, .purple, .pink,
                .blue, .teal, .orange,
                .mint, .cyan, .yellow
            ]
        )
        .overlay {
            Image(systemName: "sparkles")
                .font(.system(size: 120))
                .foregroundStyle(.white.opacity(0.35))
        }
    }
}

/// A titled block inside a demo page.
struct DemoSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// The list of SDK symbols a demo uses, shown at the bottom of each page.
struct APIList: View {
    let demo: ShowcaseDemo

    var body: some View {
        DemoSection(title: "APIs used") {
            ForEach(demo.apis, id: \.self) { api in
                Text(api)
                    .font(.callout.monospaced())
                    .foregroundStyle(.secondary)
            }
        }
    }
}

/// The standard scrolling layout used by most demo pages.
struct DemoPage<Content: View>: View {
    let demo: ShowcaseDemo
    @ViewBuilder let content: Content

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                Text(demo.summary)
                    .foregroundStyle(.secondary)
                content
                APIList(demo: demo)
            }
            .padding()
        }
    }
}
