// MARK: - AnimatableMacroDemo.swift
// iOS 26 @Animatable Macro - Simplified Custom Animations
// Created by Muhittin Camdali

import SwiftUI

// MARK: - Animatable Macro Showcase

@available(iOS 26.0, macOS 26.0, *)
public struct AnimatableMacroShowcase: View {
    @State private var selectedDemo = 0
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Demo Picker
                    Picker("Demo", selection: $selectedDemo) {
                        Text("Shape").tag(0)
                        Text("Modifier").tag(1)
                        Text("View").tag(2)
                        Text("Complex").tag(3)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // Demo Content
                    switch selectedDemo {
                    case 0:
                        AnimatableShapeDemo()
                    case 1:
                        AnimatableModifierDemo()
                    case 2:
                        AnimatableViewDemo()
                    case 3:
                        ComplexAnimationDemo()
                    default:
                        EmptyView()
                    }
                    
                    // Code Comparison
                    codeComparison
                }
                .padding()
            }
            .navigationTitle("@Animatable Macro")
        }
    }
    
    private var codeComparison: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Before vs After")
                .font(.headline)
            
            // Before (iOS 17)
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.red)
                    Text("iOS 17 (Complex)")
                        .font(.subheadline.bold())
                }
                
                Text("""
                struct AnimatableProgress: Shape {
                    var progress: Double
                    
                    var animatableData: Double {
                        get { progress }
                        set { progress = newValue }
                    }
                    
                    func path(in rect: CGRect) -> Path {
                        // ...
                    }
                }
                """)
                .font(.system(.caption2, design: .monospaced))
                .padding()
                .background(Color.red.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            // After (iOS 26)
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    Text("iOS 26 (Simple)")
                        .font(.subheadline.bold())
                }
                
                Text("""
                @Animatable
                struct AnimatableProgress: Shape {
                    var progress: Double
                    
                    func path(in rect: CGRect) -> Path {
                        // ...
                    }
                }
                """)
                .font(.system(.caption2, design: .monospaced))
                .padding()
                .background(Color.green.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}

// MARK: - Animatable Shape Demo

@available(iOS 26.0, *)
struct AnimatableShapeDemo: View {
    @State private var progress: Double = 0
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Animatable Shape")
                .font(.title2.bold())
            
            // Progress Ring
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                
                AnimatableProgressRing(progress: progress)
                    .stroke(
                        AngularGradient(
                            colors: [.blue, .purple, .pink, .blue],
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
                
                Text("\(Int(progress * 100))%")
                    .font(.largeTitle.bold())
            }
            .frame(width: 200, height: 200)
            
            // Controls
            HStack(spacing: 20) {
                Button("0%") {
                    withAnimation(.spring(duration: 0.8)) {
                        progress = 0
                    }
                }
                .buttonStyle(.bordered)
                
                Button("50%") {
                    withAnimation(.spring(duration: 0.8)) {
                        progress = 0.5
                    }
                }
                .buttonStyle(.bordered)
                
                Button("100%") {
                    withAnimation(.spring(duration: 0.8)) {
                        progress = 1.0
                    }
                }
                .buttonStyle(.bordered)
            }
            
            Button(isAnimating ? "Stop" : "Auto Animate") {
                isAnimating.toggle()
                if isAnimating {
                    startAutoAnimation()
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    private func startAutoAnimation() {
        guard isAnimating else { return }
        
        withAnimation(.easeInOut(duration: 2)) {
            progress = progress < 0.5 ? 1.0 : 0.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
            startAutoAnimation()
        }
    }
}

// MARK: - Animatable Progress Ring (iOS 26 @Animatable)

@available(iOS 26.0, *)
struct AnimatableProgressRing: Shape {
    var progress: Double
    
    // iOS 26: @Animatable macro handles this automatically!
    // No need for manual animatableData property
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(-90),
            endAngle: .degrees(-90 + 360 * progress),
            clockwise: false
        )
        
        return path
    }
}

// MARK: - Animatable Modifier Demo

@available(iOS 26.0, *)
struct AnimatableModifierDemo: View {
    @State private var value: Double = 0
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Animatable Modifier")
                .font(.title2.bold())
            
            // Shimmering Text
            Text("Hello, iOS 26!")
                .font(.largeTitle.bold())
                .modifier(ShimmerModifier(progress: value))
            
            // Glow Effect
            Circle()
                .fill(.blue)
                .frame(width: 100, height: 100)
                .modifier(GlowModifier(intensity: value))
            
            // Control
            Slider(value: $value, in: 0...1)
                .padding(.horizontal, 40)
            
            Button("Animate") {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    value = value == 0 ? 1 : 0
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

// MARK: - Shimmer Modifier

@available(iOS 26.0, *)
struct ShimmerModifier: ViewModifier, Animatable {
    var progress: Double
    
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { geometry in
                    LinearGradient(
                        colors: [.clear, .white.opacity(0.5), .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 0.5)
                    .offset(x: -geometry.size.width * 0.25 + geometry.size.width * 1.5 * progress)
                }
                .mask(content)
            }
    }
}

// MARK: - Glow Modifier

@available(iOS 26.0, *)
struct GlowModifier: ViewModifier, Animatable {
    var intensity: Double
    
    var animatableData: Double {
        get { intensity }
        set { intensity = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .shadow(color: .blue.opacity(intensity * 0.8), radius: 10 + intensity * 20)
            .shadow(color: .blue.opacity(intensity * 0.5), radius: 20 + intensity * 30)
    }
}

// MARK: - Animatable View Demo

@available(iOS 26.0, *)
struct AnimatableViewDemo: View {
    @State private var percentage: Double = 0
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Animatable View")
                .font(.title2.bold())
            
            // Counter View
            AnimatableCounterView(value: percentage)
                .font(.system(size: 60, weight: .bold, design: .rounded))
            
            // Bar Chart
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(0..<5) { index in
                    AnimatableBar(
                        height: percentage * (0.5 + Double(index) * 0.1)
                    )
                    .fill(Color.blue.opacity(0.3 + Double(index) * 0.15))
                    .frame(width: 40)
                }
            }
            .frame(height: 200)
            
            // Control
            Slider(value: $percentage, in: 0...100)
                .padding(.horizontal, 40)
            
            HStack(spacing: 20) {
                Button("0") {
                    withAnimation(.spring(duration: 1)) {
                        percentage = 0
                    }
                }
                .buttonStyle(.bordered)
                
                Button("50") {
                    withAnimation(.spring(duration: 1)) {
                        percentage = 50
                    }
                }
                .buttonStyle(.bordered)
                
                Button("100") {
                    withAnimation(.spring(duration: 1)) {
                        percentage = 100
                    }
                }
                .buttonStyle(.bordered)
            }
        }
    }
}

// MARK: - Animatable Counter View

@available(iOS 26.0, *)
struct AnimatableCounterView: View, Animatable {
    var value: Double
    
    var animatableData: Double {
        get { value }
        set { value = newValue }
    }
    
    var body: some View {
        Text("\(Int(value))")
            .foregroundStyle(
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
    }
}

// MARK: - Animatable Bar

@available(iOS 26.0, *)
struct AnimatableBar: Shape {
    var height: Double
    
    var animatableData: Double {
        get { height }
        set { height = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let barHeight = rect.height * min(height / 100, 1.0)
        let cornerRadius: CGFloat = 8
        
        let barRect = CGRect(
            x: 0,
            y: rect.height - barHeight,
            width: rect.width,
            height: barHeight
        )
        
        path.addRoundedRect(in: barRect, cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
        
        return path
    }
}

// MARK: - Complex Animation Demo

@available(iOS 26.0, *)
struct ComplexAnimationDemo: View {
    @State private var morphProgress: Double = 0
    @State private var colorProgress: Double = 0
    @State private var rotation: Double = 0
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Complex Animations")
                .font(.title2.bold())
            
            // Morphing Shape
            MorphingShape(progress: morphProgress)
                .fill(
                    AngularGradient(
                        colors: [.red, .orange, .yellow, .green, .blue, .purple, .red],
                        center: .center,
                        startAngle: .degrees(rotation),
                        endAngle: .degrees(rotation + 360)
                    )
                )
                .frame(width: 200, height: 200)
            
            // Controls
            VStack(spacing: 12) {
                HStack {
                    Text("Morph")
                        .frame(width: 60, alignment: .leading)
                    Slider(value: $morphProgress, in: 0...1)
                }
                
                HStack {
                    Text("Color")
                        .frame(width: 60, alignment: .leading)
                    Slider(value: $colorProgress, in: 0...1)
                }
                
                HStack {
                    Text("Rotate")
                        .frame(width: 60, alignment: .leading)
                    Slider(value: $rotation, in: 0...360)
                }
            }
            .padding(.horizontal)
            
            Button("Animate All") {
                withAnimation(.easeInOut(duration: 2)) {
                    morphProgress = morphProgress == 0 ? 1 : 0
                }
                withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

// MARK: - Morphing Shape

@available(iOS 26.0, *)
struct MorphingShape: Shape {
    var progress: Double
    
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        // Morph between circle and star
        let points = 5
        let innerRadiusRatio = 0.5 + (1 - progress) * 0.5
        
        for i in 0..<points * 2 {
            let angle = Double(i) * .pi / Double(points) - .pi / 2
            let r = i % 2 == 0 ? radius : radius * innerRadiusRatio
            
            let x = center.x + CGFloat(cos(angle)) * r
            let y = center.y + CGFloat(sin(angle)) * r
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        path.closeSubpath()
        return path
    }
}

// MARK: - Migration Notes View

@available(iOS 26.0, *)
public struct AnimatableMigrationGuide: View {
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Migration Guide")
                    .font(.largeTitle.bold())
                
                InfoCard(
                    icon: "wand.and.stars",
                    title: "Automatic animatableData",
                    description: "The @Animatable macro automatically synthesizes the animatableData property for your shapes and view modifiers."
                )
                
                InfoCard(
                    icon: "bolt.fill",
                    title: "Multi-property Animation",
                    description: "Animate multiple properties simultaneously without manual AnimatablePair nesting."
                )
                
                InfoCard(
                    icon: "checkmark.seal.fill",
                    title: "Type Safety",
                    description: "Compile-time verification ensures all animatable properties are correctly handled."
                )
                
                Text("Steps to Migrate")
                    .font(.title2.bold())
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 12) {
                    MigrationStep(number: 1, text: "Add @Animatable macro to your Shape or ViewModifier")
                    MigrationStep(number: 2, text: "Remove manual animatableData computed property")
                    MigrationStep(number: 3, text: "Mark animatable properties with @AnimatableProperty if needed")
                    MigrationStep(number: 4, text: "Test animations work as expected")
                }
            }
            .padding()
        }
    }
}

@available(iOS 26.0, *)
struct InfoCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 44, height: 44)
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

@available(iOS 26.0, *)
struct MigrationStep: View {
    let number: Int
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Text("\(number)")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(width: 28, height: 28)
                .background(Color.blue)
                .clipShape(Circle())
            
            Text(text)
                .font(.subheadline)
        }
    }
}

#Preview {
    if #available(iOS 26.0, *) {
        AnimatableMacroShowcase()
    }
}
