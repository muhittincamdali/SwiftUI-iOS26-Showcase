import SwiftUI
import SwiftUIiOS26Showcase

/// Runs the showcase gallery as an app.
///
/// Pass `-demo <id>` to open a demo on launch, for example
/// `-demo glassEffect`. `scripts/screenshots.sh` uses this.
@main
struct ShowcaseApp: App {
    private let initialDemo = LaunchArguments.demo(in: ProcessInfo.processInfo.arguments)

    var body: some Scene {
        WindowGroup {
            ShowcaseGallery(initialDemo: initialDemo)
        }
    }
}

enum LaunchArguments {
    static func demo(in arguments: [String]) -> ShowcaseDemo? {
        guard
            let index = arguments.firstIndex(of: "-demo"),
            arguments.indices.contains(index + 1)
        else { return nil }
        return ShowcaseDemo(rawValue: arguments[index + 1])
    }
}
