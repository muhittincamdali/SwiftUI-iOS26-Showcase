import FoundationModels
import SwiftUI

struct FoundationModelsDemo: View {
    enum OutputMode: String, CaseIterable, Identifiable {
        case text, structured
        var id: Self { self }
    }

    private static let instructions = "You help name small apps. Keep answers short."

    @State private var prompt = "A habit tracker for people who forget to drink water"
    @State private var mode: OutputMode = .structured
    @State private var session = LanguageModelSession(instructions: instructions)
    @State private var textResponse: String?
    @State private var ideas: AppNameIdeas?
    @State private var errorMessage: String?
    @State private var isResponding = false

    private let model = SystemLanguageModel.default

    var body: some View {
        DemoPage(demo: .foundationModels) {
            DemoSection(title: "Model status") {
                Label(
                    ModelAvailabilityMessage.text(for: model.availability),
                    systemImage: model.isAvailable ? "checkmark.circle" : "exclamationmark.triangle"
                )
                .foregroundStyle(model.isAvailable ? .green : .orange)
            }

            DemoSection(title: "Prompt") {
                TextField("Describe an app", text: $prompt, axis: .vertical)
                    .lineLimit(2...4)
                    .textFieldStyle(.roundedBorder)
                Picker("Output", selection: $mode) {
                    ForEach(OutputMode.allCases) { Text($0.rawValue.capitalized).tag($0) }
                }
                .pickerStyle(.segmented)
                Button("Ask the model", systemImage: "sparkles") {
                    Task { await respond() }
                }
                .buttonStyle(.glassProminent)
                .disabled(!model.isAvailable || isResponding || prompt.trimmingCharacters(in: .whitespaces).isEmpty)
            }

            DemoSection(title: "Response") {
                responseView
            }
        }
    }

    @ViewBuilder
    private var responseView: some View {
        if isResponding {
            ProgressView()
        } else if let errorMessage {
            Text(errorMessage)
                .foregroundStyle(.red)
        } else if mode == .structured, let ideas {
            ForEach(ideas.names, id: \.self) { name in
                Label(name, systemImage: "app.badge")
            }
            Text(ideas.theme)
                .foregroundStyle(.secondary)
        } else if mode == .text, let textResponse {
            Text(textResponse)
        } else {
            Text("No response yet.")
                .foregroundStyle(.secondary)
        }
    }

    private func respond() async {
        isResponding = true
        errorMessage = nil
        defer { isResponding = false }
        do {
            switch mode {
            case .text:
                textResponse = try await session.respond(to: prompt).content
            case .structured:
                ideas = try await session.respond(to: prompt, generating: AppNameIdeas.self).content
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

/// Structured output for the demo. The model fills the properties directly,
/// guided by the `@Guide` descriptions.
@Generable
struct AppNameIdeas {
    @Guide(description: "Short, memorable app names", .count(3))
    var names: [String]

    @Guide(description: "One sentence describing what the names have in common")
    var theme: String
}

/// User-facing text for the on-device model's availability.
enum ModelAvailabilityMessage {
    static func text(for availability: SystemLanguageModel.Availability) -> String {
        switch availability {
        case .available:
            "The on-device model is ready."
        case .unavailable(.deviceNotEligible):
            "This device does not support Apple Intelligence."
        case .unavailable(.appleIntelligenceNotEnabled):
            "Turn on Apple Intelligence in Settings to use this demo."
        case .unavailable(.modelNotReady):
            "The model is still downloading or preparing. Try again later."
        case .unavailable:
            "The on-device model is unavailable."
        }
    }
}

#Preview {
    NavigationStack { FoundationModelsDemo() }
}
