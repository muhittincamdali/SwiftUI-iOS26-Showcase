// MARK: - ContentView.swift
// iOS 26 SwiftUI Showcase - Main Navigation
// Created by Muhittin Camdali

import SwiftUI

// MARK: - Main Content View

@available(iOS 26.0, macOS 26.0, *)
public struct ContentView: View {
    @State private var selectedCategory: FeatureCategory?
    @State private var searchText = ""
    
    public init() {}
    
    public var body: some View {
        NavigationSplitView {
            // Sidebar
            List(selection: $selectedCategory) {
                ForEach(FeatureCategory.allCases) { category in
                    NavigationLink(value: category) {
                        Label(category.title, systemImage: category.icon)
                    }
                }
            }
            .navigationTitle("iOS 26")
            .searchable(text: $searchText, prompt: "Search features")
        } detail: {
            if let category = selectedCategory {
                CategoryDetailView(category: category)
            } else {
                WelcomeView()
            }
        }
    }
}

// MARK: - Feature Category

@available(iOS 26.0, *)
public enum FeatureCategory: String, CaseIterable, Identifiable {
    case liquidGlass = "Liquid Glass"
    case swiftUI = "SwiftUI"
    case navigation = "Navigation"
    case controls = "Controls"
    case animations = "Animations"
    case ai = "AI & ML"
    case comparison = "iOS 17 vs 26"
    
    public var id: String { rawValue }
    
    var title: String { rawValue }
    
    var icon: String {
        switch self {
        case .liquidGlass: return "drop.fill"
        case .swiftUI: return "swift"
        case .navigation: return "sidebar.left"
        case .controls: return "slider.horizontal.3"
        case .animations: return "wand.and.stars"
        case .ai: return "brain"
        case .comparison: return "arrow.left.arrow.right"
        }
    }
    
    var features: [Feature] {
        switch self {
        case .liquidGlass:
            return [
                Feature(name: "Glass Effect", icon: "rectangle.on.rectangle", view: .glassEffect),
                Feature(name: "Glass Container", icon: "square.3.layers.3d", view: .glassContainer),
                Feature(name: "Glass Effect ID", icon: "arrow.triangle.swap", view: .glassEffectID),
                Feature(name: "Interactive Glass", icon: "hand.tap", view: .interactiveGlass),
            ]
        case .swiftUI:
            return [
                Feature(name: "WebView", icon: "globe", view: .webView),
                Feature(name: "Rich Text Editor", icon: "doc.richtext", view: .richTextEditor),
                Feature(name: "3D Charts", icon: "chart.bar.xaxis", view: .chart3D),
                Feature(name: "Section Index", icon: "list.bullet.indent", view: .sectionIndex),
                Feature(name: "Label Spacing", icon: "textformat.size", view: .labelSpacing),
            ]
        case .navigation:
            return [
                Feature(name: "TabView Minimize", icon: "dock.rectangle", view: .tabViewMinimize),
                Feature(name: "Navigation Subtitle", icon: "text.below.photo", view: .navigationSubtitle),
                Feature(name: "Background Extension", icon: "rectangle.expand.vertical", view: .backgroundExtension),
                Feature(name: "Scroll Edge Effect", icon: "rectangle.and.text.magnifyingglass", view: .scrollEdgeEffect),
            ]
        case .controls:
            return [
                Feature(name: "Toolbar Spacer", icon: "rectangle.split.3x1", view: .toolbarSpacer),
                Feature(name: "SF Symbols Draw", icon: "sparkles", view: .sfSymbolsDraw),
                Feature(name: "New Buttons", icon: "button.horizontal", view: .newButtons),
                Feature(name: "Sliders & Pickers", icon: "slider.horizontal.below.rectangle", view: .slidersPickers),
            ]
        case .animations:
            return [
                Feature(name: "@Animatable Macro", icon: "wand.and.rays", view: .animatableMacro),
                Feature(name: "Sheet Morphing", icon: "rectangle.portrait.on.rectangle.portrait", view: .sheetMorphing),
                Feature(name: "Symbol Effects", icon: "star.fill", view: .symbolEffects),
            ]
        case .ai:
            return [
                Feature(name: "Foundation Models", icon: "cpu", view: .foundationModels),
                Feature(name: "Text Generation", icon: "text.bubble", view: .textGeneration),
            ]
        case .comparison:
            return [
                Feature(name: "Full Comparison", icon: "arrow.left.arrow.right.circle", view: .fullComparison),
            ]
        }
    }
}

// MARK: - Feature

@available(iOS 26.0, *)
struct Feature: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let view: FeatureView
}

@available(iOS 26.0, *)
enum FeatureView {
    case glassEffect
    case glassContainer
    case glassEffectID
    case interactiveGlass
    case webView
    case richTextEditor
    case chart3D
    case sectionIndex
    case labelSpacing
    case tabViewMinimize
    case navigationSubtitle
    case backgroundExtension
    case scrollEdgeEffect
    case toolbarSpacer
    case sfSymbolsDraw
    case newButtons
    case slidersPickers
    case animatableMacro
    case sheetMorphing
    case symbolEffects
    case foundationModels
    case textGeneration
    case fullComparison
}

// MARK: - Category Detail View

@available(iOS 26.0, *)
struct CategoryDetailView: View {
    let category: FeatureCategory
    
    var body: some View {
        NavigationStack {
            List(category.features) { feature in
                NavigationLink {
                    featureView(for: feature.view)
                } label: {
                    Label(feature.name, systemImage: feature.icon)
                }
            }
            .navigationTitle(category.title)
        }
    }
    
    @ViewBuilder
    private func featureView(for view: FeatureView) -> some View {
        switch view {
        case .glassEffect:
            GlassBasicDemo()
        case .glassContainer:
            GlassEffectContainerDemo()
        case .glassEffectID:
            GlassEffectIDShowcase()
        case .interactiveGlass:
            GlassButtonsDemo()
        case .webView:
            WebViewShowcase()
        case .richTextEditor:
            RichTextEditorShowcase()
        case .chart3D:
            Chart3DShowcase()
        case .sectionIndex:
            SectionIndexLabelsShowcase()
        case .labelSpacing:
            LabelSpacingShowcase()
        case .tabViewMinimize:
            TabViewMinimizeShowcase()
        case .navigationSubtitle:
            NavigationSubtitleShowcase()
        case .backgroundExtension:
            BackgroundExtensionEffectShowcase()
        case .scrollEdgeEffect:
            ScrollEdgeEffectShowcase()
        case .toolbarSpacer:
            ToolbarSpacerShowcase()
        case .sfSymbolsDraw:
            SFSymbolsDrawShowcase()
        case .newButtons:
            NewButtonsDemo()
        case .slidersPickers:
            SlidersPickersDemo()
        case .animatableMacro:
            AnimatableMacroShowcase()
        case .sheetMorphing:
            SheetMorphingDemo()
        case .symbolEffects:
            VariableValueDemo()
        case .foundationModels:
            FoundationModelsDemo()
        case .textGeneration:
            TextGenerationDemo()
        case .fullComparison:
            iOS17vs26ComparisonView()
        }
    }
}

// MARK: - Welcome View

@available(iOS 26.0, *)
struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "swift")
                .font(.system(size: 80))
                .foregroundStyle(.orange.gradient)
            
            Text("iOS 26 SwiftUI Showcase")
                .font(.largeTitle.bold())
            
            Text("Select a category from the sidebar to explore new iOS 26 features")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            // Feature highlights
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                HighlightCard(title: "Liquid Glass", icon: "drop.fill", color: .blue)
                HighlightCard(title: "WebView", icon: "globe", color: .green)
                HighlightCard(title: "3D Charts", icon: "chart.bar.xaxis", color: .orange)
                HighlightCard(title: "@Animatable", icon: "wand.and.rays", color: .purple)
            }
            .padding(.horizontal, 40)
        }
        .padding()
    }
}

@available(iOS 26.0, *)
struct HighlightCard: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundStyle(color)
            
            Text(title)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Placeholder Views

@available(iOS 26.0, *)
struct GlassBasicDemo: View {
    var body: some View {
        Text("Glass Basic Demo")
            .navigationTitle("Glass Effect")
    }
}

@available(iOS 26.0, *)
struct GlassEffectContainerDemo: View {
    var body: some View {
        Text("Glass Container Demo")
            .navigationTitle("Glass Container")
    }
}

@available(iOS 26.0, *)
struct GlassButtonsDemo: View {
    var body: some View {
        Text("Glass Buttons Demo")
            .navigationTitle("Interactive Glass")
    }
}

@available(iOS 26.0, *)
struct NewButtonsDemo: View {
    var body: some View {
        Text("New Buttons Demo")
            .navigationTitle("New Buttons")
    }
}

@available(iOS 26.0, *)
struct SlidersPickersDemo: View {
    var body: some View {
        Text("Sliders Pickers Demo")
            .navigationTitle("Sliders & Pickers")
    }
}

@available(iOS 26.0, *)
struct FoundationModelsDemo: View {
    var body: some View {
        Text("Foundation Models Demo")
            .navigationTitle("Foundation Models")
    }
}

@available(iOS 26.0, *)
struct TextGenerationDemo: View {
    var body: some View {
        Text("Text Generation Demo")
            .navigationTitle("Text Generation")
    }
}

@available(iOS 26.0, *)
struct iOS17vs26ComparisonView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("iOS 17 vs iOS 26")
                    .font(.largeTitle.bold())
                
                ComparisonSection(
                    title: "WebView",
                    ios17: "UIViewRepresentable wrapper",
                    ios26: "Native SwiftUI WebView"
                )
                
                ComparisonSection(
                    title: "Rich Text",
                    ios17: "Plain TextEditor only",
                    ios26: "AttributedString support"
                )
                
                ComparisonSection(
                    title: "Charts",
                    ios17: "2D charts only",
                    ios26: "3D charts with Chart3D"
                )
                
                ComparisonSection(
                    title: "Animations",
                    ios17: "Manual animatableData",
                    ios26: "@Animatable macro"
                )
                
                ComparisonSection(
                    title: "TabView",
                    ios17: "Static tab bar",
                    ios26: "Minimize on scroll"
                )
                
                ComparisonSection(
                    title: "Labels",
                    ios17: "No spacing control",
                    ios26: "labelIconToTitleSpacing"
                )
            }
            .padding()
        }
        .navigationTitle("Comparison")
    }
}

@available(iOS 26.0, *)
struct ComparisonSection: View {
    let title: String
    let ios17: String
    let ios26: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "17.circle.fill")
                            .foregroundStyle(.orange)
                        Text("iOS 17")
                            .font(.caption.bold())
                    }
                    Text(ios17)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.orange.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "26.circle.fill")
                            .foregroundStyle(.green)
                        Text("iOS 26")
                            .font(.caption.bold())
                    }
                    Text(ios26)
                        .font(.caption)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.green.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}

// MARK: - Preview

#Preview {
    if #available(iOS 26.0, *) {
        ContentView()
    }
}
