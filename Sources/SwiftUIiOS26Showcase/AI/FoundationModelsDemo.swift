import SwiftUI

// MARK: - Foundation Models Demo

/// Demonstrates on-device language model integration with structured output,
/// streaming responses, and session management using the Foundation Models framework.
struct FoundationModelsDemo: View {

    // MARK: - Properties

    @State private var prompt = "Explain SwiftUI in one sentence"
    @State private var response = ""
    @State private var isGenerating = false
    @State private var temperature: Double = 0.7
    @State private var maxTokens: Int = 256
    @State private var selectedModel: ModelOption = .standard
    @State private var showStructuredOutput = false
    @State private var conversationHistory: [ChatMessage] = []

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                chatSection
                inputSection
                modelSettings
                structuredOutputSection
                codeSection
            }
            .padding()
        }
        .navigationTitle("Foundation Models")
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "brain")
                .font(.system(size: 40))
                .foregroundStyle(.purple.gradient)
            Text("On-Device Language Models")
                .font(.title2.bold())
            Text("Run language models entirely on-device with the Foundation Models framework. No network required.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Chat Section

    private var chatSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(conversationHistory) { message in
                HStack {
                    if message.isUser { Spacer() }
                    Text(message.content)
                        .padding(12)
                        .background(
                            message.isUser ? Color.blue : Color(.systemGray5),
                            in: RoundedRectangle(cornerRadius: 16)
                        )
                        .foregroundStyle(message.isUser ? .white : .primary)
                    if !message.isUser { Spacer() }
                }
            }

            if isGenerating {
                HStack(spacing: 4) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(.secondary)
                            .frame(width: 6, height: 6)
                            .opacity(isGenerating ? 1 : 0.3)
                    }
                }
                .padding(12)
                .background(Color(.systemGray5), in: RoundedRectangle(cornerRadius: 16))
            }
        }
        .frame(minHeight: 100)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Input Section

    private var inputSection: some View {
        HStack(spacing: 12) {
            TextField("Ask something...", text: $prompt, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(1...4)

            Button {
                sendMessage()
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.blue)
            }
            .disabled(prompt.isEmpty || isGenerating)
        }
    }

    // MARK: - Send Message

    private func sendMessage() {
        guard !prompt.isEmpty else { return }
        let userMessage = ChatMessage(content: prompt, isUser: true)
        conversationHistory.append(userMessage)

        isGenerating = true
        let currentPrompt = prompt
        prompt = ""

        // Simulated response for demo purposes
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let responseText = generateDemoResponse(for: currentPrompt)
            conversationHistory.append(ChatMessage(content: responseText, isUser: false))
            isGenerating = false
        }
    }

    private func generateDemoResponse(for input: String) -> String {
        let responses = [
            "SwiftUI is Apple's declarative framework for building user interfaces across all Apple platforms with minimal code.",
            "The Foundation Models framework provides on-device inference capabilities for natural language tasks.",
            "iOS 26 introduces Liquid Glass, a new visual design language that brings depth and translucency to UI elements.",
            "Swift 6.2 brings improved concurrency with typed throws and enhanced actor isolation.",
            "On-device models run without network connectivity, ensuring privacy and low latency."
        ]
        return responses[abs(input.hashValue) % responses.count]
    }

    // MARK: - Model Settings

    private var modelSettings: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Model Configuration")
                .font(.headline)

            Picker("Model", selection: $selectedModel) {
                ForEach(ModelOption.allCases, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.segmented)

            VStack(alignment: .leading, spacing: 4) {
                Text("Temperature: \(temperature, specifier: "%.1f")")
                    .font(.caption)
                Slider(value: $temperature, in: 0...2)
            }

            Stepper("Max Tokens: \(maxTokens)", value: $maxTokens, in: 64...1024, step: 64)
                .font(.caption)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Structured Output

    private var structuredOutputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Toggle("Structured Output", isOn: $showStructuredOutput)
                .font(.headline)

            if showStructuredOutput {
                Text("Define output schemas with @Generable to get typed responses from the model.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                CodeSnippetView(
                    code: """
                    @Generable
                    struct MovieReview {
                        var title: String
                        var rating: Int
                        var summary: String
                    }
                    """,
                    language: "swift"
                )
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Code

    private var codeSection: some View {
        CodeSnippetView(
            code: """
            let session = LanguageModelSession()
            let response = try await session.respond(
                to: "Explain SwiftUI in one sentence",
                options: .init(temperature: 0.7)
            )
            print(response.content)
            """,
            language: "swift"
        )
    }
}

// MARK: - Supporting Types

struct ChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
}

enum ModelOption: String, CaseIterable {
    case standard = "Standard"
    case compact = "Compact"
    case large = "Large"
}
