import FoundationModels
import SwiftUI
import Testing
@testable import SwiftUIiOS26Showcase

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

@Suite("Rendering")
@MainActor
struct RenderingTests {
    private static let size = CGSize(width: 390, height: 844)

    private func render(_ view: some View) -> CGImage? {
        let renderer = ImageRenderer(content: view.frame(width: Self.size.width, height: Self.size.height))
        renderer.scale = 1
        return renderer.cgImage
    }

    @Test(arguments: ShowcaseCatalog().demos)
    func everyAvailableDemoRenders(demo: ShowcaseDemo) {
        let image = render(NavigationStack { ShowcaseDemoView(demo) })
        #expect(image?.width == Int(Self.size.width))
        #expect(image?.height == Int(Self.size.height))
    }

    @Test func galleryRenders() {
        #expect(render(ShowcaseGallery()) != nil)
        #expect(render(ShowcaseGallery(initialDemo: .chart3D)) != nil)
    }

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

    @Test func currentAvailabilityHasAMessage() {
        let message = ModelAvailabilityMessage.text(for: SystemLanguageModel.default.availability)
        #expect(!message.isEmpty)
    }
}
