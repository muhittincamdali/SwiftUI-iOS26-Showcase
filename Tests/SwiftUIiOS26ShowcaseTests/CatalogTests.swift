import Testing
@testable import SwiftUIiOS26Showcase

@Suite("ShowcaseCatalog")
struct CatalogTests {
    private let iOS = ShowcaseCatalog(platform: .iOS)
    private let macOS = ShowcaseCatalog(platform: .macOS)

    @Test func iOSListsEveryDemo() {
        #expect(iOS.demos == ShowcaseDemo.allCases)
    }

    @Test func macOSLeavesOutIOSOnlyDemos() {
        #expect(!macOS.demos.contains(.tabBarMinimize))
        #expect(!macOS.demos.contains(.sectionIndex))
        #expect(macOS.demos.count == ShowcaseDemo.allCases.count - 2)
    }

    @Test(arguments: ["", "   ", "\n\t"])
    func blankQueryReturnsAllDemos(query: String) {
        #expect(iOS.demos(matching: query) == iOS.demos)
    }

    @Test func searchMatchesTitleSummaryAndAPIs() {
        #expect(iOS.demos(matching: "WebPage") == [.webView])
        #expect(iOS.demos(matching: "Chart3D") == [.chart3D])
        #expect(iOS.demos(matching: "mini player") == [.tabBarMinimize])
        #expect(iOS.demos(matching: "GlassEffectContainer") == [.glassMorphing])
    }

    @Test func searchIgnoresCaseAndDiacritics() {
        #expect(iOS.demos(matching: "GLASS BUTTON") == [.glassButtons])
        #expect(iOS.demos(matching: "navigatión subtitle") == [.navigationSubtitle])
    }

    @Test func searchRequiresEveryWord() {
        let glass = iOS.demos(matching: "glass")
        #expect(glass.count > 1)
        #expect(iOS.demos(matching: "glass morph") == [.glassMorphing])
        #expect(iOS.demos(matching: "glass zebra").isEmpty)
    }

    @Test func sectionsFollowCategoryOrderAndSkipEmptyOnes() {
        let all = iOS.sections()
        #expect(all.map(\.category) == ShowcaseCategory.allCases)
        #expect(all.flatMap(\.demos).count == iOS.demos.count)

        let filtered = iOS.sections(matching: "symbol")
        #expect(filtered.map(\.category) == [.graphics])
    }

    @Test func sectionsKeepDemoDeclarationOrder() {
        let glass = iOS.sections().first { $0.category == .liquidGlass }
        #expect(glass?.demos == [.glassEffect, .glassMorphing, .glassButtons])
    }

    @Test func lookupByIdentifier() {
        #expect(iOS.demo(withID: "chart3D") == .chart3D)
        #expect(iOS.demo(withID: "unknown") == nil)
        #expect(iOS.demo(withID: "tabBarMinimize") == .tabBarMinimize)
        #expect(macOS.demo(withID: "tabBarMinimize") == nil)
    }
}

@Suite("ShowcaseDemo metadata")
struct DemoMetadataTests {
    @Test(arguments: ShowcaseDemo.allCases)
    func metadataIsFilledIn(demo: ShowcaseDemo) {
        #expect(!demo.title.isEmpty)
        #expect(demo.summary.hasSuffix("."))
        #expect(!demo.apis.isEmpty)
        #expect(!demo.platforms.isEmpty)
        #expect(demo.id == demo.rawValue)
    }

    @Test func titlesAreUnique() {
        let titles = ShowcaseDemo.allCases.map(\.title)
        #expect(Set(titles).count == titles.count)
    }

    @Test func everyCategoryHasADemo() {
        for category in ShowcaseCategory.allCases {
            #expect(ShowcaseDemo.allCases.contains { $0.category == category }, "\(category) is empty")
        }
    }

    @Test func currentPlatformMatchesTheBuild() {
        #if os(macOS)
        #expect(ShowcasePlatform.current == .macOS)
        #else
        #expect(ShowcasePlatform.current == .iOS)
        #endif
    }
}
