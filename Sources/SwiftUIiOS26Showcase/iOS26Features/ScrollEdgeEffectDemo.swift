// MARK: - ScrollEdgeEffectDemo.swift
// iOS 26 Scroll Edge Effect Styles
// Created by Muhittin Camdali

import SwiftUI

// MARK: - Scroll Edge Effect Showcase

@available(iOS 26.0, macOS 26.0, *)
public struct ScrollEdgeEffectShowcase: View {
    @State private var selectedStyle: ScrollEdgeEffectStyle = .automatic
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    // Style Picker
                    stylePicker
                    
                    // Info Card
                    InfoCard(
                        title: "Scroll Edge Effect",
                        description: "iOS 26 applies a subtle blur and fade effect to content under system toolbars. This keeps controls legible while content scrolls underneath.",
                        icon: "rectangle.and.text.magnifyingglass"
                    )
                    
                    // Content Cards
                    ForEach(0..<25) { index in
                        ContentRow(index: index)
                    }
                }
                .padding()
            }
            .scrollEdgeEffectStyle(selectedStyle)
            .navigationTitle("Scroll Edge Effect")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                    
                    Button {
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    private var stylePicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Edge Effect Style")
                .font(.headline)
            
            Picker("Style", selection: $selectedStyle) {
                Text("Automatic").tag(ScrollEdgeEffectStyle.automatic)
                Text("Soft").tag(ScrollEdgeEffectStyle.soft)
                Text("Hard").tag(ScrollEdgeEffectStyle.hard)
                Text("None").tag(ScrollEdgeEffectStyle.none)
            }
            .pickerStyle(.segmented)
            
            Text(selectedStyle.description)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Scroll Edge Effect Style

@available(iOS 26.0, *)
public enum ScrollEdgeEffectStyle: String, CaseIterable {
    case automatic
    case soft
    case hard
    case none
    
    var description: String {
        switch self {
        case .automatic:
            return "System decides based on context - default for most apps"
        case .soft:
            return "Subtle blur/fade - good for content-heavy UIs"
        case .hard:
            return "Sharp transition - for dense UIs like Calendar"
        case .none:
            return "No effect - content clips at toolbar edge"
        }
    }
}

// MARK: - View Extension

@available(iOS 26.0, *)
extension View {
    public func scrollEdgeEffectStyle(_ style: ScrollEdgeEffectStyle) -> some View {
        self.environment(\.scrollEdgeEffectStyle, style)
    }
}

@available(iOS 26.0, *)
private struct ScrollEdgeEffectStyleKey: EnvironmentKey {
    static let defaultValue: ScrollEdgeEffectStyle = .automatic
}

@available(iOS 26.0, *)
extension EnvironmentValues {
    var scrollEdgeEffectStyle: ScrollEdgeEffectStyle {
        get { self[ScrollEdgeEffectStyleKey.self] }
        set { self[ScrollEdgeEffectStyleKey.self] = newValue }
    }
}

// MARK: - Content Row

@available(iOS 26.0, *)
struct ContentRow: View {
    let index: Int
    
    private let colors: [Color] = [.blue, .green, .orange, .purple, .pink, .red, .teal, .indigo]
    
    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 12)
                .fill(colors[index % colors.count].gradient)
                .frame(width: 60, height: 60)
                .overlay {
                    Text("\(index + 1)")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Content Item \(index + 1)")
                    .font(.headline)
                
                Text("Scroll to see the edge effect in action under the toolbar")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
    }
}

// MARK: - Dense UI Example (Calendar Style)

@available(iOS 26.0, *)
public struct DenseUIScrollExample: View {
    @State private var selectedDate = Date()
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 1) {
                    ForEach(0..<50) { hour in
                        HStack {
                            Text(String(format: "%02d:00", hour % 24))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .frame(width: 50, alignment: .trailing)
                            
                            Divider()
                            
                            if hour % 5 == 0 {
                                EventBlock(title: "Event at \(hour):00")
                            } else {
                                Spacer()
                            }
                        }
                        .frame(height: 60)
                    }
                }
                .padding()
            }
            .scrollEdgeEffectStyle(.hard)
            .navigationTitle("Calendar")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Today")
                        .font(.headline)
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                    
                    Button {
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

@available(iOS 26.0, *)
struct EventBlock: View {
    let title: String
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.blue)
                .frame(width: 4)
            
            Text(title)
                .font(.subheadline)
            
            Spacer()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.blue.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

// MARK: - List with Scroll Edge

@available(iOS 26.0, *)
public struct ListScrollEdgeExample: View {
    @State private var style: ScrollEdgeEffectStyle = .automatic
    
    public var body: some View {
        NavigationStack {
            List {
                Section("Settings") {
                    Picker("Edge Effect", selection: $style) {
                        ForEach(ScrollEdgeEffectStyle.allCases, id: \.self) { s in
                            Text(s.rawValue.capitalized).tag(s)
                        }
                    }
                }
                
                Section("Items") {
                    ForEach(0..<30) { index in
                        HStack {
                            Circle()
                                .fill(Color.blue.gradient)
                                .frame(width: 36, height: 36)
                            
                            VStack(alignment: .leading) {
                                Text("Item \(index + 1)")
                                    .font(.body)
                                Text("Subtitle")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .scrollEdgeEffectStyle(style)
            .navigationTitle("List Example")
        }
    }
}

// MARK: - Code Example

@available(iOS 26.0, *)
public struct ScrollEdgeEffectCodeExample: View {
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Scroll Edge Effect")
                    .font(.title.bold())
                
                Text("Controls the visual transition between content and system toolbars during scrolling.")
                    .foregroundStyle(.secondary)
                
                CodeBlock(
                    title: "Basic Usage",
                    code: """
                    ScrollView {
                        // Content
                    }
                    .scrollEdgeEffectStyle(.soft)
                    """
                )
                
                CodeBlock(
                    title: "With List",
                    code: """
                    List {
                        // Items
                    }
                    .scrollEdgeEffectStyle(.hard)
                    """
                )
                
                // Style comparison
                VStack(alignment: .leading, spacing: 12) {
                    Text("Style Comparison")
                        .font(.headline)
                    
                    ForEach(ScrollEdgeEffectStyle.allCases, id: \.self) { style in
                        HStack {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(colorFor(style))
                                .frame(width: 8)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(style.rawValue.capitalized)
                                    .font(.subheadline.bold())
                                Text(style.description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Migration
                VStack(alignment: .leading, spacing: 12) {
                    Text("Migration Notes")
                        .font(.headline)
                    
                    Text("""
                    If your app has custom backgrounds or darkening effects behind toolbars:
                    
                    1. Remove custom backgrounds - they interfere with the new effect
                    2. Let iOS 26 handle the visual transition automatically
                    3. Use .scrollEdgeEffectStyle(.hard) for dense UIs
                    """)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
    }
    
    private func colorFor(_ style: ScrollEdgeEffectStyle) -> Color {
        switch style {
        case .automatic: return .blue
        case .soft: return .green
        case .hard: return .orange
        case .none: return .gray
        }
    }
}

#Preview {
    if #available(iOS 26.0, *) {
        ScrollEdgeEffectShowcase()
    }
}
