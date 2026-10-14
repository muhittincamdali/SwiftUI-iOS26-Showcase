// The usage examples from README.md and the DocC articles, copied verbatim so that
// API changes which break the documentation also break the build.
import Foundation
import SwiftUI
import SwiftUIiOS26Showcase
import Testing

// MARK: - README: The whole gallery (the App body, without @main)

private struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            ShowcaseGallery()
        }
    }
}

// MARK: - README: One demo

private struct ChartScreen: View {
    var body: some View {
        NavigationStack {
            ShowcaseDemoView(.chart3D)
        }
    }
}

@Suite("README examples")
@MainActor
struct ReadmeExamplesTests {
    @Test func galleryAndDemoViewsBuild() {
        _ = DemoApp().body
        _ = ChartScreen().body
        _ = ShowcaseGallery(initialDemo: .chart3D)
    }

    @Test func catalogExample() {
        let catalog = ShowcaseCatalog(platform: .iOS)
        let matches = catalog.demos(matching: "glass button")   // [.glassButtons]
        let sections = catalog.sections(matching: "symbol")     // one section: Charts, Symbols & Animation
        let demo = catalog.demo(withID: "webView")              // .webView

        #expect(matches == [.glassButtons])
        #expect(sections.map(\.category.title) == ["Charts, Symbols & Animation"])
        #expect(demo == .webView)
    }

    @Test func docCSearchExample() {
        let catalog = ShowcaseCatalog()
        let matches = catalog.demos(matching: "glass button")
        // [.glassButtons]
        #expect(matches == [.glassButtons])
    }

    @Test func helperExamples() {
        #expect(WebAddress.url(from: "swift.org")?.absoluteString == "https://swift.org")
        #expect(WebAddress.url(from: "javascript:alert(1)") == nil)
        #expect(SurfaceFunction.peak.height(x: 0, z: 0) == 1.0)
    }

    /// The README's demo table lists every demo with exactly the APIs in its metadata.
    @Test(arguments: ShowcaseDemo.allCases)
    func readmeTableMatchesTheCatalog(demo: ShowcaseDemo) throws {
        let readme = try String(contentsOf: Self.readmeURL, encoding: .utf8)
        let row = readme
            .split(separator: "\n")
            .first { line in
                let cells = line.split(separator: "|").map { $0.trimmingCharacters(in: .whitespaces) }
                return cells.count >= 2 && cells[1] == demo.title
            }
        let tableRow = try #require(row, "README has no row for \(demo.title)")

        #expect(tableRow.contains("| \(demo.category.title) "))
        let listedAPIs = tableRow
            .split(separator: "`")
            .enumerated()
            .filter { $0.offset.isMultiple(of: 2) == false }
            .map { String($0.element) }
        #expect(listedAPIs == demo.apis)
        #expect(tableRow.contains("(iOS)") == !demo.isAvailable(on: .macOS))
    }

    private static let readmeURL = URL(filePath: #filePath)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .appending(path: "README.md")
}
