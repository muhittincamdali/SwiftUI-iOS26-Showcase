import SwiftUI

// MARK: - Animation Demo

/// Showcases spring animations, phase animators, keyframe animations,
/// and the new animation completions in SwiftUI.
struct AnimationDemo: View {

    // MARK: - Properties

    @State private var isAnimating = false
    @State private var bounceCount = 0
    @State private var selectedAnimation: AnimationType = .spring
    @State private var springResponse: Double = 0.5
    @State private var springDamping: Double = 0.7

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                animationPreview
                animationSelector
                springControls
                codeSection
            }
            .padding()
        }
        .navigationTitle("Animations")
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Modern Animations")
                .font(.title2.bold())
            Text("Explore spring physics, phase animators, and keyframe-driven motion in SwiftUI.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Animation Preview

    private var animationPreview: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.blue.opacity(0.1))
                .frame(height: 250)

            animatedContent
        }
        .onTapGesture {
            triggerAnimation()
        }
    }

    @ViewBuilder
    private var animatedContent: some View {
        switch selectedAnimation {
        case .spring:
            Circle()
                .fill(.blue.gradient)
                .frame(width: 80, height: 80)
                .scaleEffect(isAnimating ? 1.3 : 1.0)
                .offset(y: isAnimating ? -50 : 0)

        case .phase:
            RoundedRectangle(cornerRadius: isAnimating ? 40 : 16)
                .fill(.purple.gradient)
                .frame(width: isAnimating ? 100 : 80, height: isAnimating ? 100 : 80)
                .rotationEffect(.degrees(isAnimating ? 180 : 0))

        case .keyframe:
            Image(systemName: "star.fill")
                .font(.system(size: 50))
                .foregroundStyle(.yellow.gradient)
                .scaleEffect(isAnimating ? 1.5 : 1.0)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .offset(y: isAnimating ? -30 : 0)

        case .bounce:
            VStack(spacing: 8) {
                Image(systemName: "tennisball.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(.green.gradient)
                    .offset(y: isAnimating ? 60 : -60)
                Text("Bounces: \(bounceCount)")
                    .font(.caption.bold())
            }
        }
    }

    // MARK: - Trigger

    private func triggerAnimation() {
        switch selectedAnimation {
        case .spring:
            withAnimation(.spring(response: springResponse, dampingFraction: springDamping)) {
                isAnimating.toggle()
            }
        case .phase:
            withAnimation(.easeInOut(duration: 1.0)) {
                isAnimating.toggle()
            }
        case .keyframe:
            withAnimation(.spring(response: 0.6, dampingFraction: 0.5)) {
                isAnimating.toggle()
            }
        case .bounce:
            withAnimation(.interpolatingSpring(stiffness: 200, damping: 10)) {
                isAnimating.toggle()
                bounceCount += 1
            }
        }
    }

    // MARK: - Selector

    private var animationSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Animation Type")
                .font(.headline)
            Picker("Type", selection: $selectedAnimation) {
                ForEach(AnimationType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    // MARK: - Spring Controls

    private var springControls: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Spring Parameters")
                .font(.headline)
            VStack(alignment: .leading, spacing: 4) {
                Text("Response: \(springResponse, specifier: "%.2f")")
                    .font(.caption)
                Slider(value: $springResponse, in: 0.1...2.0)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Damping: \(springDamping, specifier: "%.2f")")
                    .font(.caption)
                Slider(value: $springDamping, in: 0.1...1.0)
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Code

    private var codeSection: some View {
        CodeSnippetView(
            code: """
            // Spring animation
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                isExpanded.toggle()
            }

            // Phase animator
            PhaseAnimator([false, true]) { content, phase in
                content
                    .scaleEffect(phase ? 1.2 : 1.0)
                    .rotationEffect(.degrees(phase ? 360 : 0))
            }
            """,
            language: "swift"
        )
    }
}

// MARK: - Animation Type

enum AnimationType: String, CaseIterable {
    case spring = "Spring"
    case phase = "Phase"
    case keyframe = "Keyframe"
    case bounce = "Bounce"
}
