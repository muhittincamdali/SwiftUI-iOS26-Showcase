# Contributing

Thanks for helping with SwiftUI iOS 26 Showcase. Bug reports, fixes and new demos are welcome.

The [shared contributing guide](https://github.com/muhittincamdali/.github/blob/main/CONTRIBUTING.md)
covers branches, commit messages and README translations for all of these repositories. This
file adds the steps that are specific to this package.

## Before you start

For a new demo, open an issue first and name the iOS 26 or macOS 26 API it covers. Each demo
should focus on one API area, have controls for that API's main options, and run on the
platforms listed in its metadata.

## Development setup

You need Xcode 26.1 or later (the tab bar demo uses an iOS 26.1 API).

```bash
git clone https://github.com/muhittincamdali/SwiftUI-iOS26-Showcase.git
cd SwiftUI-iOS26-Showcase
swift build
swift test
```

To run the tests in the iOS Simulator:

```bash
xcodebuild test -scheme SwiftUIiOS26Showcase -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

The example app lives in `Examples/ShowcaseApp`. After changing `project.yml`, regenerate the
Xcode project with `xcodegen generate --spec project.yml` from that folder.

## Adding a demo

1. Add a case to `ShowcaseDemo` and fill in its metadata: title, summary, SF Symbol, category,
   the APIs it uses and, if needed, its platforms.
2. Add the view under `Sources/SwiftUIiOS26Showcase/Demos/<Category>/`. Most demos use
   `DemoPage`, which adds the summary and the list of APIs.
3. Return the view from `ShowcaseDemoView`.
4. Add a row to the demo table in `README.md`. A test checks that the table matches the catalog.
   The translated READMEs are updated in a follow-up; CI marks them as behind until then.
5. If the demo is built on a `List` instead of `DemoPage`, add it to `listDemos` in
   `RenderingTests.swift`; `ImageRenderer` does not draw lists, so the rendering test skips them.
6. Move logic that does not need a view (parsing, formatting, math) into a separate type and
   test it with Swift Testing.

## Pull requests

- Keep each pull request to one change, and make sure `swift test` passes on macOS and in the
  iOS Simulator.
- If you change a code sample in `README.md` or in the DocC catalog, update the copy in
  `Tests/SwiftUIiOS26ShowcaseTests/ReadmeExamplesTests.swift`.
- Run `swiftlint` from the repository root; the configuration is in `.swiftlint.yml`.
- If you add or change a demo screen that appears in `docs/images`, regenerate the screenshots
  with `scripts/screenshots.sh`.
- Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/), for
  example `feat: add a variant picker to the symbol draw demo` or `fix: keep the web view address on reload`.

## Code of conduct

This project follows the
[shared code of conduct](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md).

## License

By contributing, you agree that your contributions are licensed under the MIT License.
