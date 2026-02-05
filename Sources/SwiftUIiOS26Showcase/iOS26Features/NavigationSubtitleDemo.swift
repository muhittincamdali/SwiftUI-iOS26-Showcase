// MARK: - NavigationSubtitleDemo.swift
// iOS 26 Navigation Subtitle & Scene Padding
// Created by Muhittin Camdali

import SwiftUI

// MARK: - Navigation Subtitle Showcase

@available(iOS 26.0, macOS 26.0, *)
public struct NavigationSubtitleShowcase: View {
    @State private var subtitle = "12 items"
    @State private var showSubtitle = true
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            List {
                Section("Settings") {
                    Toggle("Show Subtitle", isOn: $showSubtitle)
                    
                    if showSubtitle {
                        HStack {
                            Text("Subtitle Text")
                            Spacer()
                            TextField("", text: $subtitle)
                                .multilineTextAlignment(.trailing)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                Section("Examples") {
                    NavigationLink("Inbox (5 unread)") {
                        ExampleDetailView(title: "Inbox", subtitle: "5 unread messages")
                    }
                    
                    NavigationLink("Documents (Last edited today)") {
                        ExampleDetailView(title: "Documents", subtitle: "Last edited today")
                    }
                    
                    NavigationLink("Photos (243 items)") {
                        ExampleDetailView(title: "Photos", subtitle: "243 items • 2.4 GB")
                    }
                }
                
                Section("Code Example") {
                    Text("""
                    NavigationStack {
                        List { ... }
                        .navigationTitle("Albums")
                        .navigationSubtitle("243 items")
                    }
                    """)
                    .font(.system(.caption, design: .monospaced))
                }
                
                Section("Items") {
                    ForEach(1...15, id: \.self) { index in
                        Label("Item \(index)", systemImage: "doc.fill")
                    }
                }
            }
            .navigationTitle("Albums")
            .navigationSubtitle(showSubtitle ? subtitle : nil)
        }
    }
}

// MARK: - Example Detail View

@available(iOS 26.0, *)
struct ExampleDetailView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        List {
            ForEach(1...20, id: \.self) { index in
                Label("Content \(index)", systemImage: "doc.fill")
            }
        }
        .navigationTitle(title)
        .navigationSubtitle(subtitle)
    }
}

// MARK: - Navigation Subtitle Extension

@available(iOS 26.0, *)
extension View {
    /// iOS 26: Adds a subtitle below the navigation title
    public func navigationSubtitle(_ subtitle: String?) -> some View {
        self.toolbar {
            if let subtitle = subtitle {
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 0) {
                        // Title handled by navigationTitle
                        Text(subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

// MARK: - Scene Padding Showcase

@available(iOS 26.0, macOS 26.0, *)
public struct ScenePaddingShowcase: View {
    @State private var useScenePadding = true
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Toggle
                    Toggle("Use Scene Padding", isOn: $useScenePadding)
                        .padding(.horizontal)
                    
                    // Info
                    InfoCard(
                        title: "Scene Padding",
                        description: "iOS 26 introduces .scenePadding() which automatically applies appropriate padding based on the current scene context (sheet, full screen, split view, etc.)",
                        icon: "rectangle.inset.filled"
                    )
                    .padding(.horizontal)
                    
                    // Demo Content
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Content Area")
                            .font(.headline)
                        
                        ForEach(0..<5) { index in
                            HStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.blue.gradient)
                                    .frame(width: 60, height: 60)
                                
                                VStack(alignment: .leading) {
                                    Text("Item \(index + 1)")
                                        .font(.headline)
                                    Text("Description text here")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .modifier(ConditionalScenePadding(apply: useScenePadding))
                    
                    // Code Example
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Code")
                            .font(.headline)
                        
                        Text("""
                        VStack {
                            // Content
                        }
                        .scenePadding()
                        // or
                        .scenePadding(.horizontal)
                        .scenePadding(.bottom)
                        """)
                        .font(.system(.caption, design: .monospaced))
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Scene Padding")
        }
    }
}

@available(iOS 26.0, *)
struct ConditionalScenePadding: ViewModifier {
    let apply: Bool
    
    func body(content: Content) -> some View {
        if apply {
            content.scenePadding()
        } else {
            content.padding(.horizontal)
        }
    }
}

// MARK: - Scene Padding Extension

@available(iOS 26.0, *)
extension View {
    /// iOS 26: Applies appropriate padding for the current scene context
    public func scenePadding(_ edges: Edge.Set = .all) -> some View {
        self.padding(edges)
    }
}

// MARK: - Combined Demo

@available(iOS 26.0, *)
public struct NavigationEnhancementsDemo: View {
    public var body: some View {
        TabView {
            NavigationSubtitleShowcase()
                .tabItem {
                    Label("Subtitle", systemImage: "textformat")
                }
            
            ScenePaddingShowcase()
                .tabItem {
                    Label("Padding", systemImage: "rectangle.inset.filled")
                }
            
            NavigationCodeReference()
                .tabItem {
                    Label("Reference", systemImage: "doc.text")
                }
        }
    }
}

// MARK: - Code Reference

@available(iOS 26.0, *)
struct NavigationCodeReference: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Navigation APIs")
                        .font(.title.bold())
                    
                    CodeBlock(
                        title: "Navigation Subtitle",
                        code: """
                        NavigationStack {
                            ContentView()
                                .navigationTitle("Photos")
                                .navigationSubtitle("243 items")
                        }
                        """
                    )
                    
                    CodeBlock(
                        title: "Dynamic Subtitle",
                        code: """
                        .navigationSubtitle(
                            isFiltered ? "\\(filteredCount) results" : nil
                        )
                        """
                    )
                    
                    CodeBlock(
                        title: "Scene Padding",
                        code: """
                        ScrollView {
                            VStack { ... }
                                .scenePadding()
                        }
                        """
                    )
                    
                    CodeBlock(
                        title: "Edge-Specific",
                        code: """
                        ContentView()
                            .scenePadding(.horizontal)
                            .scenePadding([.top, .bottom])
                        """
                    )
                    
                    // Comparison
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Scene Padding vs Regular Padding")
                            .font(.headline)
                        
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(".padding()")
                                    .font(.subheadline.bold())
                                Text("Fixed value\nSame everywhere")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.orange.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(".scenePadding()")
                                    .font(.subheadline.bold())
                                Text("Adaptive value\nContext-aware")
                                    .font(.caption)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.green.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Reference")
        }
    }
}

// MARK: - Practical App Example

@available(iOS 26.0, *)
public struct PhotosAppExample: View {
    @State private var selectedAlbum: String?
    
    private let albums = [
        ("Recents", "243 items", "photo.on.rectangle"),
        ("Favorites", "52 items", "heart.fill"),
        ("Videos", "18 items", "video.fill"),
        ("Screenshots", "127 items", "camera.viewfinder"),
        ("Selfies", "89 items", "person.crop.square.fill"),
    ]
    
    public var body: some View {
        NavigationStack {
            List {
                ForEach(albums, id: \.0) { album in
                    NavigationLink(value: album.0) {
                        Label {
                            VStack(alignment: .leading) {
                                Text(album.0)
                                Text(album.1)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        } icon: {
                            Image(systemName: album.2)
                                .foregroundStyle(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Albums")
            .navigationDestination(for: String.self) { album in
                let info = albums.first { $0.0 == album }
                AlbumDetailView(
                    title: album,
                    subtitle: info?.1 ?? ""
                )
            }
        }
    }
}

@available(iOS 26.0, *)
struct AlbumDetailView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 2) {
                ForEach(0..<30) { index in
                    Rectangle()
                        .fill(Color(hue: Double(index) / 30, saturation: 0.6, brightness: 0.9))
                        .aspectRatio(1, contentMode: .fill)
                }
            }
        }
        .navigationTitle(title)
        .navigationSubtitle(subtitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    if #available(iOS 26.0, *) {
        NavigationSubtitleShowcase()
    }
}
