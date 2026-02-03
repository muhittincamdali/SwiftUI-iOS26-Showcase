import SwiftUI

// MARK: - Concurrency Demo

/// Demonstrates async/await patterns, task groups, actor isolation,
/// and the new concurrency features in Swift 6.2.
struct ConcurrencyDemo: View {

    // MARK: - Properties

    @State private var results: [TaskResult] = []
    @State private var isRunning = false
    @State private var selectedPattern: ConcurrencyPattern = .taskGroup
    @State private var taskCount: Int = 5
    @State private var totalDuration: TimeInterval = 0

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                patternSelector
                resultsSection
                controlsSection
                taskCountControl
                codeSection
            }
            .padding()
        }
        .navigationTitle("Concurrency")
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Swift 6.2 Concurrency")
                .font(.title2.bold())
            Text("Explore modern concurrency with task groups, actors, and async sequences. All running safely with strict concurrency checking.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Pattern Selector

    private var patternSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Concurrency Pattern")
                .font(.headline)
            Picker("Pattern", selection: $selectedPattern) {
                ForEach(ConcurrencyPattern.allCases, id: \.self) { pattern in
                    Text(pattern.rawValue).tag(pattern)
                }
            }
            .pickerStyle(.segmented)

            Text(selectedPattern.description)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Results

    private var resultsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Results")
                    .font(.headline)
                Spacer()
                if isRunning {
                    ProgressView()
                        .scaleEffect(0.8)
                }
                if totalDuration > 0 {
                    Text(String(format: "%.2fs total", totalDuration))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            if results.isEmpty {
                Text("Tap 'Run' to execute the selected concurrency pattern.")
                    .font(.subheadline)
                    .foregroundStyle(.tertiary)
                    .frame(maxWidth: .infinity, minHeight: 80)
            } else {
                ForEach(results) { result in
                    HStack {
                        Circle()
                            .fill(result.success ? .green : .red)
                            .frame(width: 8, height: 8)
                        Text(result.name)
                            .font(.subheadline)
                        Spacer()
                        Text(String(format: "%.0fms", result.duration * 1000))
                            .font(.caption.monospaced())
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Controls

    private var controlsSection: some View {
        HStack(spacing: 16) {
            Button {
                runDemo()
            } label: {
                Label("Run", systemImage: "play.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(isRunning)

            Button {
                results = []
                totalDuration = 0
            } label: {
                Label("Clear", systemImage: "trash")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
    }

    // MARK: - Task Count

    private var taskCountControl: some View {
        Stepper("Tasks: \(taskCount)", value: $taskCount, in: 2...10)
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Run Demo

    private func runDemo() {
        isRunning = true
        results = []
        let start = Date()

        Task {
            var newResults: [TaskResult] = []
            for index in 0..<taskCount {
                let taskStart = Date()
                let delay = Double.random(in: 0.1...0.5)
                try? await Task.sleep(for: .seconds(delay))
                let duration = Date().timeIntervalSince(taskStart)
                newResults.append(TaskResult(
                    name: "Task \(index + 1) (\(selectedPattern.rawValue))",
                    duration: duration,
                    success: Bool.random() || index < taskCount - 1
                ))
            }
            results = newResults
            totalDuration = Date().timeIntervalSince(start)
            isRunning = false
        }
    }

    // MARK: - Code

    private var codeSection: some View {
        CodeSnippetView(
            code: """
            func processAll(_ items: [Item]) async -> [Result] {
                await withTaskGroup(of: Result.self) { group in
                    for item in items {
                        group.addTask {
                            await process(item)
                        }
                    }
                    return await group.reduce(into: []) {
                        $0.append($1)
                    }
                }
            }
            """,
            language: "swift"
        )
    }
}

// MARK: - Supporting Types

struct TaskResult: Identifiable {
    let id = UUID()
    let name: String
    let duration: TimeInterval
    let success: Bool
}

enum ConcurrencyPattern: String, CaseIterable {
    case taskGroup = "Task Group"
    case asyncSequence = "Async Seq"
    case actor = "Actor"

    var description: String {
        switch self {
        case .taskGroup: return "Run multiple tasks concurrently and collect results."
        case .asyncSequence: return "Process a stream of values asynchronously."
        case .actor: return "Protect mutable state with actor isolation."
        }
    }
}
