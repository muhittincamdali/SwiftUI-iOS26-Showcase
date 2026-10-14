# SwiftUI iOS 26 Showcase

[![CI](https://github.com/muhittincamdali/SwiftUI-iOS26-Showcase/actions/workflows/ci.yml/badge.svg)](https://github.com/muhittincamdali/SwiftUI-iOS26-Showcase/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/github/license/muhittincamdali/SwiftUI-iOS26-Showcase)](LICENSE)

Sixteen small SwiftUI screens, each built around one group of APIs that are new in iOS 26 and
macOS 26: Liquid Glass, the new bar and scroll modifiers, rich text editing, the native web view,
3D charts, SF Symbol draw effects, the `@Animatable` macro and the on-device Foundation Models
framework. Every screen has controls to try the API's options and lists the SDK symbols it uses.

The demos ship as a Swift package with a searchable gallery, so you can run them in the example
app or drop a single screen into your own project.

| Gallery                                   | Liquid Glass                                 | Morphing glass                                   | 3D chart                             |
| ----------------------------------------- | -------------------------------------------- | ------------------------------------------------ | ------------------------------------ |
| ![Gallery](docs/images/gallery-light.png) | ![Glass effect](docs/images/glassEffect.png) | ![Morphing glass](docs/images/glassMorphing.png) | ![3D chart](docs/images/chart3D.png) |

<sub>Captured from the example app on the iOS 26.5 simulator with `scripts/screenshots.sh`.
More: [gallery in dark mode](docs/images/gallery-dark.png),
[glass buttons](docs/images/glassButtons.png), [toolbar spacer](docs/images/toolbarSpacer.png),
[scroll edge effect](docs/images/scrollEdgeEffect.png),
[background extension](docs/images/backgroundExtension.png),
[rich text editor](docs/images/richTextEditor.png), [symbol draw](docs/images/symbolDraw.png),
[@Animatable](docs/images/animatableMacro.png),
[Foundation Models](docs/images/foundationModels.png).</sub>

## Demos

| Category                    | Demo                         | APIs                                                                                            |
| --------------------------- | ---------------------------- | ----------------------------------------------------------------------------------------------- |
| Liquid Glass                | Glass Effect                 | `glassEffect(_:in:)`, `Glass.regular`, `Glass.clear`, `Glass.tint(_:)`, `Glass.interactive(_:)` |
| Liquid Glass                | Morphing Glass               | `GlassEffectContainer`, `glassEffectID(_:in:)`, `glassEffectUnion(id:namespace:)`               |
| Liquid Glass                | Glass Button Styles          | `.buttonStyle(.glass)`, `.buttonStyle(.glassProminent)`                                         |
| Bars & Navigation           | Tab Bar Minimize & Accessory | `tabBarMinimizeBehavior(_:)`, `tabViewBottomAccessory(content:)`, `Tab(role: .search)` (iOS)    |
| Bars & Navigation           | Toolbar Spacer               | `ToolbarSpacer(_:placement:)`, `sharedBackgroundVisibility(_:)`                                 |
| Bars & Navigation           | Navigation Subtitle          | `navigationSubtitle(_:)`                                                                        |
| Bars & Navigation           | Section Index Labels         | `sectionIndexLabel(_:)`, `listSectionIndexVisibility(_:)` (iOS)                                 |
| Scrolling & Layout          | Scroll Edge Effect           | `scrollEdgeEffectStyle(_:for:)`, `safeAreaBar(edge:content:)`                                   |
| Scrolling & Layout          | Background Extension Effect  | `backgroundExtensionEffect(isEnabled:)`                                                         |
| Scrolling & Layout          | Label Icon Spacing           | `labelIconToTitleSpacing(_:)`                                                                   |
| Text & Web                  | Rich Text Editor             | `TextEditor(text:selection:)`, `AttributedTextSelection`, `transformAttributes(in:body:)`       |
| Text & Web                  | WebView & WebPage            | `WebView(_:)`, `WebPage`, `WebPage.load(_:)`                                                    |
| Charts, Symbols & Animation | 3D Charts                    | `Chart3D`, `SurfacePlot`, `chart3DPose(_:)`                                                     |
| Charts, Symbols & Animation | Symbol Draw Effects          | `symbolEffect(_:isActive:)`, `DrawOffSymbolEffect`, `symbolVariableValueMode(.draw)`            |
| Charts, Symbols & Animation | @Animatable Macro            | `@Animatable`, `@AnimatableIgnored`                                                             |
| Apple Intelligence          | On-Device Language Model     | `SystemLanguageModel`, `LanguageModelSession`, `@Generable`, `@Guide`                           |

The two demos marked (iOS) use APIs that do not exist on macOS, so the macOS gallery lists the
other fourteen.

## Requirements

- Xcode 26 or later (Swift 6.2 tools)
- iOS 26 or macOS 26

## Installation

Add the package in Xcode with File > Add Package Dependencies, using
`https://github.com/muhittincamdali/SwiftUI-iOS26-Showcase`, or in `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftUI-iOS26-Showcase.git", branch: "main")
],
targets: [
    .target(name: "MyApp", dependencies: [
        .product(name: "SwiftUIiOS26Showcase", package: "SwiftUI-iOS26-Showcase")
    ])
]
```

## Usage

### The whole gallery

`ShowcaseGallery` is a navigation stack with a searchable list of every demo available on the
current platform:

```swift
import SwiftUI
import SwiftUIiOS26Showcase

@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            ShowcaseGallery()
        }
    }
}
```

`ShowcaseGallery(initialDemo: .chart3D)` opens a demo on appear, for example from a deep link.

### One demo

`ShowcaseDemoView` shows a single demo and sets its navigation title:

```swift
struct ChartScreen: View {
    var body: some View {
        NavigationStack {
            ShowcaseDemoView(.chart3D)
        }
    }
}
```

### The catalog

`ShowcaseCatalog` holds the list, search and grouping logic behind the gallery. A query matches a
demo when every word appears in its title, summary or API list, ignoring case and diacritics:

```swift
let catalog = ShowcaseCatalog(platform: .iOS)
let matches = catalog.demos(matching: "glass button")   // [.glassButtons]
let sections = catalog.sections(matching: "symbol")     // one section: Charts, Symbols & Animation
let demo = catalog.demo(withID: "webView")              // .webView
```

### Helpers used by the demos

The logic behind some demos is public and covered by tests:

```swift
// What the web view demo accepts in its address bar.
WebAddress.url(from: "swift.org")              // https://swift.org
WebAddress.url(from: "javascript:alert(1)")    // nil

// The heights plotted by the 3D chart, always in -1...1.
SurfaceFunction.peak.height(x: 0, z: 0)        // 1.0
```

`RichTextFormatter` toggles bold, italic, underline and strikethrough on the selected part of an
`AttributedString`, the way the rich text demo's buttons do.

## Example app

`Examples/ShowcaseApp` is an iOS and macOS app that shows `ShowcaseGallery`. Open
`Examples/ShowcaseApp/ShowcaseApp.xcodeproj` and run the `ShowcaseApp` scheme. The project is
generated with [XcodeGen](https://github.com/yonaskolb/XcodeGen) from `project.yml`.

Pass `-demo <id>` as a launch argument to open a demo directly, for example `-demo glassEffect`.
`scripts/screenshots.sh` uses this to capture the images in `docs/images`.

## Notes

- **Foundation Models** needs Apple Intelligence. On a device without it, with it turned off, or
  while the model is downloading, the demo says which of these applies and disables the button that sends the prompt.
- **Tab bar accessory**: `tabViewBottomAccessory(isEnabled:content:)` needs iOS 26.1. On 26.1 and
  later the demo uses it; on 26.0 it adds or leaves out `tabViewBottomAccessory(content:)`.
- **WebView** loads `https://www.swift.org` when it appears, so it needs a network connection.
  The address bar only accepts `http` and `https` addresses.

## Testing

```bash
swift test
```

The tests use Swift Testing and run on macOS and in the iOS Simulator (CI runs both). They cover
catalog search and grouping, demo metadata, address validation, the chart's height functions, the
`@Animatable` wave shape, the rich text formatter, rendering every demo screen with
`ImageRenderer`, and the code samples in this README, which are compiled as part of the test
target.

To build the documentation catalog:

```bash
xcodebuild docbuild -scheme SwiftUIiOS26Showcase -destination 'generic/platform=iOS Simulator'
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Security reports: [SECURITY.md](SECURITY.md).

## License

MIT. See [LICENSE](LICENSE).
