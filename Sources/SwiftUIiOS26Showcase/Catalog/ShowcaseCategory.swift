/// A group of related demos, shown as one section in the gallery.
///
/// The declaration order of the cases is the order of the sections.
public enum ShowcaseCategory: String, CaseIterable, Identifiable, Sendable {
    case liquidGlass
    case barsAndNavigation
    case scrolling
    case text
    case graphics
    case intelligence

    public var id: String { rawValue }

    /// The section title shown in the gallery.
    public var title: String {
        switch self {
        case .liquidGlass: "Liquid Glass"
        case .barsAndNavigation: "Bars & Navigation"
        case .scrolling: "Scrolling & Layout"
        case .text: "Text & Web"
        case .graphics: "Charts, Symbols & Animation"
        case .intelligence: "Apple Intelligence"
        }
    }
}

/// The platforms a demo can run on.
public enum ShowcasePlatform: String, CaseIterable, Sendable {
    case iOS
    case macOS

    /// The platform the code is currently compiled for.
    public static var current: ShowcasePlatform {
        #if os(macOS)
        .macOS
        #else
        .iOS
        #endif
    }
}
