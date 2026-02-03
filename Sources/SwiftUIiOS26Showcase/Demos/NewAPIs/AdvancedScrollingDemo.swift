// AdvancedScrollingDemo.swift
// SwiftUI-iOS26-Showcase
//
// Demonstrates iOS 26 advanced scrolling APIs
// Includes scroll phases, position tracking, and custom behaviors

import SwiftUI

// MARK: - Scroll Position Tracker

/// Observable scroll position for advanced tracking
@Observable
final class ScrollPositionTracker {
    var offset: CGFloat = 0
    var velocity: CGFloat = 0
    var isScrolling: Bool = false
    var scrollDirection: ScrollDirection = .none
    var contentSize: CGSize = .zero
    var visibleSize: CGSize = .zero
    
    enum ScrollDirection {
        case up, down, left, right, none
    }
    
    var scrollProgress: CGFloat {
        guard contentSize.height > visibleSize.height else { return 0 }
        return offset / (contentSize.height - visibleSize.height)
    }
    
    var isAtTop: Bool { offset <= 0 }
    var isAtBottom: Bool {
        offset >= contentSize.height - visibleSize.height - 10
    }
}

// MARK: - Scroll Phase View

/// Demonstrates scroll phase detection
struct ScrollPhaseView: View {
    @State private var scrollPhase: ScrollPhaseState = .idle
    @State private var items = (1...50).map { "Item \($0)" }
    
    enum ScrollPhaseState: String {
        case idle = "Idle"
        case tracking = "Tracking"
        case decelerating = "Decelerating"
        case animating = "Animating"
        
        var color: Color {
            switch self {
            case .idle: return .gray
            case .tracking: return .blue
            case .decelerating: return .orange
            case .animating: return .green
            }
        }
        
        var icon: String {
            switch self {
            case .idle: return "pause.circle"
            case .tracking: return "hand.point.up"
            case .decelerating: return "arrow.down.circle"
            case .animating: return "sparkles"
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Phase indicator
            HStack {
                Image(systemName: scrollPhase.icon)
                    .font(.title2)
                    .foregroundStyle(scrollPhase.color)
                
                Text(scrollPhase.rawValue)
                    .font(.headline)
                    .foregroundStyle(.white)
                
                Spacer()
                
                Capsule()
                    .fill(scrollPhase.color)
                    .frame(width: 12, height: 12)
            }
            .padding()
            .background(.ultraThinMaterial)
            
            // Scrollable content
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(items, id: \.self) { item in
                        ScrollPhaseRow(text: item, phase: scrollPhase)
                    }
                }
                .padding()
            }
            .scrollIndicators(.hidden)
            .onScrollPhaseChange { oldPhase, newPhase in
                withAnimation(.easeInOut(duration: 0.2)) {
                    switch newPhase {
                    case .idle:
                        scrollPhase = .idle
                    case .tracking:
                        scrollPhase = .tracking
                    case .decelerating:
                        scrollPhase = .decelerating
                    case .animating:
                        scrollPhase = .animating
                    case .interacting:
                        scrollPhase = .tracking
                    @unknown default:
                        scrollPhase = .idle
                    }
                }
            }
        }
    }
}

struct ScrollPhaseRow: View {
    let text: String
    let phase: ScrollPhaseView.ScrollPhaseState
    
    var body: some View {
        HStack {
            Text(text)
                .font(.body)
                .foregroundStyle(.white)
            
            Spacer()
            
            Circle()
                .fill(phase.color.opacity(0.3))
                .frame(width: 8, height: 8)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(phase.color.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

// MARK: - Scroll Position View

/// Demonstrates scroll position tracking
struct ScrollPositionView: View {
    @State private var scrollPosition = ScrollPosition()
    @State private var items = (1...100).map { $0 }
    
    var body: some View {
        VStack(spacing: 0) {
            // Position info bar
            HStack {
                VStack(alignment: .leading) {
                    Text("Position")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                    
                    if let edge = scrollPosition.edge {
                        Text(edge == .top ? "Top" : "Bottom")
                            .font(.headline)
                            .foregroundStyle(.blue)
                    } else {
                        Text("Scrolling...")
                            .font(.headline)
                            .foregroundStyle(.orange)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Visible ID")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                    
                    if let id = scrollPosition.viewID(type: Int.self) {
                        Text("#\(id)")
                            .font(.headline.monospacedDigit())
                            .foregroundStyle(.green)
                    }
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            
            // Quick jump buttons
            HStack(spacing: 12) {
                Button("Top") {
                    withAnimation(.spring(response: 0.5)) {
                        scrollPosition.scrollTo(edge: .top)
                    }
                }
                .buttonStyle(QuickJumpButtonStyle())
                
                Button("ID 25") {
                    withAnimation(.spring(response: 0.5)) {
                        scrollPosition.scrollTo(id: 25)
                    }
                }
                .buttonStyle(QuickJumpButtonStyle())
                
                Button("ID 50") {
                    withAnimation(.spring(response: 0.5)) {
                        scrollPosition.scrollTo(id: 50)
                    }
                }
                .buttonStyle(QuickJumpButtonStyle())
                
                Button("ID 75") {
                    withAnimation(.spring(response: 0.5)) {
                        scrollPosition.scrollTo(id: 75)
                    }
                }
                .buttonStyle(QuickJumpButtonStyle())
                
                Button("Bottom") {
                    withAnimation(.spring(response: 0.5)) {
                        scrollPosition.scrollTo(edge: .bottom)
                    }
                }
                .buttonStyle(QuickJumpButtonStyle())
            }
            .padding()
            
            // Scrollable content
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(items, id: \.self) { item in
                        PositionRow(number: item)
                            .id(item)
                    }
                }
                .padding()
                .scrollTargetLayout()
            }
            .scrollPosition($scrollPosition)
            .scrollTargetBehavior(.viewAligned)
        }
    }
}

struct PositionRow: View {
    let number: Int
    
    var body: some View {
        HStack {
            Text("#\(number)")
                .font(.headline.monospacedDigit())
                .foregroundStyle(.white)
            
            Spacer()
            
            Text("Row Content")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.6))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hue: Double(number) / 100, saturation: 0.3, brightness: 0.3))
                )
        )
    }
}

struct QuickJumpButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.caption.bold())
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Capsule()
                            .fill(Color.blue.opacity(configuration.isPressed ? 0.4 : 0.2))
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

// MARK: - Paging Scroll View

/// Demonstrates paging scroll behavior
struct PagingScrollView: View {
    @State private var currentPage = 0
    let pageCount = 5
    
    let pageColors: [Color] = [.blue, .purple, .pink, .orange, .green]
    let pageIcons = ["star.fill", "heart.fill", "bolt.fill", "flame.fill", "leaf.fill"]
    let pageTitles = ["Welcome", "Features", "Design", "Power", "Nature"]
    
    var body: some View {
        VStack(spacing: 0) {
            // Page indicator
            HStack(spacing: 8) {
                ForEach(0..<pageCount, id: \.self) { index in
                    Capsule()
                        .fill(currentPage == index ? Color.white : Color.white.opacity(0.3))
                        .frame(width: currentPage == index ? 24 : 8, height: 8)
                        .animation(.spring(response: 0.3), value: currentPage)
                }
            }
            .padding()
            
            // Paging content
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(0..<pageCount, id: \.self) { index in
                        PageView(
                            color: pageColors[index],
                            icon: pageIcons[index],
                            title: pageTitles[index],
                            pageNumber: index + 1
                        )
                        .containerRelativeFrame(.horizontal)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: Binding(
                get: { currentPage },
                set: { if let newValue = $0 { currentPage = newValue } }
            ))
        }
    }
}

struct PageView: View {
    let color: Color
    let icon: String
    let title: String
    let pageNumber: Int
    
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: icon)
                    .font(.system(size: 48))
                    .foregroundStyle(color)
            }
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.title.bold())
                    .foregroundStyle(.white)
                
                Text("Page \(pageNumber)")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.6))
            }
            
            Text("Swipe to navigate between pages. The scroll view uses paging behavior for precise page-by-page navigation.")
                .font(.body)
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [color.opacity(0.3), color.opacity(0.1)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

// MARK: - Parallax Scroll View

/// Demonstrates parallax scrolling effects
struct ParallaxScrollView: View {
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Parallax header
                GeometryReader { geometry in
                    let minY = geometry.frame(in: .global).minY
                    let isScrollingUp = minY > 0
                    
                    ZStack {
                        // Background layer (slower)
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.purple, .blue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 200, height: 200)
                            .offset(y: isScrollingUp ? minY * 0.3 : 0)
                            .blur(radius: 30)
                        
                        // Middle layer
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 150, height: 150)
                            .offset(y: isScrollingUp ? minY * 0.5 : 0)
                        
                        // Foreground layer (faster)
                        VStack {
                            Image(systemName: "sparkles")
                                .font(.system(size: 40))
                                .foregroundStyle(.white)
                            
                            Text("Parallax")
                                .font(.title.bold())
                                .foregroundStyle(.white)
                        }
                        .offset(y: isScrollingUp ? minY * 0.7 : 0)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: isScrollingUp ? 300 + minY : 300)
                    .offset(y: isScrollingUp ? -minY : 0)
                }
                .frame(height: 300)
                
                // Content
                VStack(spacing: 16) {
                    ForEach(0..<20, id: \.self) { index in
                        ParallaxRow(index: index)
                    }
                }
                .padding()
            }
        }
        .scrollIndicators(.hidden)
    }
}

struct ParallaxRow: View {
    let index: Int
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color(hue: Double(index) / 20, saturation: 0.5, brightness: 0.6))
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Parallax Item \(index + 1)")
                    .font(.headline)
                    .foregroundStyle(.white)
                
                Text("Scroll to see the parallax effect in the header")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.6))
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

// MARK: - Main Demo View

/// Comprehensive advanced scrolling demonstration
public struct AdvancedScrollingDemo: View {
    @State private var selectedTab = 0
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            // Tab selector
            HStack(spacing: 0) {
                TabButton(title: "Phase", index: 0, selected: $selectedTab)
                TabButton(title: "Position", index: 1, selected: $selectedTab)
                TabButton(title: "Paging", index: 2, selected: $selectedTab)
                TabButton(title: "Parallax", index: 3, selected: $selectedTab)
            }
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
            )
            .padding()
            
            // Content
            TabView(selection: $selectedTab) {
                ScrollPhaseView()
                    .tag(0)
                
                ScrollPositionView()
                    .tag(1)
                
                PagingScrollView()
                    .tag(2)
                
                ParallaxScrollView()
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .background(backgroundGradient)
        .navigationTitle("Advanced Scrolling")
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 0.1, green: 0.1, blue: 0.15),
                Color(red: 0.15, green: 0.1, blue: 0.2)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

struct TabButton: View {
    let title: String
    let index: Int
    @Binding var selected: Int
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3)) {
                selected = index
            }
        } label: {
            Text(title)
                .font(.subheadline.bold())
                .foregroundStyle(selected == index ? .white : .white.opacity(0.5))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(selected == index ? Color.blue.opacity(0.4) : Color.clear)
                )
        }
    }
}

// MARK: - Preview

#Preview("Advanced Scrolling Demo") {
    NavigationStack {
        AdvancedScrollingDemo()
    }
}
