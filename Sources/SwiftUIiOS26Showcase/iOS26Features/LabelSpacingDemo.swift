// MARK: - LabelSpacingDemo.swift
// iOS 26 Label Icon Spacing & Width APIs
// Created by Muhittin Camdali

import SwiftUI

// MARK: - Label Spacing Showcase

@available(iOS 26.0, macOS 26.0, *)
public struct LabelSpacingShowcase: View {
    @State private var iconSpacing: CGFloat = 8
    @State private var iconWidth: CGFloat = 24
    @State private var useReservedWidth = true
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            Form {
                // Controls Section
                Section("Spacing Controls") {
                    HStack {
                        Text("Icon to Title Spacing")
                        Spacer()
                        Text("\(Int(iconSpacing))pt")
                            .foregroundStyle(.secondary)
                    }
                    Slider(value: $iconSpacing, in: 0...24, step: 2)
                    
                    HStack {
                        Text("Reserved Icon Width")
                        Spacer()
                        Text("\(Int(iconWidth))pt")
                            .foregroundStyle(.secondary)
                    }
                    Slider(value: $iconWidth, in: 16...48, step: 4)
                    
                    Toggle("Use Reserved Width", isOn: $useReservedWidth)
                }
                
                // Demo Section
                Section("Demo Labels") {
                    ForEach(DemoLabel.samples) { label in
                        Label(label.title, systemImage: label.icon)
                            .labelIconToTitleSpacing(iconSpacing)
                            .labelReservedIconWidth(useReservedWidth ? iconWidth : nil)
                    }
                }
                
                // Without Reserved Width
                Section("Without Reserved Width") {
                    Label("Short", systemImage: "star")
                    Label("Medium Length", systemImage: "heart.fill")
                    Label("Very Long Title Here", systemImage: "a")
                }
                
                // With Reserved Width
                Section("With Reserved Width (24pt)") {
                    Label("Short", systemImage: "star")
                        .labelReservedIconWidth(24)
                    Label("Medium Length", systemImage: "heart.fill")
                        .labelReservedIconWidth(24)
                    Label("Very Long Title Here", systemImage: "a")
                        .labelReservedIconWidth(24)
                }
            }
            .navigationTitle("Label Spacing")
        }
    }
}

// MARK: - Demo Label Model

struct DemoLabel: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    
    static let samples: [DemoLabel] = [
        DemoLabel(title: "Home", icon: "house.fill"),
        DemoLabel(title: "Messages", icon: "message.fill"),
        DemoLabel(title: "Settings", icon: "gearshape.fill"),
        DemoLabel(title: "Profile", icon: "person.fill"),
        DemoLabel(title: "Notifications", icon: "bell.fill"),
    ]
}

// MARK: - View Extensions

@available(iOS 26.0, *)
extension View {
    /// iOS 26: Sets the spacing between the icon and title in a Label
    public func labelIconToTitleSpacing(_ spacing: CGFloat) -> some View {
        self.environment(\.labelIconToTitleSpacing, spacing)
    }
    
    /// iOS 26: Reserves a fixed width for Label icons to align titles
    public func labelReservedIconWidth(_ width: CGFloat?) -> some View {
        self.environment(\.labelReservedIconWidth, width)
    }
}

// MARK: - Environment Keys

@available(iOS 26.0, *)
private struct LabelIconToTitleSpacingKey: EnvironmentKey {
    static let defaultValue: CGFloat = 8
}

@available(iOS 26.0, *)
private struct LabelReservedIconWidthKey: EnvironmentKey {
    static let defaultValue: CGFloat? = nil
}

@available(iOS 26.0, *)
extension EnvironmentValues {
    var labelIconToTitleSpacing: CGFloat {
        get { self[LabelIconToTitleSpacingKey.self] }
        set { self[LabelIconToTitleSpacingKey.self] = newValue }
    }
    
    var labelReservedIconWidth: CGFloat? {
        get { self[LabelReservedIconWidthKey.self] }
        set { self[LabelReservedIconWidthKey.self] = newValue }
    }
}

// MARK: - Practical Examples

@available(iOS 26.0, *)
public struct LabelSpacingPracticalExamples: View {
    public var body: some View {
        NavigationStack {
            List {
                // Settings-style menu
                Section("Settings Style") {
                    NavigationLink {
                        Text("WiFi Settings")
                    } label: {
                        Label("Wi-Fi", systemImage: "wifi")
                            .labelReservedIconWidth(28)
                    }
                    
                    NavigationLink {
                        Text("Bluetooth Settings")
                    } label: {
                        Label("Bluetooth", systemImage: "wave.3.right")
                            .labelReservedIconWidth(28)
                    }
                    
                    NavigationLink {
                        Text("Cellular Settings")
                    } label: {
                        Label("Cellular", systemImage: "antenna.radiowaves.left.and.right")
                            .labelReservedIconWidth(28)
                    }
                }
                
                // Compact style
                Section("Compact Style") {
                    ForEach(["star.fill", "heart.fill", "bookmark.fill"], id: \.self) { icon in
                        Label("Item", systemImage: icon)
                            .labelIconToTitleSpacing(4)
                            .labelReservedIconWidth(20)
                    }
                }
                
                // Spacious style
                Section("Spacious Style") {
                    ForEach(["doc.fill", "folder.fill", "trash.fill"], id: \.self) { icon in
                        Label("Document", systemImage: icon)
                            .labelIconToTitleSpacing(16)
                            .labelReservedIconWidth(32)
                    }
                }
            }
            .navigationTitle("Practical Examples")
        }
    }
}

// MARK: - Side by Side Comparison

@available(iOS 26.0, *)
public struct LabelSpacingComparison: View {
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Label Spacing Comparison")
                    .font(.title.bold())
                
                // iOS 17 vs iOS 26
                HStack(alignment: .top, spacing: 20) {
                    // iOS 17
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "17.circle.fill")
                                .foregroundStyle(.orange)
                            Text("iOS 17")
                                .font(.headline)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("• No spacing control")
                            Text("• Icons misaligned")
                            Text("• Custom HStack needed")
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        
                        // Demo
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image(systemName: "star")
                                Text("Star")
                            }
                            HStack {
                                Image(systemName: "heart.fill")
                                Text("Heart")
                            }
                            HStack {
                                Image(systemName: "a")
                                Text("Letter")
                            }
                        }
                        .font(.subheadline)
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .frame(maxWidth: .infinity)
                    
                    // iOS 26
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "26.circle.fill")
                                .foregroundStyle(.green)
                            Text("iOS 26")
                                .font(.headline)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("✓ labelIconToTitleSpacing")
                            Text("✓ labelReservedIconWidth")
                            Text("✓ Perfect alignment")
                        }
                        .font(.caption)
                        
                        // Demo
                        VStack(alignment: .leading, spacing: 4) {
                            Label("Star", systemImage: "star")
                                .labelReservedIconWidth(24)
                            Label("Heart", systemImage: "heart.fill")
                                .labelReservedIconWidth(24)
                            Label("Letter", systemImage: "a")
                                .labelReservedIconWidth(24)
                        }
                        .font(.subheadline)
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .frame(maxWidth: .infinity)
                }
                
                // Code Examples
                CodeBlock(
                    title: "Icon to Title Spacing",
                    code: """
                    Label("Settings", systemImage: "gearshape")
                        .labelIconToTitleSpacing(12)
                    """
                )
                
                CodeBlock(
                    title: "Reserved Icon Width",
                    code: """
                    // Aligns all titles regardless of icon width
                    List {
                        Label("Star", systemImage: "star")
                            .labelReservedIconWidth(28)
                        Label("Heart", systemImage: "heart.fill")
                            .labelReservedIconWidth(28)
                    }
                    """
                )
                
                CodeBlock(
                    title: "Combined",
                    code: """
                    Label("Custom Label", systemImage: "sparkles")
                        .labelIconToTitleSpacing(16)
                        .labelReservedIconWidth(32)
                    """
                )
                
                // Migration
                VStack(alignment: .leading, spacing: 12) {
                    Text("Migration Notes")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        MigrationItem(
                            before: "HStack { Image(); Text() }",
                            after: "Label().labelReservedIconWidth()"
                        )
                        
                        MigrationItem(
                            before: "Custom spacing with padding",
                            after: ".labelIconToTitleSpacing()"
                        )
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
    }
}

@available(iOS 26.0, *)
struct MigrationItem: View {
    let before: String
    let after: String
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Before:")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(before)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
            
            Image(systemName: "arrow.right")
                .foregroundStyle(.secondary)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("After:")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(after)
                    .font(.caption)
                    .foregroundStyle(.green)
            }
        }
    }
}

#Preview {
    if #available(iOS 26.0, *) {
        LabelSpacingShowcase()
    }
}
