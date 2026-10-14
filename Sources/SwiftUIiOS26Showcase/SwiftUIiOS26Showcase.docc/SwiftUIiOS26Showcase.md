# ``SwiftUIiOS26Showcase``

Small, runnable demos of the SwiftUI and framework APIs introduced in iOS 26 and macOS 26.

## Overview

The package contains one SwiftUI screen per API area: Liquid Glass, the new
bar and navigation modifiers, scroll edge effects, rich text editing, the
native web view, 3D charts, SF Symbol draw effects, the `@Animatable` macro
and the on-device Foundation Models framework.

``ShowcaseGallery`` lists the demos available on the current platform,
grouped by ``ShowcaseCategory`` and searchable by title, summary or API name.
``ShowcaseDemoView`` shows a single ``ShowcaseDemo``, so you can embed one
screen in your own app.

The search, grouping and lookup logic lives in ``ShowcaseCatalog`` and has
no SwiftUI dependency. The helpers behind individual demos are public as
well, so they can be tested and reused: ``WebAddress`` validates what the
user types into the web view's address bar, ``RichTextFormatter`` toggles
character styles in an `AttributedString`, and ``SurfaceFunction`` provides
the heights for the 3D chart.

## Topics

### Essentials

- <doc:GettingStarted>
- ``ShowcaseGallery``
- ``ShowcaseDemoView``

### Catalog

- ``ShowcaseDemo``
- ``ShowcaseCategory``
- ``ShowcasePlatform``
- ``ShowcaseCatalog``

### Demo helpers

- ``WebAddress``
- ``RichTextFormatter``
- ``RichTextStyle``
- ``SurfaceFunction``
