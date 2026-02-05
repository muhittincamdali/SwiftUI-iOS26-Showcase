// MARK: - SFSymbolsDrawDemo.swift
// iOS 26 SF Symbols Draw-On Animations
// Created by Muhittin Camdali

import SwiftUI

// MARK: - SF Symbols Draw Showcase

@available(iOS 26.0, macOS 26.0, *)
public struct SFSymbolsDrawShowcase: View {
    @State private var animate = false
    @State private var selectedEffect: SymbolEffect = .drawOn
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    // Hero Animation
                    heroSection
                    
                    // Effect Picker
                    effectPicker
                    
                    // Symbol Grid
                    symbolGrid
                    
                    // Interactive Examples
                    interactiveExamples
                    
                    // Code Examples
                    codeExamples
                }
                .padding()
            }
            .navigationTitle("SF Symbols")
        }
    }
    
    private var heroSection: some View {
        VStack(spacing: 20) {
            // Large animated symbol
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 120))
                .symbolEffect(selectedEffect, value: animate)
                .foregroundStyle(.green)
            
            Button("Animate") {
                animate.toggle()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding(40)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
    
    private var effectPicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Symbol Effect")
                .font(.headline)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(SymbolEffect.allCases) { effect in
                    Button {
                        selectedEffect = effect
                    } label: {
                        Text(effect.name)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(selectedEffect == effect ? Color.blue : Color(.systemGray5))
                            .foregroundStyle(selectedEffect == effect ? .white : .primary)
                            .clipShape(Capsule())
                    }
                }
            }
        }
    }
    
    private var symbolGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Draw-On Animation Examples")
                .font(.headline)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 20) {
                ForEach(drawOnSymbols, id: \.self) { symbol in
                    SymbolCard(name: symbol, effect: selectedEffect, animate: animate)
                }
            }
        }
    }
    
    private var interactiveExamples: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Interactive Examples")
                .font(.headline)
            
            HStack(spacing: 20) {
                // Checkbox
                CheckboxExample()
                
                // Favorite
                FavoriteExample()
                
                // Download
                DownloadExample()
            }
        }
    }
    
    private var codeExamples: some View {
        VStack(alignment: .leading, spacing: 16) {
            CodeBlock(
                title: "Draw-On Effect (iOS 26)",
                code: """
                Image(systemName: "checkmark.circle")
                    .symbolEffect(.drawOn, value: isChecked)
                """
            )
            
            CodeBlock(
                title: "Combined Effects",
                code: """
                Image(systemName: "star.fill")
                    .symbolEffect(.drawOn)
                    .symbolEffect(.bounce, value: isFavorite)
                """
            )
            
            CodeBlock(
                title: "Variable Value with Draw",
                code: """
                Image(systemName: "wifi", variableValue: strength)
                    .symbolEffect(.drawOn, value: isConnected)
                """
            )
        }
    }
    
    private let drawOnSymbols = [
        "checkmark.circle.fill",
        "xmark.circle.fill",
        "star.fill",
        "heart.fill",
        "bookmark.fill",
        "bell.fill",
        "flag.fill",
        "pin.fill",
        "lock.fill",
        "wifi",
        "battery.100",
        "bolt.fill"
    ]
}

// MARK: - Symbol Effect

@available(iOS 26.0, *)
enum SymbolEffect: String, CaseIterable, Identifiable {
    case drawOn
    case bounce
    case pulse
    case scale
    case variableColor
    case wiggle
    
    var id: String { rawValue }
    
    var name: String {
        switch self {
        case .drawOn: return "Draw On"
        case .bounce: return "Bounce"
        case .pulse: return "Pulse"
        case .scale: return "Scale"
        case .variableColor: return "Variable"
        case .wiggle: return "Wiggle"
        }
    }
}

// MARK: - Symbol Card

@available(iOS 26.0, *)
struct SymbolCard: View {
    let name: String
    let effect: SymbolEffect
    let animate: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: name)
                .font(.title)
                .symbolEffect(.bounce, value: animate)
                .frame(height: 44)
            
            Text(name.components(separatedBy: ".").first ?? name)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Interactive Examples

@available(iOS 26.0, *)
struct CheckboxExample: View {
    @State private var isChecked = false
    
    var body: some View {
        VStack(spacing: 8) {
            Button {
                isChecked.toggle()
            } label: {
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .font(.largeTitle)
                    .contentTransition(.symbolEffect(.replace))
                    .foregroundStyle(isChecked ? .green : .secondary)
            }
            
            Text("Checkbox")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

@available(iOS 26.0, *)
struct FavoriteExample: View {
    @State private var isFavorite = false
    
    var body: some View {
        VStack(spacing: 8) {
            Button {
                isFavorite.toggle()
            } label: {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .font(.largeTitle)
                    .contentTransition(.symbolEffect(.replace))
                    .symbolEffect(.bounce, value: isFavorite)
                    .foregroundStyle(isFavorite ? .yellow : .secondary)
            }
            
            Text("Favorite")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

@available(iOS 26.0, *)
struct DownloadExample: View {
    @State private var isDownloading = false
    @State private var isComplete = false
    
    var body: some View {
        VStack(spacing: 8) {
            Button {
                if !isDownloading && !isComplete {
                    isDownloading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isDownloading = false
                        isComplete = true
                    }
                } else if isComplete {
                    isComplete = false
                }
            } label: {
                Group {
                    if isComplete {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    } else if isDownloading {
                        Image(systemName: "arrow.down.circle")
                            .symbolEffect(.pulse)
                            .foregroundStyle(.blue)
                    } else {
                        Image(systemName: "arrow.down.circle")
                            .foregroundStyle(.secondary)
                    }
                }
                .font(.largeTitle)
                .contentTransition(.symbolEffect(.replace))
            }
            
            Text(isComplete ? "Done" : isDownloading ? "Loading" : "Download")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Variable Value Demo

@available(iOS 26.0, *)
public struct VariableValueDemo: View {
    @State private var value: Double = 0.5
    @State private var isAnimating = false
    
    public var body: some View {
        VStack(spacing: 32) {
            Text("Variable Value + Draw")
                .font(.title.bold())
            
            // WiFi
            VStack {
                Image(systemName: "wifi", variableValue: value)
                    .font(.system(size: 80))
                    .foregroundStyle(.blue)
                    .symbolEffect(.variableColor.iterative, isActive: isAnimating)
                
                Text("WiFi Signal: \(Int(value * 100))%")
                    .font(.subheadline)
            }
            
            // Speaker
            VStack {
                Image(systemName: "speaker.wave.3.fill", variableValue: value)
                    .font(.system(size: 60))
                    .foregroundStyle(.orange)
                
                Text("Volume: \(Int(value * 100))%")
                    .font(.subheadline)
            }
            
            Slider(value: $value, in: 0...1)
                .padding(.horizontal, 40)
            
            Toggle("Auto Animate", isOn: $isAnimating)
                .padding(.horizontal, 40)
            
            // Code
            Text("""
            Image(systemName: "wifi", variableValue: strength)
                .symbolEffect(.variableColor.iterative, isActive: true)
            """)
            .font(.system(.caption, design: .monospaced))
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal)
        }
    }
}

// MARK: - Comparison View

@available(iOS 26.0, *)
public struct SFSymbolsComparisonView: View {
    @State private var animate = false
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("SF Symbols: iOS 17 vs iOS 26")
                    .font(.title.bold())
                
                // Comparison Grid
                HStack(alignment: .top, spacing: 20) {
                    // iOS 17
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "17.circle.fill")
                                .foregroundStyle(.orange)
                            Text("iOS 17")
                                .font(.headline)
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("• Bounce effect")
                            Text("• Pulse effect")
                            Text("• Variable color")
                            Text("• Scale effect")
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.orange.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    // iOS 26
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "26.circle.fill")
                                .foregroundStyle(.green)
                            Text("iOS 26")
                                .font(.headline)
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("✓ All iOS 17 effects")
                            Text("✓ NEW: Draw-on effect")
                            Text("✓ NEW: Wiggle effect")
                            Text("✓ Combined effects")
                        }
                        .font(.caption)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.green.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                // Draw-On Highlight
                VStack(alignment: .leading, spacing: 12) {
                    Text("Draw-On Effect (NEW)")
                        .font(.headline)
                    
                    Text("Symbols animate as if being drawn by hand - perfect for checkmarks, completion states, and form validation.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 40) {
                        Button {
                            animate.toggle()
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 50))
                                .symbolEffect(.bounce, value: animate)
                                .foregroundStyle(.green)
                        }
                        
                        Button {
                            animate.toggle()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 50))
                                .symbolEffect(.bounce, value: animate)
                                .foregroundStyle(.red)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding()
        }
    }
}

#Preview {
    if #available(iOS 26.0, *) {
        SFSymbolsDrawShowcase()
    }
}
