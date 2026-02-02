import SwiftUI

// MARK: - App Entry Point

/// Main entry point for the SwiftUI iOS 26 Showcase application.
/// Configures the app's scene and initial navigation structure.
@main
struct ShowcaseApp: App {

    // MARK: - Properties

    @State private var selectedTab: AppTab = .glass

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            ContentView(selectedTab: $selectedTab)
                .preferredColorScheme(.dark)
        }
    }
}

// MARK: - App Tab

/// Represents the main navigation tabs in the showcase.
enum AppTab: String, CaseIterable, Identifiable {
    case glass = "Glass"
    case swiftUI = "SwiftUI"
    case intelligence = "Intelligence"
    case swift62 = "Swift 6.2"
    case platform = "Platform"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .glass: return "cube.transparent"
        case .swiftUI: return "paintbrush"
        case .intelligence: return "brain"
        case .swift62: return "swift"
        case .platform: return "visionpro"
        }
    }
}
