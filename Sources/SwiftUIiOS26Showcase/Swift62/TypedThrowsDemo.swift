import SwiftUI

// MARK: - Typed Throws Demo

/// Demonstrates typed throws with exhaustive error handling,
/// a key new feature in Swift 6.2 for type-safe error management.
struct TypedThrowsDemo: View {

    // MARK: - Properties

    @State private var result: String = ""
    @State private var selectedScenario: ThrowScenario = .success
    @State private var showExplanation = false

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                scenarioSelector
                resultSection
                runButton
                explanationSection
                codeSection
            }
            .padding()
        }
        .navigationTitle("Typed Throws")
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Typed Throws")
                .font(.title2.bold())
            Text("Swift 6.2 lets functions declare exactly which error types they throw, enabling exhaustive catch blocks.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Scenario Selector

    private var scenarioSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Test Scenario")
                .font(.headline)
            Picker("Scenario", selection: $selectedScenario) {
                ForEach(ThrowScenario.allCases, id: \.self) { scenario in
                    Text(scenario.rawValue).tag(scenario)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    // MARK: - Result

    private var resultSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Result")
                .font(.headline)
            Text(result.isEmpty ? "Tap 'Execute' to test the scenario" : result)
                .font(.body.monospaced())
                .foregroundStyle(result.contains("Error") ? .red : .green)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Run Button

    private var runButton: some View {
        Button {
            executeScenario()
        } label: {
            Label("Execute", systemImage: "play.fill")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
    }

    // MARK: - Execute

    private func executeScenario() {
        switch selectedScenario {
        case .success:
            result = "✅ Success: Data loaded (1,024 bytes)"
        case .timeout:
            result = "❌ Error(NetworkError.timeout): Connection timed out after 30s"
        case .invalidResponse:
            result = "❌ Error(NetworkError.invalidResponse): Status 404"
        case .unauthorized:
            result = "❌ Error(NetworkError.unauthorized): Token expired"
        }
    }

    // MARK: - Explanation

    private var explanationSection: some View {
        DisclosureGroup("How It Works", isExpanded: $showExplanation) {
            VStack(alignment: .leading, spacing: 8) {
                explanationItem(icon: "1.circle.fill", text: "Declare error type in function signature: throws(NetworkError)")
                explanationItem(icon: "2.circle.fill", text: "Compiler enforces only that error type can be thrown")
                explanationItem(icon: "3.circle.fill", text: "Catch blocks become exhaustive — handle every case")
                explanationItem(icon: "4.circle.fill", text: "No more generic 'catch' needed for known error types")
            }
            .padding(.top, 8)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private func explanationItem(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(.blue)
            Text(text)
                .font(.subheadline)
        }
    }

    // MARK: - Code

    private var codeSection: some View {
        CodeSnippetView(
            code: """
            enum NetworkError: Error {
                case timeout
                case invalidResponse(statusCode: Int)
                case unauthorized
            }

            func fetchData() throws(NetworkError) -> Data {
                guard isAuthorized else {
                    throw .unauthorized
                }
                // Only NetworkError can be thrown here
                return try loadFromNetwork()
            }

            // Exhaustive catch:
            do {
                let data = try fetchData()
            } catch .timeout {
                retry()
            } catch .invalidResponse(let code) {
                log("Status: \\(code)")
            } catch .unauthorized {
                refreshToken()
            }
            """,
            language: "swift"
        )
    }
}

// MARK: - Throw Scenario

enum ThrowScenario: String, CaseIterable {
    case success = "Success"
    case timeout = "Timeout"
    case invalidResponse = "Invalid"
    case unauthorized = "Unauth"
}
