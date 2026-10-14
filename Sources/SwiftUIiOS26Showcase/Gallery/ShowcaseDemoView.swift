import SwiftUI

/// The screen for one demo, titled with the demo's name.
///
/// Use it to embed a single demo in your own navigation:
///
/// ```swift
/// NavigationStack {
///     ShowcaseDemoView(.glassEffect)
/// }
/// ```
///
/// Demos that are not available on the current platform show an
/// explanation instead.
public struct ShowcaseDemoView: View {
    public let demo: ShowcaseDemo

    public init(_ demo: ShowcaseDemo) {
        self.demo = demo
    }

    public var body: some View {
        content
            .navigationTitle(demo.title)
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
    }

    @ViewBuilder
    private var content: some View {
        switch demo {
        case .glassEffect: GlassEffectDemo()
        case .glassMorphing: GlassMorphingDemo()
        case .glassButtons: GlassButtonsDemo()
        case .toolbarSpacer: ToolbarSpacerDemo()
        case .navigationSubtitle: NavigationSubtitleDemo()
        case .scrollEdgeEffect: ScrollEdgeEffectDemo()
        case .backgroundExtension: BackgroundExtensionDemo()
        case .labelSpacing: LabelSpacingDemo()
        case .richTextEditor: RichTextEditorDemo()
        case .webView: WebViewDemo()
        case .chart3D: Chart3DDemo()
        case .symbolDraw: SymbolDrawDemo()
        case .animatableMacro: AnimatableMacroDemo()
        case .foundationModels: FoundationModelsDemo()
        #if os(iOS)
        case .tabBarMinimize: TabBarMinimizeDemo()
        case .sectionIndex: SectionIndexDemo()
        #else
        case .tabBarMinimize, .sectionIndex: unavailable
        #endif
        }
    }

    private var unavailable: some View {
        ContentUnavailableView(
            "Not available on \(ShowcasePlatform.current.rawValue)",
            systemImage: "nosign",
            description: Text("\(demo.title) uses APIs that only exist on iOS.")
        )
    }
}
