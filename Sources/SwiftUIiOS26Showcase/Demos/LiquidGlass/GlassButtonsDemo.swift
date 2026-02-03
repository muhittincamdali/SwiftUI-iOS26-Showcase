// GlassButtonsDemo.swift
// SwiftUI-iOS26-Showcase
//
// Comprehensive demonstration of Liquid Glass button styles
// Includes interactive states, haptics, and accessibility support

import SwiftUI

// MARK: - Glass Button Variants

/// Enumeration of available glass button styles
public enum GlassButtonVariant {
    case primary
    case secondary
    case tertiary
    case destructive
    case success
    case warning
    case outline
    case ghost
    
    var backgroundColor: Color {
        switch self {
        case .primary: return .blue
        case .secondary: return .gray
        case .tertiary: return .clear
        case .destructive: return .red
        case .success: return .green
        case .warning: return .orange
        case .outline: return .clear
        case .ghost: return .clear
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .primary, .secondary, .destructive, .success, .warning:
            return .white
        case .tertiary, .outline, .ghost:
            return .white.opacity(0.9)
        }
    }
    
    var borderColor: Color {
        switch self {
        case .outline: return .white.opacity(0.4)
        case .ghost: return .clear
        default: return .white.opacity(0.2)
        }
    }
    
    var blurIntensity: CGFloat {
        switch self {
        case .primary, .secondary, .destructive, .success, .warning:
            return 15
        case .tertiary, .outline, .ghost:
            return 20
        }
    }
}

/// Size options for glass buttons
public enum GlassButtonSize {
    case small
    case medium
    case large
    case extraLarge
    
    var horizontalPadding: CGFloat {
        switch self {
        case .small: return 12
        case .medium: return 20
        case .large: return 28
        case .extraLarge: return 36
        }
    }
    
    var verticalPadding: CGFloat {
        switch self {
        case .small: return 8
        case .medium: return 12
        case .large: return 16
        case .extraLarge: return 20
        }
    }
    
    var font: Font {
        switch self {
        case .small: return .caption.bold()
        case .medium: return .subheadline.bold()
        case .large: return .headline
        case .extraLarge: return .title3.bold()
        }
    }
    
    var iconSize: CGFloat {
        switch self {
        case .small: return 14
        case .medium: return 18
        case .large: return 22
        case .extraLarge: return 28
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .small: return 8
        case .medium: return 12
        case .large: return 16
        case .extraLarge: return 20
        }
    }
}

// MARK: - Glass Button Style

/// A fully customizable glass button style
public struct GlassButtonStyleModifier: ButtonStyle {
    let variant: GlassButtonVariant
    let size: GlassButtonSize
    let isFullWidth: Bool
    let enableHaptics: Bool
    
    @State private var isHovered = false
    
    public init(
        variant: GlassButtonVariant = .primary,
        size: GlassButtonSize = .medium,
        isFullWidth: Bool = false,
        enableHaptics: Bool = true
    ) {
        self.variant = variant
        self.size = size
        self.isFullWidth = isFullWidth
        self.enableHaptics = enableHaptics
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(size.font)
            .foregroundStyle(variant.foregroundColor)
            .padding(.horizontal, size.horizontalPadding)
            .padding(.vertical, size.verticalPadding)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .background(
                ZStack {
                    // Base material
                    RoundedRectangle(cornerRadius: size.cornerRadius)
                        .fill(.ultraThinMaterial)
                    
                    // Color overlay
                    RoundedRectangle(cornerRadius: size.cornerRadius)
                        .fill(variant.backgroundColor.opacity(0.3))
                    
                    // Highlight gradient
                    RoundedRectangle(cornerRadius: size.cornerRadius)
                        .fill(
                            LinearGradient(
                                colors: [
                                    .white.opacity(isHovered ? 0.25 : 0.15),
                                    .white.opacity(0)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    
                    // Border
                    RoundedRectangle(cornerRadius: size.cornerRadius)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    variant.borderColor,
                                    variant.borderColor.opacity(0.5)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1
                        )
                }
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
            .onHover { hovering in
                isHovered = hovering
            }
            .sensoryFeedback(.impact(flexibility: .soft), trigger: configuration.isPressed)
    }
}

// MARK: - Icon Button Style

/// Glass button style with icon support
public struct GlassIconButtonStyle: ButtonStyle {
    let icon: String
    let variant: GlassButtonVariant
    let size: GlassButtonSize
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: size.iconSize))
            
            configuration.label
        }
        .font(size.font)
        .foregroundStyle(variant.foregroundColor)
        .padding(.horizontal, size.horizontalPadding)
        .padding(.vertical, size.verticalPadding)
        .background(glassBackground(isPressed: configuration.isPressed))
        .scaleEffect(configuration.isPressed ? 0.96 : 1)
        .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
    
    private func glassBackground(isPressed: Bool) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .fill(.ultraThinMaterial)
            
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .fill(variant.backgroundColor.opacity(isPressed ? 0.4 : 0.3))
            
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
        }
    }
}

// MARK: - Circular Glass Button

/// Circular glass button for icon-only actions
struct CircularGlassButton: View {
    let icon: String
    let size: CGFloat
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Image(systemName: icon)
                .font(.system(size: size * 0.4))
                .foregroundStyle(.white)
                .frame(width: size, height: size)
                .background(
                    Circle()
                        .fill(.ultraThinMaterial)
                        .overlay(
                            Circle()
                                .fill(color.opacity(0.3))
                        )
                        .overlay(
                            Circle()
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [.white.opacity(0.4), .white.opacity(0.1)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                )
                .scaleEffect(isPressed ? 0.9 : 1)
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.impact(flexibility: .soft), trigger: isPressed)
    }
}

// MARK: - Animated Glass Button

/// Glass button with custom animations
struct AnimatedGlassButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    @State private var isAnimating = false
    @State private var shimmerOffset: CGFloat = -200
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                
                Text(title)
                    .font(.headline)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                    
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [.purple.opacity(0.4), .blue.opacity(0.4)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // Shimmer effect
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [
                                    .clear,
                                    .white.opacity(0.3),
                                    .clear
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .offset(x: shimmerOffset)
                        .mask(RoundedRectangle(cornerRadius: 16))
                    
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color.white.opacity(0.3), lineWidth: 1)
                }
            )
        }
        .onAppear {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                shimmerOffset = 200
            }
        }
    }
}

// MARK: - Loading Glass Button

/// Glass button with loading state
struct LoadingGlassButton: View {
    let title: String
    let loadingTitle: String
    @Binding var isLoading: Bool
    let action: () async -> Void
    
    var body: some View {
        Button {
            Task {
                isLoading = true
                await action()
                isLoading = false
            }
        } label: {
            HStack(spacing: 12) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                        .scaleEffect(0.8)
                }
                
                Text(isLoading ? loadingTitle : title)
                    .font(.headline)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 28)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.blue.opacity(isLoading ? 0.2 : 0.4))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .disabled(isLoading)
        .animation(.easeInOut, value: isLoading)
    }
}

// MARK: - Demo View

/// Comprehensive glass buttons demonstration
public struct GlassButtonsDemo: View {
    @State private var selectedVariant: GlassButtonVariant = .primary
    @State private var selectedSize: GlassButtonSize = .medium
    @State private var isLoading = false
    @State private var buttonTaps = 0
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                headerSection
                
                variantShowcase
                
                sizeShowcase
                
                iconButtonShowcase
                
                specialButtonsShowcase
                
                interactivePlayground
                
                codeExamplesSection
            }
            .padding()
        }
        .background(backgroundGradient)
        .navigationTitle("Glass Buttons")
    }
    
    // MARK: - Sections
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Glass Button Styles")
                .font(.title.bold())
                .foregroundStyle(.white)
            
            Text("A comprehensive collection of glass-styled buttons with haptic feedback, animations, and full accessibility support.")
                .font(.body)
                .foregroundStyle(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var variantShowcase: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Button Variants")
                .font(.headline)
                .foregroundStyle(.white)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach([
                    ("Primary", GlassButtonVariant.primary),
                    ("Secondary", GlassButtonVariant.secondary),
                    ("Destructive", GlassButtonVariant.destructive),
                    ("Success", GlassButtonVariant.success),
                    ("Warning", GlassButtonVariant.warning),
                    ("Outline", GlassButtonVariant.outline)
                ], id: \.0) { name, variant in
                    Button(name) {
                        buttonTaps += 1
                    }
                    .buttonStyle(GlassButtonStyleModifier(variant: variant, isFullWidth: true))
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var sizeShowcase: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Button Sizes")
                .font(.headline)
                .foregroundStyle(.white)
            
            VStack(spacing: 12) {
                Button("Extra Large") {}
                    .buttonStyle(GlassButtonStyleModifier(size: .extraLarge))
                
                Button("Large") {}
                    .buttonStyle(GlassButtonStyleModifier(size: .large))
                
                Button("Medium") {}
                    .buttonStyle(GlassButtonStyleModifier(size: .medium))
                
                Button("Small") {}
                    .buttonStyle(GlassButtonStyleModifier(size: .small))
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var iconButtonShowcase: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Icon Buttons")
                .font(.headline)
                .foregroundStyle(.white)
            
            HStack(spacing: 16) {
                CircularGlassButton(icon: "heart.fill", size: 56, color: .pink) {}
                CircularGlassButton(icon: "bookmark.fill", size: 56, color: .blue) {}
                CircularGlassButton(icon: "square.and.arrow.up", size: 56, color: .green) {}
                CircularGlassButton(icon: "ellipsis", size: 56, color: .gray) {}
            }
            .frame(maxWidth: .infinity)
            
            HStack(spacing: 12) {
                Button("Download") {}
                    .buttonStyle(GlassIconButtonStyle(icon: "arrow.down.circle", variant: .primary, size: .medium))
                
                Button("Share") {}
                    .buttonStyle(GlassIconButtonStyle(icon: "square.and.arrow.up", variant: .secondary, size: .medium))
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var specialButtonsShowcase: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Special Buttons")
                .font(.headline)
                .foregroundStyle(.white)
            
            AnimatedGlassButton(title: "Animated Button", icon: "sparkles") {}
            
            LoadingGlassButton(
                title: "Submit",
                loadingTitle: "Processing...",
                isLoading: $isLoading
            ) {
                try? await Task.sleep(for: .seconds(2))
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var interactivePlayground: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Interactive Playground")
                .font(.headline)
                .foregroundStyle(.white)
            
            Text("Tap Count: \(buttonTaps)")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
            
            // Variant picker
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach([
                        ("Primary", GlassButtonVariant.primary),
                        ("Secondary", GlassButtonVariant.secondary),
                        ("Success", GlassButtonVariant.success),
                        ("Warning", GlassButtonVariant.warning),
                        ("Destructive", GlassButtonVariant.destructive)
                    ], id: \.0) { name, variant in
                        Button(name) {
                            selectedVariant = variant
                        }
                        .buttonStyle(GlassButtonStyleModifier(
                            variant: selectedVariant == variant ? variant : .outline,
                            size: .small
                        ))
                    }
                }
            }
            
            // Size picker
            HStack(spacing: 8) {
                ForEach([
                    ("S", GlassButtonSize.small),
                    ("M", GlassButtonSize.medium),
                    ("L", GlassButtonSize.large),
                    ("XL", GlassButtonSize.extraLarge)
                ], id: \.0) { name, size in
                    Button(name) {
                        selectedSize = size
                    }
                    .buttonStyle(GlassButtonStyleModifier(
                        variant: selectedSize == size ? .primary : .outline,
                        size: .small
                    ))
                }
            }
            
            // Preview
            VStack {
                Text("Preview")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
                
                Button("Custom Button") {
                    buttonTaps += 1
                }
                .buttonStyle(GlassButtonStyleModifier(
                    variant: selectedVariant,
                    size: selectedSize
                ))
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.black.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var codeExamplesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Usage Examples")
                .font(.headline)
                .foregroundStyle(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                Text(codeExample)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(.green)
                    .padding()
            }
            .background(Color.black.opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 0.1, green: 0.15, blue: 0.2),
                Color(red: 0.15, green: 0.1, blue: 0.25)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var codeExample: String {
        """
        // Basic glass button
        Button("Action") { }
            .buttonStyle(GlassButtonStyleModifier(
                variant: .primary,
                size: .medium
            ))
        
        // Full width button
        Button("Submit") { }
            .buttonStyle(GlassButtonStyleModifier(
                variant: .success,
                size: .large,
                isFullWidth: true
            ))
        
        // Icon button
        Button("Download") { }
            .buttonStyle(GlassIconButtonStyle(
                icon: "arrow.down.circle",
                variant: .primary,
                size: .medium
            ))
        
        // Circular icon button
        CircularGlassButton(
            icon: "heart.fill",
            size: 56,
            color: .pink
        ) { }
        """
    }
}

// MARK: - Preview

#Preview("Glass Buttons Demo") {
    NavigationStack {
        GlassButtonsDemo()
    }
}
