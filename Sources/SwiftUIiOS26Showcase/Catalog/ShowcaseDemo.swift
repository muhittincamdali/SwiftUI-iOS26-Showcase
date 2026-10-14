/// Every demo in the showcase.
///
/// Each case has a matching SwiftUI screen (see ``ShowcaseDemoView``) and the
/// metadata the gallery uses for its list and search.
public enum ShowcaseDemo: String, CaseIterable, Identifiable, Sendable {
    case glassEffect
    case glassMorphing
    case glassButtons
    case tabBarMinimize
    case toolbarSpacer
    case navigationSubtitle
    case sectionIndex
    case scrollEdgeEffect
    case backgroundExtension
    case labelSpacing
    case richTextEditor
    case webView
    case chart3D
    case symbolDraw
    case animatableMacro
    case foundationModels

    public var id: String { rawValue }

    public var title: String { metadata.title }
    public var summary: String { metadata.summary }
    public var systemImage: String { metadata.systemImage }
    public var category: ShowcaseCategory { metadata.category }

    /// The SDK symbols the demo exercises, written the way they appear in code.
    public var apis: [String] { metadata.apis }

    /// The platforms the demo's APIs are available on.
    public var platforms: Set<ShowcasePlatform> { metadata.platforms }

    public func isAvailable(on platform: ShowcasePlatform) -> Bool {
        platforms.contains(platform)
    }
}

struct ShowcaseDemoMetadata {
    let title: String
    let summary: String
    let systemImage: String
    let category: ShowcaseCategory
    let apis: [String]
    var platforms: Set<ShowcasePlatform> = [.iOS, .macOS]
}

extension ShowcaseDemo {
    // One switch keeps every demo's metadata in a single place.
    var metadata: ShowcaseDemoMetadata {
        switch self {
        case .glassEffect:
            ShowcaseDemoMetadata(
                title: "Glass Effect",
                summary: "Regular, clear, tinted and interactive Liquid Glass on custom shapes.",
                systemImage: "drop.halffull",
                category: .liquidGlass,
                apis: ["glassEffect(_:in:)", "Glass.regular", "Glass.clear", "Glass.tint(_:)", "Glass.interactive(_:)"]
            )
        case .glassMorphing:
            ShowcaseDemoMetadata(
                title: "Morphing Glass",
                summary: "Glass shapes that blend and morph into each other inside a shared container.",
                systemImage: "circle.grid.2x1",
                category: .liquidGlass,
                apis: ["GlassEffectContainer", "glassEffectID(_:in:)", "glassEffectUnion(id:namespace:)"]
            )
        case .glassButtons:
            ShowcaseDemoMetadata(
                title: "Glass Button Styles",
                summary: "The system glass and prominent glass button styles next to the classic ones.",
                systemImage: "capsule",
                category: .liquidGlass,
                apis: [".buttonStyle(.glass)", ".buttonStyle(.glassProminent)"]
            )
        case .tabBarMinimize:
            ShowcaseDemoMetadata(
                title: "Tab Bar Minimize & Accessory",
                summary: "A tab bar that shrinks while scrolling, with a mini player above it and a search tab.",
                systemImage: "dock.rectangle",
                category: .barsAndNavigation,
                apis: ["tabBarMinimizeBehavior(_:)", "tabViewBottomAccessory(content:)", "Tab(role: .search)"],
                platforms: [.iOS]
            )
        case .toolbarSpacer:
            ShowcaseDemoMetadata(
                title: "Toolbar Spacer",
                summary: "Grouping toolbar items with fixed and flexible spacers.",
                systemImage: "menubar.rectangle",
                category: .barsAndNavigation,
                apis: ["ToolbarSpacer(_:placement:)", "sharedBackgroundVisibility(_:)"]
            )
        case .navigationSubtitle:
            ShowcaseDemoMetadata(
                title: "Navigation Subtitle",
                summary: "A secondary line of text under the navigation title.",
                systemImage: "text.alignleft",
                category: .barsAndNavigation,
                apis: ["navigationSubtitle(_:)"]
            )
        case .sectionIndex:
            ShowcaseDemoMetadata(
                title: "Section Index Labels",
                summary: "An A-Z index on the trailing edge of a list, driven by section labels.",
                systemImage: "list.bullet.indent",
                category: .barsAndNavigation,
                apis: ["sectionIndexLabel(_:)", "listSectionIndexVisibility(_:)"],
                platforms: [.iOS]
            )
        case .scrollEdgeEffect:
            ShowcaseDemoMetadata(
                title: "Scroll Edge Effect",
                summary: "Soft and hard edge effects where content scrolls under a bar.",
                systemImage: "square.topthird.inset.filled",
                category: .scrolling,
                apis: ["scrollEdgeEffectStyle(_:for:)", "safeAreaBar(edge:content:)"]
            )
        case .backgroundExtension:
            ShowcaseDemoMetadata(
                title: "Background Extension Effect",
                summary: "Mirrors and blurs an image into the safe area around it.",
                systemImage: "photo.on.rectangle",
                category: .scrolling,
                apis: ["backgroundExtensionEffect(isEnabled:)"]
            )
        case .labelSpacing:
            ShowcaseDemoMetadata(
                title: "Label Icon Spacing",
                summary: "Controlling the gap between a label's icon and its title.",
                systemImage: "tag",
                category: .scrolling,
                apis: ["labelIconToTitleSpacing(_:)"]
            )
        case .richTextEditor:
            ShowcaseDemoMetadata(
                title: "Rich Text Editor",
                summary: "TextEditor bound to an AttributedString with bold, italic, underline and strikethrough.",
                systemImage: "textformat",
                category: .text,
                apis: ["TextEditor(text:selection:)", "AttributedTextSelection", "transformAttributes(in:body:)"]
            )
        case .webView:
            ShowcaseDemoMetadata(
                title: "WebView & WebPage",
                summary: "The native SwiftUI web view driven by an observable WebPage.",
                systemImage: "safari",
                category: .text,
                apis: ["WebView(_:)", "WebPage", "WebPage.load(_:)"]
            )
        case .chart3D:
            ShowcaseDemoMetadata(
                title: "3D Charts",
                summary: "A rotatable surface plot of a mathematical function.",
                systemImage: "cube",
                category: .graphics,
                apis: ["Chart3D", "SurfacePlot", "chart3DPose(_:)"]
            )
        case .symbolDraw:
            ShowcaseDemoMetadata(
                title: "Symbol Draw Effects",
                summary: "SF Symbols that erase and redraw their strokes, and variable values drawn as progress.",
                systemImage: "scribble",
                category: .graphics,
                apis: ["symbolEffect(_:isActive:)", "DrawOffSymbolEffect", "symbolVariableValueMode(.draw)"]
            )
        case .animatableMacro:
            ShowcaseDemoMetadata(
                title: "@Animatable Macro",
                summary: "A custom shape whose animatable data is synthesized by a macro.",
                systemImage: "waveform.path",
                category: .graphics,
                apis: ["@Animatable", "@AnimatableIgnored"]
            )
        case .foundationModels:
            ShowcaseDemoMetadata(
                title: "On-Device Language Model",
                summary: "Prompting the Foundation Models framework, with plain text and @Generable output.",
                systemImage: "sparkles",
                category: .intelligence,
                apis: ["SystemLanguageModel", "LanguageModelSession", "@Generable", "@Guide"]
            )
        }
    }
}
