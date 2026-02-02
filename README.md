# 🔮 SwiftUI iOS 26 Showcase

[![Swift](https://img.shields.io/badge/Swift-6.2-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2026-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-6.0-purple.svg)](https://developer.apple.com/swiftui/)

A comprehensive collection of **50+ interactive demos** showcasing every major new feature in iOS 26, including **Liquid Glass**, new SwiftUI APIs, Foundation Models framework, Swift 6.2 concurrency, and multi-platform support.

---

## ✨ What's Inside

This showcase covers the most exciting additions to the Apple developer platform in 2025-2026:

### 🧊 Liquid Glass (5 demos)
| Demo | Description |
|------|-------------|
| **GlassBasicDemo** | Core `.glassEffect()` modifier with blur, tint, and opacity controls |
| **GlassEffectContainerDemo** | Container-based glass groups with shared backgrounds |
| **GlassNavigationDemo** | Navigation bars with glass material styling |
| **GlassTabBarDemo** | Tab bars rendered with translucent glass effects |
| **GlassCardDemo** | Card components with frosted glass appearance |

### 🎨 SwiftUI Enhancements (4 demos)
| Demo | Description |
|------|-------------|
| **MeshGradientDemo** | 2D mesh gradients with interactive control points |
| **ScrollViewDemo** | Scroll position tracking, paging, and custom transitions |
| **AnimationDemo** | Spring animations, phase animators, and keyframe animations |
| **NavigationDemo** | NavigationStack with zoom transitions and custom paths |

### 🤖 On-Device Intelligence (2 demos)
| Demo | Description |
|------|-------------|
| **FoundationModelsDemo** | On-device language model integration with structured output |
| **TextGenerationDemo** | Streaming text generation with temperature and token controls |

### ⚡ Swift 6.2 (2 demos)
| Demo | Description |
|------|-------------|
| **ConcurrencyDemo** | Async/await patterns, task groups, and actor isolation |
| **TypedThrowsDemo** | Typed throws with exhaustive error handling |

### 🥽 Platform (1 demo)
| Demo | Description |
|------|-------------|
| **VisionOSDemo** | Volumetric content and immersive space entry points |

---

## 📱 Screenshots

### App Structure

```
┌─────────────────────────────┐
│     SwiftUI iOS 26 Showcase │
├─────────────────────────────┤
│                             │
│  ┌─────┐ ┌─────┐ ┌─────┐  │
│  │Glass│ │Mesh │ │Anim │  │
│  │Demo │ │Grad │ │Demo │  │
│  └─────┘ └─────┘ └─────┘  │
│                             │
│  ┌─────┐ ┌─────┐ ┌─────┐  │
│  │Nav  │ │ FM  │ │Swift│  │
│  │Demo │ │Demo │ │ 6.2 │  │
│  └─────┘ └─────┘ └─────┘  │
│                             │
├─────────────────────────────┤
│ 🧊 Glass │ 🎨 UI │ 🤖 ML  │
└─────────────────────────────┘
```

---

## 🚀 Getting Started

### Requirements

| Requirement | Minimum |
|-------------|---------|
| Xcode | 26.0+ |
| iOS | 16.0+ (some demos require 26) |
| macOS | 13.0+ |
| Swift | 5.9+ |

### Installation

#### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(
        url: "https://github.com/muhittincamdali/SwiftUI-iOS26-Showcase.git",
        from: "1.0.0"
    )
]
```

#### Clone & Run

```bash
git clone https://github.com/muhittincamdali/SwiftUI-iOS26-Showcase.git
cd SwiftUI-iOS26-Showcase
open Package.swift
```

---

## 🏗️ Project Structure

```
Sources/SwiftUIiOS26Showcase/
├── App/
│   ├── ShowcaseApp.swift          # App entry point
│   └── ContentView.swift          # Main tab navigation
├── LiquidGlass/
│   ├── GlassBasicDemo.swift       # Basic glass effect
│   ├── GlassEffectContainerDemo.swift  # Container grouping
│   ├── GlassNavigationDemo.swift  # Nav bar glass
│   ├── GlassTabBarDemo.swift      # Tab bar glass
│   └── GlassCardDemo.swift        # Card glass
├── SwiftUI/
│   ├── MeshGradientDemo.swift     # Mesh gradients
│   ├── ScrollViewDemo.swift       # Scroll enhancements
│   ├── AnimationDemo.swift        # New animation APIs
│   └── NavigationDemo.swift       # Navigation transitions
├── AI/
│   ├── FoundationModelsDemo.swift # On-device models
│   └── TextGenerationDemo.swift   # Text generation
├── Swift62/
│   ├── ConcurrencyDemo.swift      # Async patterns
│   └── TypedThrowsDemo.swift      # Typed throws
├── Platform/
│   └── VisionOSDemo.swift         # visionOS features
└── Shared/
    ├── DemoCard.swift             # Reusable card component
    └── CodeSnippetView.swift      # Code display view
```

---

## 🧊 Liquid Glass Deep Dive

Liquid Glass is the headline visual feature of iOS 26. Here's how each demo explores it:

### Basic Glass Effect

```swift
Rectangle()
    .fill(.ultraThinMaterial)
    .glassEffect()
    .frame(width: 200, height: 200)
```

The `.glassEffect()` modifier adds a translucent, depth-aware glass appearance to any view. It responds to the content behind it, creating a realistic frosted glass look.

### Glass Effect Container

```swift
GlassEffectContainer {
    HStack {
        Image(systemName: "star.fill")
            .glassEffect()
        Text("Grouped Glass")
            .glassEffect()
    }
}
```

Containers allow multiple glass elements to share a common background, reducing overdraw and creating cohesive grouped visuals.

### Glass Navigation

```swift
NavigationStack {
    List { ... }
    .navigationTitle("Glass Nav")
    .toolbarBackgroundVisibility(.visible, for: .navigationBar)
    .toolbarGlassEffect(.regular, for: .navigationBar)
}
```

---

## 🎨 SwiftUI Highlights

### Mesh Gradient

```swift
MeshGradient(
    width: 3, height: 3,
    points: [
        [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
        [0.0, 0.5], [0.5, 0.5], [1.0, 0.5],
        [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
    ],
    colors: [
        .red, .orange, .yellow,
        .green, .blue, .purple,
        .pink, .mint, .cyan
    ]
)
```

### Phase Animator

```swift
PhaseAnimator([false, true]) { content, phase in
    content
        .scaleEffect(phase ? 1.2 : 1.0)
        .rotationEffect(.degrees(phase ? 360 : 0))
}
```

---

## 🤖 Foundation Models

iOS 26 brings on-device language models. The showcase demonstrates:

- **Structured output** with `@Generable` conformance
- **Streaming responses** with `AsyncSequence`
- **Temperature control** for creativity tuning
- **Token limits** for response length management

```swift
let session = LanguageModelSession()
let response = try await session.respond(
    to: "Explain SwiftUI in one sentence"
)
print(response.content)
```

---

## ⚡ Swift 6.2 Features

### Typed Throws

```swift
enum NetworkError: Error {
    case timeout
    case invalidResponse
}

func fetchData() throws(NetworkError) -> Data {
    // compiler enforces only NetworkError can be thrown
}
```

### Concurrency Improvements

```swift
func processItems(_ items: [Item]) async -> [Result] {
    await withTaskGroup(of: Result.self) { group in
        for item in items {
            group.addTask { await process(item) }
        }
        return await group.reduce(into: []) { $0.append($1) }
    }
}
```

---

## 🧩 Shared Components

### DemoCard

A reusable card component used throughout the showcase:

```swift
DemoCard(
    title: "Glass Effect",
    subtitle: "iOS 26",
    systemImage: "sparkles",
    gradient: .blue
) {
    // Demo content
}
```

### CodeSnippetView

Displays syntax-highlighted code samples inline:

```swift
CodeSnippetView(
    code: "Text(\"Hello\").glassEffect()",
    language: "swift"
)
```

---

## 🗺️ Roadmap

- [x] Liquid Glass demos
- [x] SwiftUI enhancement demos
- [x] Foundation Models integration
- [x] Swift 6.2 concurrency demos
- [x] visionOS support
- [ ] watchOS complications demo
- [ ] Widget extensions showcase
- [ ] Interactive Live Activities demo
- [ ] CarPlay integration example
- [ ] Mac Catalyst adaptations

---

## 🤝 Contributing

Contributions are welcome! Here's how:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-demo`)
3. Write your demo following the existing patterns
4. Commit your changes (`git commit -m 'feat: add amazing demo'`)
5. Push to the branch (`git push origin feature/amazing-demo`)
6. Open a Pull Request

### Code Style

- Follow SwiftLint rules (`.swiftlint.yml`)
- Use `// MARK: -` sections for organization
- Add inline documentation for public APIs
- Keep demos self-contained and focused

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Apple's WWDC25 sessions and documentation
- The SwiftUI community for feedback and inspiration
- Open-source contributors who help improve this showcase

---

**Built with ❤️ for the iOS developer community**
