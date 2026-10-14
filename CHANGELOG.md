# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

The package was rebuilt around runnable demos. Since June 2026 it had contained only
placeholders: "enterprise" helpers (circuit breaker, retry policy, event bus) unrelated to
SwiftUI, a gallery whose only behaviour was a `print` call, and a test file referencing types
that did not exist, so the tests never compiled. The previous changelog and contributor
documents had been copied from another project.

### Added

- Sixteen demo screens for APIs introduced in iOS 26 and macOS 26: Liquid Glass effects,
  morphing and button styles; tab bar minimize and bottom accessory; toolbar spacers; navigation
  subtitles; section index labels; scroll edge effects; background extension; label icon
  spacing; the rich text `TextEditor`; `WebView` and `WebPage`; `Chart3D`; SF Symbol draw
  effects; the `@Animatable` macro; and the Foundation Models framework.
- `ShowcaseGallery`, a searchable gallery of the demos available on the current platform, and
  `ShowcaseDemoView` for showing one demo.
- `ShowcaseDemo`, `ShowcaseCategory`, `ShowcasePlatform` and `ShowcaseCatalog` for demo
  metadata, search, grouping and lookup by identifier.
- Public helpers used by the demos: `WebAddress`, `RichTextFormatter` and `SurfaceFunction`.
- Swift Testing suites that run on macOS and in the iOS Simulator. They cover catalog search
  and metadata, the public helpers, compiled README and DocC examples, a check that the README
  demo table matches the catalog, and a rendering test that every demo draws more than its
  summary and API list. `ImageRenderer` does not draw lists or `WebView`, so the two
  `List`-based demos are not rendered and the web view demo is checked only through its address
  and status bars. A separate test checks that the scroll edge demo draws its rows, because its
  picker sits outside the page content.
- An iOS and macOS example app (`Examples/ShowcaseApp`, created with XcodeGen), a screenshot
  script and simulator screenshots.
- A DocC catalog with an overview and two articles: getting started, and building your own demo
  browser with `ShowcaseCatalog`.
- The section index demo has a picker for `listSectionIndexVisibility(_:)`, and the web view
  demo lists the APIs it uses, like the other screens.
- README translations in Turkish, Simplified Chinese, Japanese, Korean, Spanish, German, French,
  Brazilian Portuguese and Russian, with a language selector, generated banner, badges and
  buttons, and a social preview image in `.github/brand/`.
- Swift Package Index configuration.

### Changed

- Requires Swift 6.2 tools, iOS 26 and macOS 26. watchOS, tvOS and visionOS are no longer
  listed, because none of the demos were built or tested there.
- CI calls the shared workflows from `muhittincamdali/.github`: SwiftPM build and test plus
  xcodebuild for iOS and macOS, DocC published to GitHub Pages, link check, wording check and
  README translation check. A separate workflow runs the tests in the iOS Simulator and builds
  the example app. Test failures are no longer ignored.
- Requires Xcode 26.1 or later, because the tab bar demo uses an iOS 26.1 API.
- The security policy prefers private vulnerability reporting, and the code of conduct is the
  shared one from `muhittincamdali/.github`.

### Removed

- The placeholder Enterprise helpers, `FeatureShowcaseView` and the old `ShowcaseGallery`.
- The CocoaPods podspec, an example file that held only a comment, and a getting started
  guide that held only a heading.

## [1.0.0] - 2026-02-03

First tagged version.

[Unreleased]: https://github.com/muhittincamdali/SwiftUI-iOS26-Showcase/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/muhittincamdali/SwiftUI-iOS26-Showcase/releases/tag/v1.0.0
