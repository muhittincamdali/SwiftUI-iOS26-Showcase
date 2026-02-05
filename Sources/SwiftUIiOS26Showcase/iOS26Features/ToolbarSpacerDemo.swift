// MARK: - ToolbarSpacerDemo.swift
// iOS 26 Toolbar Spacer & Grouping APIs
// Created by Muhittin Camdali

import SwiftUI

// MARK: - Toolbar Spacer Showcase

@available(iOS 26.0, macOS 26.0, *)
public struct ToolbarSpacerShowcase: View {
    @State private var selectedExample = 0
    @State private var notificationCount = 3
    @State private var isFavorite = false
    
    public init() {}
    
    public var body: some View {
        TabView(selection: $selectedExample) {
            // Example 1: Basic Grouping
            BasicGroupingExample()
                .tag(0)
                .tabItem {
                    Label("Grouping", systemImage: "rectangle.3.group")
                }
            
            // Example 2: Fixed Spacing
            FixedSpacingExample(isFavorite: $isFavorite)
                .tag(1)
                .tabItem {
                    Label("Fixed", systemImage: "ruler")
                }
            
            // Example 3: Flexible Spacing
            FlexibleSpacingExample()
                .tag(2)
                .tabItem {
                    Label("Flexible", systemImage: "arrow.left.and.right")
                }
            
            // Example 4: Badges
            ToolbarBadgesExample(notificationCount: $notificationCount)
                .tag(3)
                .tabItem {
                    Label("Badges", systemImage: "bell.badge")
                }
        }
    }
}

// MARK: - Basic Grouping Example

@available(iOS 26.0, *)
struct BasicGroupingExample: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    InfoCard(
                        title: "Automatic Grouping",
                        description: "iOS 26 automatically groups toolbar items on Liquid Glass surfaces. Related items appear in the same glass container.",
                        icon: "rectangle.3.group.fill"
                    )
                    
                    codeExample
                }
                .padding()
            }
            .navigationTitle("Basic Grouping")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                    } label: {
                        Image(systemName: "heart")
                    }
                    
                    Button {
                    } label: {
                        Image(systemName: "bookmark")
                    }
                    
                    // Spacer creates visual separation
                    ToolbarSpacer(.fixed)
                    
                    Button {
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
    }
    
    private var codeExample: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Code Example")
                .font(.headline)
            
            Text("""
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Heart") { }
                    Button("Bookmark") { }
                    
                    ToolbarSpacer(.fixed)
                    
                    Button("Share") { }
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

// MARK: - Fixed Spacing Example

@available(iOS 26.0, *)
struct FixedSpacingExample: View {
    @Binding var isFavorite: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    InfoCard(
                        title: "Fixed Spacing",
                        description: "Use ToolbarSpacer(.fixed) to create consistent spacing between toolbar groups.",
                        icon: "ruler.fill"
                    )
                    
                    // Visual representation
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Visual Layout")
                            .font(.headline)
                        
                        HStack(spacing: 0) {
                            // Back button
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue.opacity(0.3))
                                .frame(width: 40, height: 32)
                                .overlay {
                                    Image(systemName: "chevron.left")
                                        .font(.caption)
                                }
                            
                            Spacer()
                            
                            // Group 1
                            HStack(spacing: 4) {
                                ForEach(0..<2) { _ in
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.green.opacity(0.3))
                                        .frame(width: 32, height: 32)
                                }
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Capsule())
                            
                            // Fixed space
                            Rectangle()
                                .fill(Color.orange.opacity(0.5))
                                .frame(width: 8, height: 2)
                                .padding(.horizontal, 4)
                            
                            // Group 2
                            HStack(spacing: 4) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.purple.opacity(0.3))
                                    .frame(width: 32, height: 32)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Capsule())
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        HStack {
                            Circle().fill(.green).frame(width: 10, height: 10)
                            Text("Group 1")
                            Circle().fill(.orange).frame(width: 10, height: 10)
                            Text("Fixed Space")
                            Circle().fill(.purple).frame(width: 10, height: 10)
                            Text("Group 2")
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                }
                .padding()
            }
            .navigationTitle("Fixed Spacing")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        isFavorite.toggle()
                    } label: {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundStyle(isFavorite ? .red : .primary)
                    }
                    
                    Button {
                    } label: {
                        Image(systemName: "plus")
                    }
                    
                    ToolbarSpacer(.fixed)
                    
                    Button {
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
    }
}

// MARK: - Flexible Spacing Example

@available(iOS 26.0, *)
struct FlexibleSpacingExample: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    InfoCard(
                        title: "Flexible Spacing",
                        description: "ToolbarSpacer(.flexible) expands to fill available space, pushing items to opposite ends.",
                        icon: "arrow.left.and.right"
                    )
                    
                    Text("This is similar to Spacer() in HStack but for toolbars.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    // Code example
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Mail App Style")
                            .font(.headline)
                        
                        Text("""
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                FilterButton()
                            }
                            
                            ToolbarSpacer(.flexible)
                            
                            ToolbarItemGroup(placement: .topBarTrailing) {
                                SearchButton()
                                ComposeButton()
                            }
                        }
                        """)
                        .font(.system(.caption, design: .monospaced))
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding()
            }
            .navigationTitle("Flexible Spacing")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                    
                    Button {
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
        }
    }
}

// MARK: - Toolbar Badges Example

@available(iOS 26.0, *)
struct ToolbarBadgesExample: View {
    @Binding var notificationCount: Int
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    InfoCard(
                        title: "Toolbar Badges",
                        description: "iOS 26 adds native badge support for toolbar items. Use .badge() modifier to show indicators.",
                        icon: "bell.badge.fill"
                    )
                    
                    // Badge counter demo
                    VStack(spacing: 16) {
                        Text("Notification Count: \(notificationCount)")
                            .font(.headline)
                        
                        HStack(spacing: 20) {
                            Button("-") {
                                if notificationCount > 0 {
                                    notificationCount -= 1
                                }
                            }
                            .buttonStyle(.bordered)
                            
                            Button("+") {
                                notificationCount += 1
                            }
                            .buttonStyle(.bordered)
                            
                            Button("Clear") {
                                notificationCount = 0
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    // Code example
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Code Example")
                            .font(.headline)
                        
                        Text("""
                        .toolbar {
                            ToolbarItem {
                                Button { } label: {
                                    Image(systemName: "bell")
                                }
                                .badge(notificationCount)
                            }
                        }
                        """)
                        .font(.system(.caption, design: .monospaced))
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding()
            }
            .navigationTitle("Badges")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                    } label: {
                        Image(systemName: "bell")
                    }
                    .badge(notificationCount)
                    
                    Button {
                    } label: {
                        Image(systemName: "person.circle")
                    }
                }
            }
        }
    }
}

// MARK: - Toolbar Spacer

@available(iOS 26.0, *)
public struct ToolbarSpacer: View {
    public enum SpacerType {
        case fixed
        case flexible
    }
    
    let type: SpacerType
    
    public init(_ type: SpacerType = .fixed) {
        self.type = type
    }
    
    public var body: some View {
        switch type {
        case .fixed:
            Spacer().frame(width: 8)
        case .flexible:
            Spacer()
        }
    }
}

// MARK: - Shared Background Visibility

@available(iOS 26.0, *)
extension View {
    /// iOS 26: Separates toolbar item into its own group without background
    public func sharedBackgroundVisibility(_ visibility: SharedBackgroundVisibility) -> some View {
        self
    }
}

@available(iOS 26.0, *)
public enum SharedBackgroundVisibility {
    case automatic
    case hidden
    case visible
}

// MARK: - Info Card

@available(iOS 26.0, *)
struct InfoCard: View {
    let title: String
    let description: String
    let icon: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 44, height: 44)
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Complete Code Reference

@available(iOS 26.0, *)
public struct ToolbarSpacerCodeReference: View {
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Toolbar APIs Reference")
                    .font(.title.bold())
                
                CodeBlock(
                    title: "ToolbarSpacer",
                    code: """
                    // Fixed spacing
                    ToolbarSpacer(.fixed)
                    
                    // Flexible spacing
                    ToolbarSpacer(.flexible)
                    """
                )
                
                CodeBlock(
                    title: "Toolbar Badge",
                    code: """
                    Button { } label: {
                        Image(systemName: "bell")
                    }
                    .badge(5)
                    """
                )
                
                CodeBlock(
                    title: "Shared Background",
                    code: """
                    // Hide glass background for specific item
                    ToolbarItem {
                        ProfileImage()
                            .sharedBackgroundVisibility(.hidden)
                    }
                    """
                )
                
                CodeBlock(
                    title: "Complete Example",
                    code: """
                    .toolbar {
                        ToolbarItemGroup(placement: .topBarTrailing) {
                            // Related actions - same group
                            Button("Favorite") { }
                            Button("Add") { }
                            
                            // Spacer separates into new group
                            ToolbarSpacer(.fixed)
                            
                            // Separate action
                            Button("Share") { }
                                .badge(newItems)
                        }
                    }
                    """
                )
            }
            .padding()
        }
    }
}

#Preview {
    if #available(iOS 26.0, *) {
        ToolbarSpacerShowcase()
    }
}
