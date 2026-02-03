// GlassAnimationsDemo.swift
// SwiftUI-iOS26-Showcase
//
// Demonstrates advanced animations with Liquid Glass effects
// Includes spring physics, keyframe animations, and transitions

import SwiftUI

// MARK: - Animation Presets

/// Predefined animation configurations for glass effects
public enum GlassAnimationPreset {
    case subtle
    case smooth
    case bouncy
    case snappy
    case morphing
    
    var animation: Animation {
        switch self {
        case .subtle:
            return .easeInOut(duration: 0.3)
        case .smooth:
            return .spring(response: 0.5, dampingFraction: 0.8)
        case .bouncy:
            return .spring(response: 0.6, dampingFraction: 0.5, blendDuration: 0.3)
        case .snappy:
            return .spring(response: 0.3, dampingFraction: 0.7)
        case .morphing:
            return .spring(response: 0.8, dampingFraction: 0.6)
        }
    }
    
    var description: String {
        switch self {
        case .subtle: return "Subtle & Elegant"
        case .smooth: return "Smooth & Natural"
        case .bouncy: return "Bouncy & Playful"
        case .snappy: return "Snappy & Responsive"
        case .morphing: return "Morphing & Fluid"
        }
    }
}

// MARK: - Animated Glass Container

/// A container that animates its glass effect
struct AnimatedGlassContainer<Content: View>: View {
    let preset: GlassAnimationPreset
    @ViewBuilder let content: Content
    
    @State private var isAnimating = false
    @State private var blurAmount: CGFloat = 20
    @State private var scale: CGFloat = 1
    
    var body: some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(isAnimating ? 0.2 : 0.1),
                                        .white.opacity(isAnimating ? 0.1 : 0.05)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(isAnimating ? 0.5 : 0.3),
                                        .white.opacity(isAnimating ? 0.2 : 0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
            .scaleEffect(scale)
            .animation(preset.animation, value: isAnimating)
            .animation(preset.animation, value: scale)
    }
}

// MARK: - Pulsing Glass Effect

/// A view that pulses with a glass shimmer
struct PulsingGlassEffect: View {
    let color: Color
    let size: CGFloat
    
    @State private var isPulsing = false
    
    var body: some View {
        ZStack {
            // Outer pulse
            Circle()
                .fill(color.opacity(0.1))
                .frame(width: size * 1.5, height: size * 1.5)
                .scaleEffect(isPulsing ? 1.2 : 1)
                .opacity(isPulsing ? 0 : 0.5)
            
            // Middle pulse
            Circle()
                .fill(color.opacity(0.2))
                .frame(width: size * 1.2, height: size * 1.2)
                .scaleEffect(isPulsing ? 1.1 : 1)
                .opacity(isPulsing ? 0.3 : 0.7)
            
            // Core
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: size, height: size)
                .overlay(
                    Circle()
                        .fill(color.opacity(0.3))
                )
                .overlay(
                    Circle()
                        .strokeBorder(
                            LinearGradient(
                                colors: [color.opacity(0.6), color.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isPulsing = true
            }
        }
    }
}

// MARK: - Glass Morph Shape

/// A shape that morphs between different forms
struct GlassMorphShape: View {
    @State private var morphProgress: CGFloat = 0
    @State private var rotationAngle: Double = 0
    
    let colors: [Color]
    let size: CGFloat
    
    var body: some View {
        ZStack {
            ForEach(0..<3) { index in
                MorphingShape(progress: morphProgress + Double(index) * 0.3)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        MorphingShape(progress: morphProgress + Double(index) * 0.3)
                            .fill(colors[index % colors.count].opacity(0.3))
                    )
                    .overlay(
                        MorphingShape(progress: morphProgress + Double(index) * 0.3)
                            .strokeBorder(
                                colors[index % colors.count].opacity(0.5),
                                lineWidth: 1
                            )
                    )
                    .frame(width: size - CGFloat(index * 20), height: size - CGFloat(index * 20))
                    .rotationEffect(.degrees(rotationAngle + Double(index * 30)))
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 4).repeatForever(autoreverses: true)) {
                morphProgress = 1
            }
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
        }
    }
}

/// A shape that morphs based on progress
struct MorphingShape: Shape {
    var progress: CGFloat
    
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let centerX = rect.midX
        let centerY = rect.midY
        
        let points = 6
        let radius = min(width, height) / 2
        let morphedRadius = radius * (0.7 + 0.3 * sin(progress * .pi * 2))
        
        var path = Path()
        
        for i in 0..<points {
            let angle = (CGFloat(i) / CGFloat(points)) * .pi * 2 - .pi / 2
            let pointRadius = morphedRadius * (1 + 0.2 * sin(CGFloat(i) * 2 + progress * .pi * 4))
            let x = centerX + cos(angle) * pointRadius
            let y = centerY + sin(angle) * pointRadius
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                let prevAngle = (CGFloat(i - 1) / CGFloat(points)) * .pi * 2 - .pi / 2
                let controlRadius = morphedRadius * 1.1
                let controlAngle = (prevAngle + angle) / 2
                let controlX = centerX + cos(controlAngle) * controlRadius
                let controlY = centerY + sin(controlAngle) * controlRadius
                
                path.addQuadCurve(to: CGPoint(x: x, y: y), control: CGPoint(x: controlX, y: controlY))
            }
        }
        
        path.closeSubpath()
        return path
    }
}

// MARK: - Glass Wave Effect

/// An animated wave with glass styling
struct GlassWaveEffect: View {
    let color: Color
    let amplitude: CGFloat
    let frequency: CGFloat
    
    @State private var phase: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background wave
                WaveShape(phase: phase, amplitude: amplitude * 0.7, frequency: frequency)
                    .fill(color.opacity(0.1))
                    .blur(radius: 3)
                
                // Middle wave
                WaveShape(phase: phase + 0.5, amplitude: amplitude * 0.85, frequency: frequency * 1.1)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        WaveShape(phase: phase + 0.5, amplitude: amplitude * 0.85, frequency: frequency * 1.1)
                            .fill(color.opacity(0.15))
                    )
                
                // Front wave
                WaveShape(phase: phase + 1, amplitude: amplitude, frequency: frequency * 0.9)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        WaveShape(phase: phase + 1, amplitude: amplitude, frequency: frequency * 0.9)
                            .fill(color.opacity(0.2))
                    )
                    .overlay(
                        WaveShape(phase: phase + 1, amplitude: amplitude, frequency: frequency * 0.9)
                            .stroke(color.opacity(0.4), lineWidth: 1)
                    )
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                phase = .pi * 2
            }
        }
    }
}

/// Wave shape for animation
struct WaveShape: Shape {
    var phase: CGFloat
    var amplitude: CGFloat
    var frequency: CGFloat
    
    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let midHeight = height * 0.5
        
        path.move(to: CGPoint(x: 0, y: height))
        
        for x in stride(from: 0, through: width, by: 1) {
            let relativeX = x / width
            let normalizedX = relativeX * frequency * .pi * 2
            let y = midHeight + sin(normalizedX + phase) * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.closeSubpath()
        
        return path
    }
}

// MARK: - Floating Glass Cards

/// Floating cards with glass effect
struct FloatingGlassCards: View {
    let count: Int
    let colors: [Color]
    
    @State private var offsets: [CGSize] = []
    @State private var rotations: [Double] = []
    
    var body: some View {
        ZStack {
            ForEach(0..<count, id: \.self) { index in
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(colors[index % colors.count].opacity(0.2))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(colors[index % colors.count].opacity(0.4), lineWidth: 1)
                    )
                    .frame(width: 80, height: 100)
                    .offset(offsets.indices.contains(index) ? offsets[index] : .zero)
                    .rotation3DEffect(
                        .degrees(rotations.indices.contains(index) ? rotations[index] : 0),
                        axis: (x: 1, y: 1, z: 0)
                    )
            }
        }
        .onAppear {
            initializeAnimations()
            startAnimations()
        }
    }
    
    private func initializeAnimations() {
        offsets = (0..<count).map { _ in
            CGSize(
                width: CGFloat.random(in: -20...20),
                height: CGFloat.random(in: -20...20)
            )
        }
        rotations = (0..<count).map { _ in Double.random(in: -10...10) }
    }
    
    private func startAnimations() {
        for index in 0..<count {
            withAnimation(
                .easeInOut(duration: Double.random(in: 2...4))
                .repeatForever(autoreverses: true)
                .delay(Double(index) * 0.2)
            ) {
                offsets[index] = CGSize(
                    width: CGFloat.random(in: -30...30),
                    height: CGFloat.random(in: -30...30)
                )
                rotations[index] = Double.random(in: -15...15)
            }
        }
    }
}

// MARK: - Shimmer Effect

/// Glass shimmer animation
struct GlassShimmerEffect: ViewModifier {
    @State private var shimmerOffset: CGFloat = -1
    let duration: Double
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    .clear,
                                    .white.opacity(0.3),
                                    .white.opacity(0.5),
                                    .white.opacity(0.3),
                                    .clear
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * 0.5)
                        .offset(x: shimmerOffset * geometry.size.width * 1.5)
                        .blur(radius: 5)
                }
                .mask(content)
            )
            .onAppear {
                withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                    shimmerOffset = 1
                }
            }
    }
}

extension View {
    func glassShimmer(duration: Double = 2) -> some View {
        modifier(GlassShimmerEffect(duration: duration))
    }
}

// MARK: - Interactive Animated Card

/// An interactive card with glass animations
struct InteractiveGlassCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    
    @State private var isPressed = false
    @State private var dragOffset: CGSize = .zero
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundStyle(color)
            }
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
        .frame(width: 140, height: 160)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [
                                    .white.opacity(isPressed ? 0.2 : 0.1),
                                    .white.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.4),
                                    .white.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .scaleEffect(isPressed ? 0.95 : 1)
        .rotation3DEffect(
            .degrees(Double(dragOffset.width / 10)),
            axis: (x: 0, y: 1, z: 0)
        )
        .rotation3DEffect(
            .degrees(Double(-dragOffset.height / 10)),
            axis: (x: 1, y: 0, z: 0)
        )
        .offset(dragOffset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = CGSize(
                        width: value.translation.width * 0.3,
                        height: value.translation.height * 0.3
                    )
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        dragOffset = .zero
                    }
                }
        )
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.1)
                .onChanged { _ in
                    withAnimation(.spring(response: 0.3)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.3)) {
                        isPressed = false
                    }
                }
        )
    }
}

// MARK: - Demo View

/// Comprehensive glass animations showcase
public struct GlassAnimationsDemo: View {
    @State private var selectedPreset: GlassAnimationPreset = .smooth
    @State private var showMorph = true
    @State private var showWaves = true
    @State private var showCards = true
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                headerSection
                
                presetShowcase
                
                pulsingEffects
                
                morphingShapes
                
                waveEffects
                
                floatingCards
                
                interactiveCards
                
                shimmerDemo
            }
            .padding()
        }
        .background(backgroundGradient)
        .navigationTitle("Glass Animations")
    }
    
    // MARK: - Sections
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Glass Animations")
                .font(.title.bold())
                .foregroundStyle(.white)
            
            Text("Advanced animation techniques combined with Liquid Glass effects. Explore morphing shapes, pulsing effects, and interactive cards.")
                .font(.body)
                .foregroundStyle(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var presetShowcase: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Animation Presets")
                .font(.headline)
                .foregroundStyle(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach([
                        GlassAnimationPreset.subtle,
                        .smooth,
                        .bouncy,
                        .snappy,
                        .morphing
                    ], id: \.description) { preset in
                        PresetButton(
                            preset: preset,
                            isSelected: selectedPreset.description == preset.description
                        ) {
                            selectedPreset = preset
                        }
                    }
                }
            }
        }
    }
    
    private var pulsingEffects: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pulsing Effects")
                .font(.headline)
                .foregroundStyle(.white)
            
            HStack(spacing: 32) {
                PulsingGlassEffect(color: .blue, size: 60)
                PulsingGlassEffect(color: .purple, size: 60)
                PulsingGlassEffect(color: .green, size: 60)
                PulsingGlassEffect(color: .orange, size: 60)
            }
            .frame(height: 100)
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var morphingShapes: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Morphing Shapes")
                .font(.headline)
                .foregroundStyle(.white)
            
            GlassMorphShape(
                colors: [.blue, .purple, .pink],
                size: 150
            )
            .frame(height: 180)
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var waveEffects: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Wave Effects")
                .font(.headline)
                .foregroundStyle(.white)
            
            GlassWaveEffect(color: .blue, amplitude: 30, frequency: 2)
                .frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var floatingCards: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Floating Cards")
                .font(.headline)
                .foregroundStyle(.white)
            
            FloatingGlassCards(
                count: 5,
                colors: [.blue, .purple, .pink, .orange, .green]
            )
            .frame(height: 150)
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var interactiveCards: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Interactive Cards")
                .font(.headline)
                .foregroundStyle(.white)
            
            Text("Drag the cards to see 3D effects")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.6))
            
            HStack(spacing: 16) {
                InteractiveGlassCard(
                    title: "Photos",
                    subtitle: "1,234 items",
                    icon: "photo.stack",
                    color: .blue
                )
                
                InteractiveGlassCard(
                    title: "Music",
                    subtitle: "567 songs",
                    icon: "music.note.list",
                    color: .purple
                )
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var shimmerDemo: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Shimmer Effect")
                .font(.headline)
                .foregroundStyle(.white)
            
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.blue.opacity(0.2))
                )
                .frame(height: 80)
                .glassShimmer(duration: 2)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 0.08, green: 0.1, blue: 0.18),
                Color(red: 0.12, green: 0.08, blue: 0.2)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

// MARK: - Preset Button

struct PresetButton: View {
    let preset: GlassAnimationPreset
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isAnimating = false
    
    var body: some View {
        Button(action: {
            action()
            withAnimation(preset.animation) {
                isAnimating.toggle()
            }
        }) {
            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(isSelected ? Color.blue.opacity(0.3) : Color.white.opacity(0.1))
                    )
                    .frame(width: 50, height: 50)
                    .scaleEffect(isAnimating && isSelected ? 1.1 : 1)
                
                Text(preset.description)
                    .font(.caption2)
                    .foregroundStyle(isSelected ? .white : .white.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
            .frame(width: 80)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview("Glass Animations Demo") {
    NavigationStack {
        GlassAnimationsDemo()
    }
}
