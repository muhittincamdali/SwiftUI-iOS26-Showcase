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
- Swift Testing suites (37 tests in 9 suites) that run on macOS and in the iOS Simulator,
  including a rendering test for every demo and compiled README examples.
- An iOS and macOS example app (`Examples/ShowcaseApp`, generated with XcodeGen), a screenshot
  script and simulator screenshots.
- A DocC catalog with an overview and a getting started article.
- Swift Package Index configuration.

### Changed

- Requires Swift 6.2 tools, iOS 26 and macOS 26. watchOS, tvOS and visionOS are no longer
  listed, because none of the demos were built or tested there.
- CI builds and tests on macOS and the iOS Simulator, builds the example app and the
  documentation, and no longer ignores test failures.

### Removed

- The placeholder Enterprise helpers, `FeatureShowcaseView` and the old `ShowcaseGallery`.
- The CocoaPods podspec, an example file that held only a comment, and a getting started
  guide that held only a heading.

## [1.0.0] - 2026-02-03

First tagged version.

[Unreleased]: https://github.com/muhittincamdali/SwiftUI-iOS26-Showcase/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/muhittincamdali/SwiftUI-iOS26-Showcase/releases/tag/v1.0.0
