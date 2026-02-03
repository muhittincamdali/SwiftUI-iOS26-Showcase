import SwiftUI

// MARK: - Navigation Demo

/// Demonstrates NavigationStack with zoom transitions, custom paths,
/// and programmatic navigation patterns in iOS 26.
struct NavigationDemo: View {

    // MARK: - Properties

    @State private var path = NavigationPath()
    @State private var selectedCategory: NavCategory?
    @State private var showSettings = false

    private let categories: [NavCategory] = [
        NavCategory(name: "Favorites", icon: "star.fill", color: .yellow, count: 12),
        NavCategory(name: "Recent", icon: "clock.fill", color: .blue, count: 34),
        NavCategory(name: "Shared", icon: "person.2.fill", color: .green, count: 8),
        NavCategory(name: "Downloads", icon: "arrow.down.circle.fill", color: .purple, count: 56),
        NavCategory(name: "Archived", icon: "archivebox.fill", color: .orange, count: 21),
        NavCategory(name: "Trash", icon: "trash.fill", color: .red, count: 3)
    ]

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                navigationPreview
                programmaticSection
                codeSection
            }
            .padding()
        }
        .navigationTitle("Navigation")
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("NavigationStack")
                .font(.title2.bold())
            Text("Build complex navigation hierarchies with type-safe paths, zoom transitions, and deep linking support.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Navigation Preview

    private var navigationPreview: some View {
        VStack(spacing: 1) {
            ForEach(categories) { category in
                Button {
                    selectedCategory = category
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: category.icon)
                            .font(.title3)
                            .foregroundStyle(category.color)
                            .frame(width: 32)

                        VStack(alignment: .leading) {
                            Text(category.name)
                                .font(.body)
                                .foregroundStyle(.primary)
                            Text("\(category.count) items")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.caption.bold())
                            .foregroundStyle(.tertiary)
                    }
                    .padding()
                    .background(selectedCategory?.id == category.id ? category.color.opacity(0.1) : .clear)
                }
            }
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Programmatic Navigation

    private var programmaticSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Programmatic Navigation")
                .font(.headline)
            Text("Use NavigationPath to push and pop views programmatically.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                Button("Push Random") {
                    selectedCategory = categories.randomElement()
                }
                .buttonStyle(.borderedProminent)

                Button("Reset") {
                    selectedCategory = nil
                    path = NavigationPath()
                }
                .buttonStyle(.bordered)
            }

            if let selected = selectedCategory {
                HStack {
                    Image(systemName: selected.icon)
                        .foregroundStyle(selected.color)
                    Text("Selected: \(selected.name)")
                        .font(.subheadline)
                }
                .padding()
                .background(selected.color.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Code

    private var codeSection: some View {
        CodeSnippetView(
            code: """
            @State private var path = NavigationPath()

            NavigationStack(path: $path) {
                List(categories) { category in
                    NavigationLink(value: category) {
                        Label(category.name, systemImage: category.icon)
                    }
                }
                .navigationDestination(for: Category.self) { cat in
                    DetailView(category: cat)
                }
            }
            """,
            language: "swift"
        )
    }
}

// MARK: - Nav Category

struct NavCategory: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    let count: Int
}
