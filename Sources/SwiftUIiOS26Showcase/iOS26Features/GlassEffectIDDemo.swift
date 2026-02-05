// MARK: - GlassEffectIDDemo.swift
// iOS 26 Glass Effect ID & Morphing Transitions
// Created by Muhittin Camdali

import SwiftUI

// MARK: - Glass Effect ID Showcase

@available(iOS 26.0, macOS 26.0, *)
public struct GlassEffectIDShowcase: View {
    @Namespace private var glassNamespace
    @State private var isExpanded = false
    @State private var selectedBadge: Badge?
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient(
                    colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 32) {
                    Text("Glass Effect ID")
                        .font(.largeTitle.bold())
                    
                    Text("Tap to see morphing transition")
                        .foregroundStyle(.secondary)
                    
                    // Glass container with morphing badges
                    GlassEffectContainer {
                        if isExpanded {
                            expandedBadges
                        } else {
                            collapsedBadge
                        }
                    }
                    .frame(height: isExpanded ? 300 : 80)
                    .animation(.spring(duration: 0.5), value: isExpanded)
                    
                    // Toggle button
                    Button(isExpanded ? "Collapse" : "Expand") {
                        withAnimation(.spring(duration: 0.5)) {
                            isExpanded.toggle()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    
                    // Code example
                    codeExample
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var collapsedBadge: some View {
        HStack(spacing: 8) {
            ForEach(Badge.samples.prefix(3)) { badge in
                BadgeView(badge: badge, size: 48)
                    .glassEffectID(badge.id, in: glassNamespace)
            }
            
            Text("+\(Badge.samples.count - 3)")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
        }
        .padding()
    }
    
    private var expandedBadges: some View {
        VStack(spacing: 16) {
            Text("Your Badges")
                .font(.headline)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(Badge.samples) { badge in
                    BadgeView(badge: badge, size: 64, showTitle: true)
                        .glassEffectID(badge.id, in: glassNamespace)
                        .onTapGesture {
                            selectedBadge = badge
                        }
                }
            }
        }
        .padding()
    }
    
    private var codeExample: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Code")
                .font(.headline)
            
            Text("""
            @Namespace private var ns
            
            GlassEffectContainer {
                ForEach(badges) { badge in
                    BadgeView(badge: badge)
                        .glassEffectID(badge.id, in: ns)
                }
            }
            """)
            .font(.system(.caption, design: .monospaced))
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

// MARK: - Badge Model

struct Badge: Identifiable {
    let id: String
    let name: String
    let icon: String
    let color: Color
    
    static let samples: [Badge] = [
        Badge(id: "explorer", name: "Explorer", icon: "map.fill", color: .blue),
        Badge(id: "collector", name: "Collector", icon: "star.fill", color: .yellow),
        Badge(id: "achiever", name: "Achiever", icon: "trophy.fill", color: .orange),
        Badge(id: "pioneer", name: "Pioneer", icon: "flag.fill", color: .green),
        Badge(id: "master", name: "Master", icon: "crown.fill", color: .purple),
        Badge(id: "legend", name: "Legend", icon: "bolt.fill", color: .red),
    ]
}

// MARK: - Badge View

@available(iOS 26.0, *)
struct BadgeView: View {
    let badge: Badge
    var size: CGFloat = 48
    var showTitle: Bool = false
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(badge.color.gradient)
                    .frame(width: size, height: size)
                
                Image(systemName: badge.icon)
                    .font(.system(size: size * 0.4))
                    .foregroundStyle(.white)
            }
            
            if showTitle {
                Text(badge.name)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - Glass Effect Container

@available(iOS 26.0, *)
public struct GlassEffectContainer<Content: View>: View {
    let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

// MARK: - Glass Effect ID Modifier

@available(iOS 26.0, *)
extension View {
    /// iOS 26: Associates a view with a glass effect ID for morphing transitions
    public func glassEffectID<ID: Hashable>(_ id: ID, in namespace: Namespace.ID) -> some View {
        self.matchedGeometryEffect(id: id, in: namespace)
    }
}

// MARK: - Practical Example: Award Badges

@available(iOS 26.0, *)
public struct AwardBadgesDemo: View {
    @Namespace private var badgeNamespace
    @State private var showAllBadges = false
    
    private let earnedBadges = Array(Badge.samples.prefix(4))
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Card
                    profileCard
                    
                    // Badge Section
                    badgeSection
                    
                    // Content
                    contentSection
                }
                .padding()
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(.spring(duration: 0.5)) {
                            showAllBadges.toggle()
                        }
                    } label: {
                        Image(systemName: showAllBadges ? "chevron.up" : "medal.fill")
                    }
                }
            }
        }
    }
    
    private var profileCard: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color.blue.gradient)
                .frame(width: 80, height: 80)
                .overlay {
                    Text("MC")
                        .font(.title.bold())
                        .foregroundStyle(.white)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Muhittin Camdali")
                    .font(.title2.bold())
                
                Text("iOS Developer")
                    .foregroundStyle(.secondary)
                
                HStack {
                    Image(systemName: "medal.fill")
                        .foregroundStyle(.yellow)
                    Text("\(earnedBadges.count) badges earned")
                        .font(.caption)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var badgeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Badges")
                    .font(.headline)
                
                Spacer()
                
                Button(showAllBadges ? "Less" : "See All") {
                    withAnimation(.spring(duration: 0.5)) {
                        showAllBadges.toggle()
                    }
                }
                .font(.subheadline)
            }
            
            GlassEffectContainer {
                if showAllBadges {
                    // Expanded grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(earnedBadges) { badge in
                            BadgeView(badge: badge, size: 56, showTitle: true)
                                .glassEffectID(badge.id, in: badgeNamespace)
                        }
                    }
                } else {
                    // Collapsed row
                    HStack(spacing: 12) {
                        ForEach(earnedBadges) { badge in
                            BadgeView(badge: badge, size: 40)
                                .glassEffectID(badge.id, in: badgeNamespace)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
    
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Activity")
                .font(.headline)
            
            ForEach(0..<5) { index in
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 44, height: 44)
                        .overlay {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.blue)
                        }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Completed Task \(index + 1)")
                            .font(.subheadline)
                        Text("\(index + 1) hour ago")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

// MARK: - Sheet Morphing Demo

@available(iOS 26.0, *)
public struct SheetMorphingDemo: View {
    @Namespace private var sheetNamespace
    @State private var showSheet = false
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Text("Sheet Morphing")
                    .font(.largeTitle.bold())
                
                Text("iOS 26 sheets can morph from their presenting button")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                
                // Button that morphs into sheet
                Button {
                    showSheet = true
                } label: {
                    Label("Open Settings", systemImage: "gearshape.fill")
                        .font(.headline)
                        .padding()
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
                .navigationTransitionSource(id: "settings", namespace: sheetNamespace)
                
                // Code
                VStack(alignment: .leading, spacing: 8) {
                    Text("Code")
                        .font(.headline)
                    
                    Text("""
                    Button("Settings") { showSheet = true }
                        .navigationTransitionSource(
                            id: "settings", 
                            namespace: ns
                        )
                    
                    .sheet(isPresented: $showSheet) {
                        SettingsView()
                            .navigationTransitionDestination(
                                id: "settings", 
                                namespace: ns
                            )
                    }
                    """)
                    .font(.system(.caption, design: .monospaced))
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .padding()
            }
            .padding()
            .sheet(isPresented: $showSheet) {
                SettingsSheetView()
                    .navigationTransitionDestination(id: "settings", namespace: sheetNamespace)
            }
        }
    }
}

@available(iOS 26.0, *)
struct SettingsSheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("General") {
                    Label("Notifications", systemImage: "bell.fill")
                    Label("Sounds", systemImage: "speaker.wave.2.fill")
                    Label("Display", systemImage: "sun.max.fill")
                }
                
                Section("Privacy") {
                    Label("Location", systemImage: "location.fill")
                    Label("Contacts", systemImage: "person.2.fill")
                    Label("Photos", systemImage: "photo.fill")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

// MARK: - Navigation Transition Extensions

@available(iOS 26.0, *)
extension View {
    public func navigationTransitionSource<ID: Hashable>(id: ID, namespace: Namespace.ID) -> some View {
        self.matchedGeometryEffect(id: id, in: namespace, isSource: true)
    }
    
    public func navigationTransitionDestination<ID: Hashable>(id: ID, namespace: Namespace.ID) -> some View {
        self.matchedGeometryEffect(id: id, in: namespace, isSource: false)
    }
}

#Preview {
    if #available(iOS 26.0, *) {
        GlassEffectIDShowcase()
    }
}
