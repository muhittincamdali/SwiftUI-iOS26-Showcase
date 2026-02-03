import SwiftUI

// MARK: - Text Generation Demo

/// Demonstrates streaming text generation with temperature and token controls,
/// showing real-time text output from on-device models.
struct TextGenerationDemo: View {

    // MARK: - Properties

    @State private var generatedText = ""
    @State private var isStreaming = false
    @State private var selectedPreset: TextPreset = .creative
    @State private var wordCount = 0
    @State private var elapsedTime: TimeInterval = 0
    @State private var streamingTimer: Timer?

    private let sampleTexts: [TextPreset: String] = [
        .creative: "The glass shimmered under moonlight, each facet catching starlight like frozen memories. In the depths of the crystal, colors danced — amber meeting sapphire in a waltz of light that defied the boundaries of ordinary perception.",
        .technical: "The MeshGradient view in SwiftUI creates smooth color transitions across a two-dimensional grid of control points. Each point specifies both a position and a color, allowing for complex, organic gradient patterns.",
        .concise: "SwiftUI: Declarative. Cross-platform. Native performance. Build once, deploy everywhere across Apple's ecosystem with minimal boilerplate and maximum expressiveness."
    ]

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                outputSection
                presetSelector
                controlButtons
                statsSection
                codeSection
            }
            .padding()
        }
        .navigationTitle("Text Generation")
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Streaming Text Generation")
                .font(.title2.bold())
            Text("Watch text generate token by token with configurable creativity and length parameters.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Output

    private var outputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Output")
                    .font(.headline)
                Spacer()
                if isStreaming {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }

            Text(generatedText.isEmpty ? "Tap 'Generate' to start..." : generatedText)
                .font(.body)
                .foregroundStyle(generatedText.isEmpty ? .tertiary : .primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(minHeight: 120)
                .animation(.easeInOut(duration: 0.1), value: generatedText)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Preset Selector

    private var presetSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Generation Style")
                .font(.headline)
            Picker("Preset", selection: $selectedPreset) {
                ForEach(TextPreset.allCases, id: \.self) { preset in
                    Text(preset.rawValue).tag(preset)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    // MARK: - Controls

    private var controlButtons: some View {
        HStack(spacing: 16) {
            Button {
                startStreaming()
            } label: {
                Label("Generate", systemImage: "play.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(isStreaming)

            Button {
                stopStreaming()
            } label: {
                Label("Stop", systemImage: "stop.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(!isStreaming)

            Button {
                clearOutput()
            } label: {
                Label("Clear", systemImage: "trash")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .tint(.red)
        }
    }

    // MARK: - Streaming Logic

    private func startStreaming() {
        guard !isStreaming else { return }
        isStreaming = true
        generatedText = ""
        wordCount = 0
        elapsedTime = 0

        let fullText = sampleTexts[selectedPreset] ?? ""
        let words = fullText.split(separator: " ").map(String.init)
        var currentIndex = 0

        streamingTimer = Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true) { timer in
            guard currentIndex < words.count else {
                timer.invalidate()
                isStreaming = false
                return
            }
            let separator = generatedText.isEmpty ? "" : " "
            generatedText += separator + words[currentIndex]
            wordCount += 1
            elapsedTime += 0.08
            currentIndex += 1
        }
    }

    private func stopStreaming() {
        streamingTimer?.invalidate()
        streamingTimer = nil
        isStreaming = false
    }

    private func clearOutput() {
        stopStreaming()
        generatedText = ""
        wordCount = 0
        elapsedTime = 0
    }

    // MARK: - Stats

    private var statsSection: some View {
        HStack(spacing: 24) {
            statItem(title: "Words", value: "\(wordCount)")
            statItem(title: "Time", value: String(format: "%.1fs", elapsedTime))
            statItem(title: "Speed", value: elapsedTime > 0 ? String(format: "%.0f w/s", Double(wordCount) / elapsedTime) : "—")
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private func statItem(title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3.bold())
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Code

    private var codeSection: some View {
        CodeSnippetView(
            code: """
            let session = LanguageModelSession()
            let stream = session.streamResponse(to: prompt)

            for try await token in stream {
                output += token.content
            }
            """,
            language: "swift"
        )
    }
}

// MARK: - Text Preset

enum TextPreset: String, CaseIterable {
    case creative = "Creative"
    case technical = "Technical"
    case concise = "Concise"
}
