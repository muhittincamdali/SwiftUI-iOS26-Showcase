# Getting Started

Add the package, then show the whole gallery or a single demo.

## Add the package

The package needs Xcode 26.1 or later and runs on iOS 26 and macOS 26.

1. In Xcode, open your app project and choose
   **File > Add Package Dependencies…**.
2. Paste `https://github.com/muhittincamdali/SwiftUI-iOS26-Showcase.git`
   into the search field at the top right.
3. Set **Dependency Rule** to **Branch** and enter `main`. The 1.0.0
   release predates the demos described here.
4. Click **Add Package**, choose your app target in the
   **Add to Target** column, and click **Add Package** again.

In a `Package.swift` manifest, add:

```swift
.package(url: "https://github.com/muhittincamdali/SwiftUI-iOS26-Showcase.git", branch: "main")
```

and list `"SwiftUIiOS26Showcase"` in your target's dependencies.

## Show the gallery

``ShowcaseGallery`` is a complete navigation stack with search:

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

Run the app on an iPhone simulator with iOS 26 or on a Mac with
macOS 26. The first screen lists the demos by category and has a search
field.

Pass `initialDemo` to open a demo right away, for example when handling a
deep link.

## Show one demo

``ShowcaseDemoView`` shows a single demo and sets its navigation title.
Put it inside your own `NavigationStack`:

```swift
NavigationStack {
    ShowcaseDemoView(.chart3D)
}
```

Two demos, ``ShowcaseDemo/tabBarMinimize`` and ``ShowcaseDemo/sectionIndex``,
use iOS-only APIs. On macOS they show a placeholder, and
``ShowcaseCatalog`` leaves them out.

## Search the catalog

``ShowcaseCatalog`` is the model behind the gallery list. Every word of a
query must appear in a demo's title, summary or API list:

```swift
let catalog = ShowcaseCatalog()
let matches = catalog.demos(matching: "glass button")
// [.glassButtons]
```

To build your own list of demos instead of using the gallery, see
<doc:BuildingADemoBrowser>.

## Foundation Models

The ``ShowcaseDemo/foundationModels`` demo checks
`SystemLanguageModel.default.availability` before it sends a prompt. On a
device without Apple Intelligence, or while the model is still downloading,
the demo shows the reason instead of a response.
