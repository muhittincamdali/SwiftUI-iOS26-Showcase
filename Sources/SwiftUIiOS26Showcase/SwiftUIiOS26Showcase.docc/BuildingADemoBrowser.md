# Building a Demo Browser

Use the catalog to put the demos into your own navigation, such as a
split view with a sidebar, and open a demo from a link.

## Overview

``ShowcaseGallery`` is a ready-made list in a navigation stack. When an app
needs a different layout, for example a sidebar on iPad and Mac, build the
list from ``ShowcaseCatalog`` and show the selected demo with
``ShowcaseDemoView``. The catalog only contains the demos that run on the
current platform, so the list never offers a screen that cannot open.

## List the demos by category

``ShowcaseCatalog/sections(matching:)`` groups the demos by
``ShowcaseCategory`` in a fixed order. Each ``ShowcaseDemo`` has a title,
a summary and an SF Symbol for the row:

```swift
import SwiftUI
import SwiftUIiOS26Showcase

struct DemoBrowser: View {
    private let catalog = ShowcaseCatalog()
    @State private var selection: ShowcaseDemo?
    @State private var query = ""

    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                ForEach(catalog.sections(matching: query)) { section in
                    Section(section.category.title) {
                        ForEach(section.demos) { demo in
                            Label(demo.title, systemImage: demo.systemImage)
                                .tag(demo)
                        }
                    }
                }
            }
            .navigationTitle("Demos")
            .searchable(text: $query)
        } detail: {
            if let selection {
                ShowcaseDemoView(selection)
            } else {
                ContentUnavailableView("Select a demo", systemImage: "sparkles")
            }
        }
    }
}
```

The search uses the same rules as the gallery: every word of the query
must appear in the demo's title, summary or API list, ignoring case and
diacritics.

## Open a demo from a link

Every demo has a stable identifier, its ``ShowcaseDemo/id``, for example
`chart3D`. ``ShowcaseCatalog/demo(withID:)`` returns `nil` for an unknown
identifier and for a demo that is not available on the current platform,
so a link can never open an empty screen:

```swift
let catalog = ShowcaseCatalog(platform: .macOS)
catalog.demo(withID: "chart3D")        // .chart3D
catalog.demo(withID: "sectionIndex")   // nil, the section index demo is iOS-only
catalog.demo(withID: "unknown")        // nil
```

In the browser above, handle a URL such as `myapp://demo/chart3D` by
adding this modifier to the `NavigationSplitView`:

```swift
.onOpenURL { url in
    selection = catalog.demo(withID: url.lastPathComponent)
}
```

``ShowcaseGallery/init(initialDemo:)`` does the same for the ready-made
gallery: it opens the demo on appear, and ignores demos that are not
available on the current platform.

## Check what runs where

``ShowcaseDemo/isAvailable(on:)`` tells you whether a demo runs on a
platform without creating a catalog. The macOS catalog has 14 demos; the
iOS catalog has all 16.

```swift
ShowcaseDemo.allCases.filter { !$0.isAvailable(on: .macOS) }
// [.tabBarMinimize, .sectionIndex]
```
