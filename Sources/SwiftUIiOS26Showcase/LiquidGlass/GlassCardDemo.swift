import SwiftUI

// MARK: - Glass Card Demo

/// Demonstrates card components with frosted glass appearance,
/// suitable for dashboards, profiles, and information displays.
struct GlassCardDemo: View {

    // MARK: - Properties

    @State private var selectedCard: Int?
    @State private var cardCornerRadius: CGFloat = 20

    private let cardData: [(String, String, String, Color)] = [
        ("cloud.sun.fill", "Weather", "23°C Sunny", .orange),
        ("heart.fill", "Health", "8,432 steps", .red),
        ("music.note", "Now Playing", "Midnight Rain", .purple),
        ("chart.bar.fill", "Analytics", "+24% growth", .green),
        ("airplane", "Travel", "SFO → IST", .blue),
        ("camera.fill", "Photos", "1,204 new", .pink)
    ]

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                cardsGrid
                radiusControl
                codeSection
            }
            .padding()
        }
        .navigationTitle("Glass Cards")
        .background(backgroundGradient)
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Frosted Glass Cards")
                .font(.title2.bold())
            Text("Build beautiful card interfaces with depth and translucency using glass materials.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Cards Grid

    private var cardsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ], spacing: 16) {
            ForEach(0..<cardData.count, id: \.self) { index in
                let card = cardData[index]
                glassCard(icon: card.0, title: card.1, value: card.2, color: card.3, index: index)
            }
        }
    }

    // MARK: - Glass Card

    private func glassCard(icon: String, title: String, value: String, color: Color, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.headline)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cardCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: cardCornerRadius)
                .stroke(.white.opacity(selectedCard == index ? 0.3 : 0.1), lineWidth: 1)
        )
        .scaleEffect(selectedCard == index ? 0.95 : 1.0)
        .animation(.spring(response: 0.3), value: selectedCard)
        .onTapGesture {
            selectedCard = selectedCard == index ? nil : index
        }
    }

    // MARK: - Radius Control

    private var radiusControl: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Corner Radius: \(Int(cardCornerRadius))")
                .font(.caption)
            Slider(value: $cardCornerRadius, in: 0...32)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Code

    private var codeSection: some View {
        CodeSnippetView(
            code: """
            VStack(alignment: .leading) {
                Image(systemName: "cloud.sun.fill")
                Text("Weather")
                Text("23°C Sunny").font(.headline)
            }
            .padding()
            .background(.ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 20))
            """,
            language: "swift"
        )
    }

    // MARK: - Background

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [.black, .indigo.opacity(0.3), .purple.opacity(0.2)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
