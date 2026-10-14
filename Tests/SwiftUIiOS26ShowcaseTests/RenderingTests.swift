import FoundationModels
import SwiftUI
import Testing
@testable import SwiftUIiOS26Showcase

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

/// The size of a rendered view and how many of its pixels are not transparent.
private struct Rendering {
    let height: Int
    let drawnPixels: Int
}

@Suite("Rendering")
@MainActor
struct RenderingTests {
    private static let width = 390

    /// Demos built on `List`, which `ImageRenderer` does not draw.
    nonisolated private static let listDemos: Set<ShowcaseDemo> = [.navigationSubtitle, .sectionIndex]

    /// Renders a view at its natural height, with demo pages laid out without a scroll view.
    private func render(_ view: some View) throws -> Rendering {
        let renderer = ImageRenderer(content: view.environment(\.demoPagesScroll, false))
        renderer.proposedSize = ProposedViewSize(width: CGFloat(Self.width), height: nil)
        renderer.scale = 1
        let image = try #require(renderer.cgImage)
        var pixels = [UInt8](repeating: 0, count: image.width * image.height * 4)
        let context = try #require(CGContext(
            data: &pixels,
            width: image.width,
            height: image.height,
            bitsPerComponent: 8,
            bytesPerRow: image.width * 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ))
        context.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
        let drawn = stride(from: 3, to: pixels.count, by: 4).count { pixels[$0] > 0 }
        return Rendering(height: image.height, drawnPixels: drawn)
    }

    @Test func pixelCountSeesContent() throws {
        #expect(try render(Color.clear.frame(height: 100)).drawnPixels == 0)
        #expect(try render(Text("Glass").font(.largeTitle)).drawnPixels > 0)
    }

    /// Each demo must lay out and draw more than a page that has only the same
    /// summary and API list, so a demo whose own content is empty fails.
    ///
    /// The check is only as strong as what `ImageRenderer` draws, and it does not
    /// draw `WebView`. For the web view demo the extra pixels come from the address
    /// and status bars, so the test passes even without the `WebView` itself.
    @Test(arguments: ShowcaseCatalog().demos.filter { !Self.listDemos.contains($0) })
    func demoDrawsItsOwnContent(demo: ShowcaseDemo) throws {
        let page = try render(ShowcaseDemoView(demo))
        let bare = try render(DemoPage(demo: demo) { EmptyView() })
        #expect(page.height > bare.height)
        #expect(page.drawnPixels > bare.drawnPixels)
    }

    /// The scroll edge demo's picker sits in a bar outside the page content, so the
    /// check above would pass on the picker alone. Each row is at least 44 points tall.
    @Test func scrollEdgeEffectDrawsItsRows() throws {
        let page = try render(ScrollEdgeEffectDemo())
        let bare = try render(DemoPage(demo: .scrollEdgeEffect) { EmptyView() })
        let rowsHeight = ScrollEdgeEffectDemo.rowCount * 44
        #expect(page.height >= bare.height + rowsHeight)
    }

    #if os(macOS)
    @Test(arguments: [ShowcaseDemo.tabBarMinimize, .sectionIndex])
    func iOSOnlyDemoShowsAPlaceholderOnMacOS(demo: ShowcaseDemo) throws {
        #expect(try render(ShowcaseDemoView(demo)).drawnPixels > 0)
    }
    #endif

    @Test(arguments: ShowcaseDemo.allCases)
    func systemImageExists(demo: ShowcaseDemo) {
        #if canImport(UIKit)
        #expect(UIImage(systemName: demo.systemImage) != nil, "\(demo.systemImage)")
        #else
        let image = NSImage(systemSymbolName: demo.systemImage, accessibilityDescription: nil)
        #expect(image != nil, "\(demo.systemImage)")
        #endif
    }
}

@Suite("ModelAvailabilityMessage")
struct ModelAvailabilityMessageTests {
    @Test func everyStateHasItsOwnMessage() {
        let states: [SystemLanguageModel.Availability] = [
            .available,
            .unavailable(.deviceNotEligible),
            .unavailable(.appleIntelligenceNotEnabled),
            .unavailable(.modelNotReady)
        ]
        let messages = states.map(ModelAvailabilityMessage.text(for:))
        #expect(Set(messages).count == states.count)
        #expect(messages.allSatisfy { $0.hasSuffix(".") })
    }
}
