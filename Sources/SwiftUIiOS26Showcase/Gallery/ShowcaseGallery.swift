import SwiftUI

/// A searchable list of every demo available on the current platform,
/// grouped by category.
///
/// Drop it into a `WindowGroup` to get the whole showcase:
///
/// ```swift
/// @main
/// struct MyApp: App {
///     var body: some Scene {
///         WindowGroup {
///             ShowcaseGallery()
///         }
///     }
/// }
/// ```
public struct ShowcaseGallery: View {
    private let catalog: ShowcaseCatalog

    @State private var path: [ShowcaseDemo]
    @State private var query = ""

    /// Creates the gallery.
    ///
    /// - Parameter initialDemo: A demo to open on appear, for example from a
    ///   deep link. Demos that are not available on the current platform are
    ///   ignored.
    public init(initialDemo: ShowcaseDemo? = nil) {
        let catalog = ShowcaseCatalog()
        self.catalog = catalog
        let start = initialDemo.flatMap { catalog.demo(withID: $0.id) }
        _path = State(initialValue: start.map { [$0] } ?? [])
    }

    public var body: some View {
        NavigationStack(path: $path) {
            list
                .navigationTitle("iOS 26 Showcase")
                .searchable(text: $query, prompt: "Search demos and APIs")
                .navigationDestination(for: ShowcaseDemo.self) { demo in
                    ShowcaseDemoView(demo)
                }
        }
    }

    private var list: some View {
        let sections = catalog.sections(matching: query)
        return List {
            ForEach(sections) { section in
                Section(section.category.title) {
                    ForEach(section.demos) { demo in
                        NavigationLink(value: demo) {
                            ShowcaseRow(demo: demo)
                        }
                    }
                }
            }
        }
        .overlay {
            if sections.isEmpty {
                ContentUnavailableView.search(text: query)
            }
        }
    }
}

private struct ShowcaseRow: View {
    let demo: ShowcaseDemo

    var body: some View {
        Label {
            VStack(alignment: .leading, spacing: 2) {
                Text(demo.title)
                Text(demo.summary)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        } icon: {
            Image(systemName: demo.systemImage)
                .foregroundStyle(.tint)
        }
    }
}

#Preview {
    ShowcaseGallery()
}
