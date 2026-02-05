<p align="center">
  <img src="https://img.shields.io/badge/iOS-26-blue?style=for-the-badge&logo=apple" alt="iOS 26"/>
  <img src="https://img.shields.io/badge/Swift-6.2-orange?style=for-the-badge&logo=swift" alt="Swift 6.2"/>
  <img src="https://img.shields.io/badge/Xcode-26-blue?style=for-the-badge&logo=xcode" alt="Xcode 26"/>
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="MIT License"/>
</p>

<h1 align="center">🍎 SwiftUI iOS 26 Showcase</h1>

<p align="center">
  <strong>The most comprehensive iOS 26 feature showcase on GitHub</strong><br>
  <em>60+ production-ready examples • Liquid Glass • WebView • 3D Charts • @Animatable & more</em>
</p>

<p align="center">
  <a href="#-whats-new-in-ios-26">What's New</a> •
  <a href="#-features">Features</a> •
  <a href="#-installation">Installation</a> •
  <a href="#-code-examples">Code Examples</a> •
  <a href="#-migration-guide">Migration</a>
</p>

---

## 🆕 What's New in iOS 26

iOS 26 introduces **Liquid Glass**, a revolutionary design system, along with dozens of new SwiftUI APIs. This showcase provides working examples for every major feature.

```
┌─────────────────────────────────────────────────────────────────────┐
│                        iOS 26 Feature Map                           │
├─────────────────────────────────────────────────────────────────────┤
│  🔮 Liquid Glass          │  📱 SwiftUI Views        │  🎨 Design  │
│  ├─ glassEffect()         │  ├─ WebView (Native!)    │  ├─ Buttons │
│  ├─ GlassEffectContainer  │  ├─ Rich TextEditor      │  ├─ Sliders │
│  ├─ glassEffectID()       │  ├─ Chart3D              │  ├─ Toggles │
│  └─ Interactive Glass     │  └─ SectionIndexLabel    │  └─ Menus   │
├─────────────────────────────────────────────────────────────────────┤
│  🧭 Navigation            │  ⚡ Performance          │  🤖 AI      │
│  ├─ TabView Minimize      │  ├─ @Animatable Macro    │  ├─ Found.  │
│  ├─ Navigation Subtitle   │  ├─ Sheet Morphing       │  │  Models  │
│  ├─ Background Extension  │  └─ Symbol Draw Effect   │  └─ On-Dev. │
│  └─ Scroll Edge Effect    │                          │     AI      │
└─────────────────────────────────────────────────────────────────────┘
```

## ✨ Features

### 🔮 Liquid Glass
The heart of iOS 26's new design language.

| Feature | Description | Status |
|---------|-------------|--------|
| `glassEffect()` | Apply translucent glass to any view | ✅ |
| `GlassEffectContainer` | Group glass elements for consistent sampling | ✅ |
| `glassEffectID()` | Morphing transitions between glass elements | ✅ |
| Interactive Glass | Scale, bounce, shimmer on interaction | ✅ |
| Tinted Glass | Apply semantic colors to glass | ✅ |

### 📱 New SwiftUI Views

| Feature | iOS 17 | iOS 26 |
|---------|--------|--------|
| **WebView** | ❌ UIViewRepresentable | ✅ Native SwiftUI |
| **Rich TextEditor** | ❌ Plain text only | ✅ AttributedString |
| **3D Charts** | ❌ Not available | ✅ Chart3D, SurfacePlot |
| **Section Index** | ❌ UIKit wrapper | ✅ sectionIndexLabel |
| **Label Spacing** | ❌ Manual HStack | ✅ labelReservedIconWidth |

### 🧭 Navigation Updates

| Feature | Description |
|---------|-------------|
| TabView Minimize | Tab bar collapses on scroll |
| Bottom Accessory | Add views above tab bar |
| Navigation Subtitle | Secondary text under title |
| Background Extension | Extend images beyond safe area |
| Scroll Edge Effect | Blur/fade under toolbars |

### ⚡ Animation & Performance

| Feature | Benefit |
|---------|---------|
| `@Animatable` Macro | No more manual animatableData |
| Sheet Morphing | Sheets animate from buttons |
| SF Symbol Draw | Hand-drawn animation effect |
| Variable + Draw | Combined symbol effects |

## 🚀 Installation

### Requirements

| Requirement | Version |
|-------------|---------|
| iOS | 26.0+ |
| macOS | Tahoe 26+ |
| Xcode | 26+ |
| Swift | 6.2+ |

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftUI-iOS26-Showcase.git", from: "2.0.0")
]
```

### Clone & Run

```bash
git clone https://github.com/muhittincamdali/SwiftUI-iOS26-Showcase.git
cd SwiftUI-iOS26-Showcase
open Package.swift
# Select iOS 26 Simulator and Run
```

## 💻 Code Examples

### Liquid Glass Effect

```swift
// Basic glass effect
Text("Hello, Liquid Glass!")
    .padding()
    .glassEffect()

// Custom shape
Button("Action") { }
    .glassEffect(.rect(cornerRadius: 12))

// Interactive glass (for controls)
Button("Interactive") { }
    .glassEffect(.capsule, isInteractive: true)

// Tinted glass
Image(systemName: "star.fill")
    .glassEffect()
    .tint(.yellow)
```

### Native WebView

```swift
// iOS 26: Native SwiftUI WebView - no wrappers!
WebView(url: URL(string: "https://apple.com")!)
    .webViewNavigationDelegate(
        didStartLoading: { isLoading = true },
        didFinishLoading: { isLoading = false }
    )

// In-app browser via openURL
@Environment(\.openURL) var openURL

Button("Open Link") {
    openURL(url, inApp: true) // NEW: inApp parameter
}
```

### Rich Text Editor

```swift
@State private var attributedText = AttributedString()

TextEditor(text: $attributedText)
    .textEditorStyle(.richText)
    .richTextToolbar(.visible)
```

### 3D Charts

```swift
Chart3D {
    SurfacePlot(data: surfaceData) { point in
        SurfaceMark(
            x: .value("X", point.x),
            y: .value("Y", point.y),
            z: .value("Z", point.z)
        )
    }
}
.chart3DRotation(x: .degrees(15), y: .degrees(45))
```

### TabView Minimize

```swift
TabView {
    Tab("Home", systemImage: "house") {
        HomeView()
    }
    Tab("Search", systemImage: "magnifyingglass") {
        SearchView()
    }
}
.tabBarMinimizeBehavior(.onScrollDown)
.tabViewBottomAccessory {
    NowPlayingBar()
}
```

### @Animatable Macro

```swift
// iOS 17: Manual animatableData 😫
struct OldWay: Shape {
    var progress: Double
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
    // ...
}

// iOS 26: Just add @Animatable! 🎉
@Animatable
struct NewWay: Shape {
    var progress: Double
    // That's it! No animatableData needed
}
```

### Section Index Labels

```swift
List {
    ForEach(sortedSections, id: \.self) { letter in
        Section(letter) {
            // Content
        }
        .sectionIndexLabel(Text(letter))
    }
}
.listSectionIndexVisibility(.automatic)
```

### Label Spacing

```swift
// Align labels with different icon widths
Label("Settings", systemImage: "gearshape")
    .labelReservedIconWidth(28)
    .labelIconToTitleSpacing(12)
```

## 📖 Migration Guide

### From iOS 17 to iOS 26

<details>
<summary><strong>WebView Migration</strong></summary>

```swift
// ❌ iOS 17: UIViewRepresentable wrapper
struct WebView: UIViewRepresentable {
    let url: URL
    func makeUIView(context: Context) -> WKWebView { ... }
    func updateUIView(_ uiView: WKWebView, context: Context) { ... }
}

// ✅ iOS 26: Native SwiftUI
WebView(url: URL(string: "https://apple.com")!)
```

</details>

<details>
<summary><strong>Rich Text Migration</strong></summary>

```swift
// ❌ iOS 17: Plain text only
TextEditor(text: $plainText)

// ✅ iOS 26: Rich text with AttributedString
TextEditor(text: $attributedText)
    .textEditorStyle(.richText)
```

</details>

<details>
<summary><strong>Animation Migration</strong></summary>

```swift
// ❌ iOS 17: Manual animatableData
struct ProgressRing: Shape {
    var progress: Double
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
}

// ✅ iOS 26: @Animatable macro
@Animatable
struct ProgressRing: Shape {
    var progress: Double
}
```

</details>

<details>
<summary><strong>TabView Migration</strong></summary>

```swift
// ❌ iOS 17: Static tab bar
TabView { ... }

// ✅ iOS 26: Minimizing tab bar with accessory
TabView { ... }
    .tabBarMinimizeBehavior(.onScrollDown)
    .tabViewBottomAccessory { MiniPlayer() }
```

</details>

## 📂 Project Structure

```
SwiftUI-iOS26-Showcase/
├── Sources/
│   └── SwiftUIiOS26Showcase/
│       ├── App/
│       │   ├── ShowcaseApp.swift
│       │   └── ContentView.swift
│       ├── iOS26Features/
│       │   ├── WebViewDemo.swift
│       │   ├── RichTextEditorDemo.swift
│       │   ├── Chart3DDemo.swift
│       │   ├── AnimatableMacroDemo.swift
│       │   ├── TabViewMinimizeDemo.swift
│       │   ├── SectionIndexLabelsDemo.swift
│       │   ├── BackgroundExtensionEffectDemo.swift
│       │   ├── ToolbarSpacerDemo.swift
│       │   ├── ScrollEdgeEffectDemo.swift
│       │   ├── LabelSpacingDemo.swift
│       │   ├── SFSymbolsDrawDemo.swift
│       │   ├── GlassEffectIDDemo.swift
│       │   └── NavigationSubtitleDemo.swift
│       ├── LiquidGlass/
│       ├── AI/
│       └── Apps/
├── Documentation/
├── Tests/
└── Package.swift
```

## 🎯 Feature Checklist

### Liquid Glass
- [x] Basic glass effect
- [x] Glass containers
- [x] Glass morphing transitions
- [x] Interactive glass
- [x] Tinted glass

### SwiftUI Views
- [x] Native WebView
- [x] Rich TextEditor
- [x] 3D Charts
- [x] Section Index Labels
- [x] Label spacing APIs

### Navigation
- [x] TabView minimize
- [x] Bottom accessory
- [x] Navigation subtitle
- [x] Background extension
- [x] Scroll edge effect

### Controls
- [x] Toolbar spacer
- [x] Toolbar badges
- [x] New button styles
- [x] Slider tick marks
- [x] SF Symbols draw effect

### Animations
- [x] @Animatable macro
- [x] Sheet morphing
- [x] Symbol effects
- [x] Variable value + draw

## 📚 Resources

- [WWDC 2025 - What's New in SwiftUI](https://developer.apple.com/videos/play/wwdc2025/256)
- [WWDC 2025 - Build with Liquid Glass](https://developer.apple.com/videos/play/wwdc2025/323)
- [Apple Developer Documentation](https://developer.apple.com/documentation/swiftui)

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md).

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<p align="center">
  <strong>Made with ❤️ by Muhittin Camdali</strong>
</p>

<p align="center">
  <a href="https://github.com/muhittincamdali">
    <img src="https://img.shields.io/badge/GitHub-muhittincamdali-181717?style=flat-square&logo=github" alt="GitHub"/>
  </a>
</p>

<p align="center">
  <a href="https://star-history.com/#muhittincamdali/SwiftUI-iOS26-Showcase&Date">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=muhittincamdali/SwiftUI-iOS26-Showcase&type=Date&theme=dark" />
      <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=muhittincamdali/SwiftUI-iOS26-Showcase&type=Date" />
      <img alt="Star History" src="https://api.star-history.com/svg?repos=muhittincamdali/SwiftUI-iOS26-Showcase&type=Date" />
    </picture>
  </a>
</p>
