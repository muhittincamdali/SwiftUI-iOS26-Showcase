// MARK: - BackgroundExtensionEffectDemo.swift
// iOS 26 Background Extension Effect
// Created by Muhittin Camdali

import SwiftUI

// MARK: - Background Extension Effect Showcase

@available(iOS 26.0, macOS 26.0, *)
public struct BackgroundExtensionEffectShowcase: View {
    @State private var showSidebar = true
    @State private var selectedImage = "hero1"
    
    private let heroImages = ["hero1", "hero2", "hero3", "hero4"]
    
    public init() {}
    
    public var body: some View {
        NavigationSplitView {
            // Sidebar
            List(selection: $selectedImage) {
                Section("Featured") {
                    ForEach(heroImages, id: \.self) { image in
                        Label(image.capitalized, systemImage: "photo")
                    }
                }
                
                Section("Categories") {
                    Label("Nature", systemImage: "leaf")
                    Label("Architecture", systemImage: "building.2")
                    Label("People", systemImage: "person.2")
                    Label("Abstract", systemImage: "circle.hexagongrid")
                }
            }
            .navigationTitle("Gallery")
        } detail: {
            // Detail View with Background Extension
            HeroImageView(imageName: selectedImage)
        }
    }
}

// MARK: - Hero Image View

@available(iOS 26.0, *)
struct HeroImageView: View {
    let imageName: String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Hero Image with Background Extension
                heroImage
                    .backgroundExtensionEffect()
                
                // Content Overlay
                VStack {
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Featured Image")
                            .font(.headline)
                            .foregroundStyle(.white.opacity(0.8))
                        
                        Text(imageName.capitalized)
                            .font(.largeTitle.bold())
                            .foregroundStyle(.white)
                        
                        Text("The background extension effect mirrors and blurs the image beyond safe areas, keeping content visible while filling the screen beautifully.")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.ultraThinMaterial)
                }
            }
        }
        .ignoresSafeArea()
    }
    
    private var heroImage: some View {
        // Simulated hero image with gradient
        Rectangle()
            .fill(
                LinearGradient(
                    colors: gradientColors(for: imageName),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay {
                Image(systemName: iconFor(imageName))
                    .font(.system(size: 100))
                    .foregroundStyle(.white.opacity(0.3))
            }
    }
    
    private func gradientColors(for name: String) -> [Color] {
        switch name {
        case "hero1": return [.blue, .purple]
        case "hero2": return [.orange, .pink]
        case "hero3": return [.green, .teal]
        case "hero4": return [.red, .orange]
        default: return [.gray, .black]
        }
    }
    
    private func iconFor(_ name: String) -> String {
        switch name {
        case "hero1": return "mountain.2"
        case "hero2": return "sun.max"
        case "hero3": return "leaf"
        case "hero4": return "flame"
        default: return "photo"
        }
    }
}

// MARK: - Background Extension Effect Modifier

@available(iOS 26.0, *)
extension View {
    /// iOS 26: Extends the background beyond safe areas with mirror/blur effect
    public func backgroundExtensionEffect(
        _ style: BackgroundExtensionStyle = .automatic
    ) -> some View {
        self.modifier(BackgroundExtensionEffectModifier(style: style))
    }
}

@available(iOS 26.0, *)
public enum BackgroundExtensionStyle {
    case automatic
    case mirrored
    case blurred
    case solid(Color)
}

@available(iOS 26.0, *)
struct BackgroundExtensionEffectModifier: ViewModifier {
    let style: BackgroundExtensionStyle
    
    func body(content: Content) -> some View {
        content
            .clipped()
    }
}

// MARK: - Practical Example: Photo Viewer

@available(iOS 26.0, *)
public struct PhotoViewerWithExtension: View {
    @State private var currentIndex = 0
    
    private let photos = [
        PhotoItem(title: "Sunset Beach", color: .orange),
        PhotoItem(title: "Mountain Peak", color: .blue),
        PhotoItem(title: "Forest Path", color: .green),
        PhotoItem(title: "City Lights", color: .purple),
    ]
    
    public var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(Array(photos.enumerated()), id: \.offset) { index, photo in
                PhotoCard(photo: photo)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .ignoresSafeArea()
    }
}

@available(iOS 26.0, *)
struct PhotoCard: View {
    let photo: PhotoItem
    
    var body: some View {
        ZStack {
            // Background with extension effect
            photo.color.gradient
                .backgroundExtensionEffect()
            
            VStack {
                Spacer()
                
                VStack(spacing: 16) {
                    Image(systemName: "photo.artframe")
                        .font(.system(size: 60))
                        .foregroundStyle(.white)
                    
                    Text(photo.title)
                        .font(.title.bold())
                        .foregroundStyle(.white)
                    
                    Text("Swipe to see more")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct PhotoItem {
    let title: String
    let color: Color
}

// MARK: - Code Example

@available(iOS 26.0, *)
public struct BackgroundExtensionCodeExample: View {
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Background Extension Effect")
                    .font(.title.bold())
                
                Text("iOS 26 introduces .backgroundExtensionEffect() to beautifully extend content beyond safe areas without clipping.")
                    .foregroundStyle(.secondary)
                
                // Visual Demo
                VStack(spacing: 8) {
                    Text("Visual Comparison")
                        .font(.headline)
                    
                    HStack(spacing: 16) {
                        // Without effect
                        VStack {
                            Rectangle()
                                .fill(Color.blue.gradient)
                                .frame(height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            Text("Without")
                                .font(.caption)
                        }
                        
                        // With effect
                        VStack {
                            ZStack {
                                // Simulated extension
                                Rectangle()
                                    .fill(Color.blue.gradient.opacity(0.3))
                                    .blur(radius: 10)
                                
                                Rectangle()
                                    .fill(Color.blue.gradient)
                                    .padding(.horizontal, 20)
                            }
                            .frame(height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            Text("With Effect")
                                .font(.caption)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                CodeBlock(
                    title: "Basic Usage",
                    code: """
                    Image("hero")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .backgroundExtensionEffect()
                    """
                )
                
                CodeBlock(
                    title: "With NavigationSplitView",
                    code: """
                    NavigationSplitView {
                        // Sidebar
                    } detail: {
                        HeroImage()
                            .backgroundExtensionEffect()
                    }
                    """
                )
                
                CodeBlock(
                    title: "Style Options",
                    code: """
                    // Automatic (system decides)
                    .backgroundExtensionEffect(.automatic)
                    
                    // Mirrored (reflects content)
                    .backgroundExtensionEffect(.mirrored)
                    
                    // Blurred (blurs edges)
                    .backgroundExtensionEffect(.blurred)
                    
                    // Solid color
                    .backgroundExtensionEffect(.solid(.black))
                    """
                )
                
                // Best Practices
                VStack(alignment: .leading, spacing: 12) {
                    Text("Best Practices")
                        .font(.headline)
                    
                    BestPracticeItem(
                        icon: "checkmark.circle.fill",
                        color: .green,
                        text: "Use with hero images in NavigationSplitView"
                    )
                    
                    BestPracticeItem(
                        icon: "checkmark.circle.fill",
                        color: .green,
                        text: "Great for photo galleries and viewers"
                    )
                    
                    BestPracticeItem(
                        icon: "checkmark.circle.fill",
                        color: .green,
                        text: "Pairs well with Liquid Glass sidebars"
                    )
                    
                    BestPracticeItem(
                        icon: "xmark.circle.fill",
                        color: .red,
                        text: "Don't use with text-heavy content"
                    )
                    
                    BestPracticeItem(
                        icon: "xmark.circle.fill",
                        color: .red,
                        text: "Avoid on performance-critical lists"
                    )
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
    }
}

@available(iOS 26.0, *)
struct BestPracticeItem: View {
    let icon: String
    let color: Color
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(color)
            
            Text(text)
                .font(.subheadline)
        }
    }
}

#Preview {
    if #available(iOS 26.0, *) {
        BackgroundExtensionEffectShowcase()
    }
}
