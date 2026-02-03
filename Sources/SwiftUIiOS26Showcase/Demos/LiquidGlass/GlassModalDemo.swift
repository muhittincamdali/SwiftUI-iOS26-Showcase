// GlassModalDemo.swift
// SwiftUI-iOS26-Showcase
//
// Demonstrates Liquid Glass modal presentations and sheet styles
// Created for iOS 26+ with the new glass morphism APIs

import SwiftUI

// MARK: - Glass Modal Configuration

/// Configuration options for glass modal presentations
public struct GlassModalConfiguration {
    /// The blur intensity of the glass effect
    public var blurIntensity: CGFloat
    
    /// The tint color applied to the glass
    public var tintColor: Color
    
    /// The corner radius of the modal
    public var cornerRadius: CGFloat
    
    /// Whether to show a drag indicator
    public var showsDragIndicator: Bool
    
    /// The background dimming opacity
    public var dimmingOpacity: CGFloat
    
    /// Animation configuration
    public var animation: Animation
    
    /// Default configuration
    public static let `default` = GlassModalConfiguration(
        blurIntensity: 20,
        tintColor: .white.opacity(0.1),
        cornerRadius: 32,
        showsDragIndicator: true,
        dimmingOpacity: 0.4,
        animation: .spring(response: 0.5, dampingFraction: 0.8)
    )
    
    /// Frosted glass style
    public static let frosted = GlassModalConfiguration(
        blurIntensity: 30,
        tintColor: .white.opacity(0.15),
        cornerRadius: 40,
        showsDragIndicator: true,
        dimmingOpacity: 0.5,
        animation: .spring(response: 0.6, dampingFraction: 0.75)
    )
    
    /// Clear glass style
    public static let clear = GlassModalConfiguration(
        blurIntensity: 10,
        tintColor: .clear,
        cornerRadius: 24,
        showsDragIndicator: false,
        dimmingOpacity: 0.3,
        animation: .easeInOut(duration: 0.3)
    )
}

// MARK: - Glass Modal View Modifier

/// A view modifier that applies glass modal styling
struct GlassModalModifier<ModalContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let configuration: GlassModalConfiguration
    let modalContent: () -> ModalContent
    
    @State private var offset: CGFloat = 0
    @State private var lastDragValue: CGFloat = 0
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                // Dimming background
                Color.black
                    .opacity(configuration.dimmingOpacity)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(configuration.animation) {
                            isPresented = false
                        }
                    }
                    .transition(.opacity)
                
                // Glass modal
                VStack(spacing: 0) {
                    Spacer()
                    
                    VStack(spacing: 0) {
                        if configuration.showsDragIndicator {
                            DragIndicator()
                                .padding(.top, 8)
                        }
                        
                        modalContent()
                    }
                    .frame(maxWidth: .infinity)
                    .background(
                        GlassBackground(
                            blurIntensity: configuration.blurIntensity,
                            tintColor: configuration.tintColor,
                            cornerRadius: configuration.cornerRadius
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius))
                    .offset(y: offset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if value.translation.height > 0 {
                                    offset = value.translation.height
                                }
                            }
                            .onEnded { value in
                                if value.translation.height > 100 {
                                    withAnimation(configuration.animation) {
                                        isPresented = false
                                    }
                                } else {
                                    withAnimation(configuration.animation) {
                                        offset = 0
                                    }
                                }
                            }
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .animation(configuration.animation, value: isPresented)
    }
}

// MARK: - Supporting Views

/// A drag indicator view for sheet modals
struct DragIndicator: View {
    var body: some View {
        Capsule()
            .fill(Color.white.opacity(0.4))
            .frame(width: 36, height: 5)
            .padding(.vertical, 8)
    }
}

/// Glass background effect view
struct GlassBackground: View {
    let blurIntensity: CGFloat
    let tintColor: Color
    let cornerRadius: CGFloat
    
    var body: some View {
        ZStack {
            // Blur layer
            Rectangle()
                .fill(.ultraThinMaterial)
            
            // Tint overlay
            tintColor
            
            // Border highlight
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.5),
                            .white.opacity(0.1),
                            .clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
    }
}

// MARK: - View Extension

public extension View {
    /// Presents a glass-styled modal sheet
    /// - Parameters:
    ///   - isPresented: Binding to control presentation
    ///   - configuration: Glass modal configuration
    ///   - content: The content to display in the modal
    func glassModal<Content: View>(
        isPresented: Binding<Bool>,
        configuration: GlassModalConfiguration = .default,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(
            GlassModalModifier(
                isPresented: isPresented,
                configuration: configuration,
                modalContent: content
            )
        )
    }
}

// MARK: - Demo View

/// Comprehensive demo showcasing glass modal presentations
public struct GlassModalDemo: View {
    @State private var showDefaultModal = false
    @State private var showFrostedModal = false
    @State private var showClearModal = false
    @State private var showCustomModal = false
    @State private var showActionSheet = false
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                
                modalButtonsSection
                
                codeExampleSection
            }
            .padding()
        }
        .background(backgroundGradient)
        .glassModal(isPresented: $showDefaultModal, configuration: .default) {
            defaultModalContent
        }
        .glassModal(isPresented: $showFrostedModal, configuration: .frosted) {
            frostedModalContent
        }
        .glassModal(isPresented: $showClearModal, configuration: .clear) {
            clearModalContent
        }
        .glassModal(isPresented: $showCustomModal, configuration: customConfiguration) {
            customModalContent
        }
        .glassModal(isPresented: $showActionSheet, configuration: .default) {
            actionSheetContent
        }
        .navigationTitle("Glass Modals")
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Glass Modal Presentations")
                .font(.title.bold())
                .foregroundStyle(.white)
            
            Text("iOS 26 introduces fluid glass-styled modal presentations that blend seamlessly with the Liquid Glass design language.")
                .font(.body)
                .foregroundStyle(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Modal Buttons Section
    
    private var modalButtonsSection: some View {
        VStack(spacing: 16) {
            ModalButton(
                title: "Default Glass Modal",
                subtitle: "Standard glass effect with drag indicator",
                color: .blue
            ) {
                showDefaultModal = true
            }
            
            ModalButton(
                title: "Frosted Glass Modal",
                subtitle: "Heavy blur with frosted appearance",
                color: .purple
            ) {
                showFrostedModal = true
            }
            
            ModalButton(
                title: "Clear Glass Modal",
                subtitle: "Minimal blur, subtle effect",
                color: .green
            ) {
                showClearModal = true
            }
            
            ModalButton(
                title: "Custom Configuration",
                subtitle: "Fully customized glass parameters",
                color: .orange
            ) {
                showCustomModal = true
            }
            
            ModalButton(
                title: "Glass Action Sheet",
                subtitle: "Action sheet with glass styling",
                color: .pink
            ) {
                showActionSheet = true
            }
        }
    }
    
    // MARK: - Modal Contents
    
    private var defaultModalContent: some View {
        VStack(spacing: 20) {
            Image(systemName: "sparkles")
                .font(.system(size: 48))
                .foregroundStyle(.blue)
            
            Text("Default Glass Modal")
                .font(.title2.bold())
                .foregroundStyle(.white)
            
            Text("This modal uses the default glass configuration with a balanced blur intensity and standard corner radius.")
                .font(.body)
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Button("Dismiss") {
                showDefaultModal = false
            }
            .buttonStyle(GlassButtonStyle())
        }
        .padding(24)
    }
    
    private var frostedModalContent: some View {
        VStack(spacing: 20) {
            Image(systemName: "snowflake")
                .font(.system(size: 48))
                .foregroundStyle(.purple)
            
            Text("Frosted Glass Modal")
                .font(.title2.bold())
                .foregroundStyle(.white)
            
            Text("Heavy blur creates a frosted glass appearance, perfect for content that needs visual separation from the background.")
                .font(.body)
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Button("Dismiss") {
                showFrostedModal = false
            }
            .buttonStyle(GlassButtonStyle())
        }
        .padding(24)
    }
    
    private var clearModalContent: some View {
        VStack(spacing: 20) {
            Image(systemName: "drop")
                .font(.system(size: 48))
                .foregroundStyle(.green)
            
            Text("Clear Glass Modal")
                .font(.title2.bold())
                .foregroundStyle(.white)
            
            Text("Minimal blur allows more background visibility while maintaining the glass aesthetic.")
                .font(.body)
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Button("Dismiss") {
                showClearModal = false
            }
            .buttonStyle(GlassButtonStyle())
        }
        .padding(24)
    }
    
    private var customModalContent: some View {
        VStack(spacing: 20) {
            Image(systemName: "slider.horizontal.3")
                .font(.system(size: 48))
                .foregroundStyle(.orange)
            
            Text("Custom Configuration")
                .font(.title2.bold())
                .foregroundStyle(.white)
            
            Text("Every aspect of the glass modal can be customized: blur, tint, corner radius, animation, and more.")
                .font(.body)
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            configurationDetails
            
            Button("Dismiss") {
                showCustomModal = false
            }
            .buttonStyle(GlassButtonStyle())
        }
        .padding(24)
    }
    
    private var configurationDetails: some View {
        VStack(spacing: 8) {
            ConfigurationRow(label: "Blur", value: "25")
            ConfigurationRow(label: "Corner Radius", value: "48")
            ConfigurationRow(label: "Tint", value: "Orange 15%")
            ConfigurationRow(label: "Animation", value: "Spring")
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var actionSheetContent: some View {
        VStack(spacing: 12) {
            Text("Actions")
                .font(.headline)
                .foregroundStyle(.white)
                .padding(.top, 8)
            
            Divider()
                .background(Color.white.opacity(0.2))
            
            ActionSheetButton(title: "Share", icon: "square.and.arrow.up", color: .blue) {
                showActionSheet = false
            }
            
            ActionSheetButton(title: "Copy Link", icon: "link", color: .green) {
                showActionSheet = false
            }
            
            ActionSheetButton(title: "Add to Favorites", icon: "star", color: .yellow) {
                showActionSheet = false
            }
            
            ActionSheetButton(title: "Delete", icon: "trash", color: .red) {
                showActionSheet = false
            }
            
            Divider()
                .background(Color.white.opacity(0.2))
            
            Button("Cancel") {
                showActionSheet = false
            }
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding()
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
    
    // MARK: - Code Example Section
    
    private var codeExampleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Implementation")
                .font(.headline)
                .foregroundStyle(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                Text(codeExample)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(.green)
                    .padding()
            }
            .background(Color.black.opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    // MARK: - Helpers
    
    private var customConfiguration: GlassModalConfiguration {
        GlassModalConfiguration(
            blurIntensity: 25,
            tintColor: .orange.opacity(0.15),
            cornerRadius: 48,
            showsDragIndicator: true,
            dimmingOpacity: 0.5,
            animation: .spring(response: 0.4, dampingFraction: 0.9)
        )
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 0.1, green: 0.1, blue: 0.2),
                Color(red: 0.2, green: 0.1, blue: 0.3)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var codeExample: String {
        """
        // Using glass modal modifier
        .glassModal(
            isPresented: $showModal,
            configuration: .frosted
        ) {
            VStack {
                Text("Modal Content")
                Button("Dismiss") {
                    showModal = false
                }
            }
        }
        
        // Custom configuration
        let config = GlassModalConfiguration(
            blurIntensity: 25,
            tintColor: .blue.opacity(0.1),
            cornerRadius: 40,
            showsDragIndicator: true,
            dimmingOpacity: 0.4,
            animation: .spring()
        )
        """
    }
}

// MARK: - Supporting Button Views

struct ModalButton: View {
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.white.opacity(0.5))
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(color.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(color.opacity(0.5), lineWidth: 1)
                    )
            )
        }
    }
}

struct GlassButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Capsule()
                            .strokeBorder(Color.white.opacity(0.3), lineWidth: 1)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct ConfigurationRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.white.opacity(0.7))
            Spacer()
            Text(value)
                .foregroundStyle(.white)
                .fontWeight(.medium)
        }
        .font(.caption)
    }
}

struct ActionSheetButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .frame(width: 24)
                
                Text(title)
                    .foregroundStyle(.white)
                
                Spacer()
            }
            .padding()
            .contentShape(Rectangle())
        }
    }
}

// MARK: - Preview

#Preview("Glass Modal Demo") {
    NavigationStack {
        GlassModalDemo()
    }
}
