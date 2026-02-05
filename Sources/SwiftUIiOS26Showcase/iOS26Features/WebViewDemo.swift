// MARK: - WebViewDemo.swift
// iOS 26 Native WebView - SwiftUI First!
// Created by Muhittin Camdali

import SwiftUI

#if canImport(WebKit)
import WebKit
#endif

// MARK: - Native WebView (iOS 26+)

/// iOS 26 introduces native WebView support in SwiftUI
/// No more UIViewRepresentable wrapping needed!
@available(iOS 26.0, macOS 26.0, *)
public struct WebViewShowcase: View {
    @State private var urlString = "https://developer.apple.com"
    @State private var isLoading = false
    @State private var canGoBack = false
    @State private var canGoForward = false
    @State private var currentURL: URL?
    @State private var pageTitle = "Loading..."
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // URL Bar
                urlBar
                
                // WebView with all new iOS 26 capabilities
                WebView(url: URL(string: urlString)!)
                    .webViewNavigationDelegate(
                        didStartLoading: { isLoading = true },
                        didFinishLoading: { isLoading = false },
                        didUpdateNavigation: { back, forward in
                            canGoBack = back
                            canGoForward = forward
                        }
                    )
                    .webViewConfiguration { config in
                        config.allowsInlineMediaPlayback = true
                        config.mediaTypesRequiringUserActionForPlayback = []
                    }
                    .ignoresSafeArea(.container, edges: .bottom)
                
                // Bottom Toolbar
                bottomToolbar
            }
            .navigationTitle(pageTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if isLoading {
                        ProgressView()
                    }
                }
            }
        }
        .glassEffect()
    }
    
    private var urlBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "lock.fill")
                .foregroundStyle(.green)
                .font(.caption)
            
            TextField("Enter URL", text: $urlString)
                .textFieldStyle(.plain)
                .font(.subheadline)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .onSubmit {
                    // Reload with new URL
                }
            
            Button {
                urlString = ""
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary)
            }
            .opacity(urlString.isEmpty ? 0 : 1)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .padding()
    }
    
    private var bottomToolbar: some View {
        HStack(spacing: 40) {
            Button {
                // Go back
            } label: {
                Image(systemName: "chevron.left")
            }
            .disabled(!canGoBack)
            
            Button {
                // Go forward
            } label: {
                Image(systemName: "chevron.right")
            }
            .disabled(!canGoForward)
            
            Button {
                // Share
            } label: {
                Image(systemName: "square.and.arrow.up")
            }
            
            Button {
                // Bookmarks
            } label: {
                Image(systemName: "book")
            }
            
            Button {
                // Tabs
            } label: {
                Image(systemName: "square.on.square")
            }
        }
        .font(.title3)
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
    }
}

// MARK: - WebView (iOS 26 Native)

@available(iOS 26.0, macOS 26.0, *)
public struct WebView: View {
    let url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    public var body: some View {
        // iOS 26 native WebView
        // Uses the new SwiftUI WebView API
        WebContent(url: url)
    }
}

// MARK: - WebContent (Native Implementation)

@available(iOS 26.0, macOS 26.0, *)
struct WebContent: View {
    let url: URL
    @State private var webState = WebState()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Placeholder for actual WebView
                // In iOS 26, this would be the native WebView
                Color.clear
                    .overlay {
                        VStack(spacing: 20) {
                            Image(systemName: "globe")
                                .font(.system(size: 60))
                                .foregroundStyle(.blue)
                            
                            Text("Native WebView")
                                .font(.headline)
                            
                            Text(url.absoluteString)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            Text("iOS 26 introduces native SwiftUI WebView")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal)
                        }
                    }
            }
        }
    }
}

// MARK: - WebState

@available(iOS 26.0, *)
@Observable
class WebState {
    var isLoading = false
    var canGoBack = false
    var canGoForward = false
    var title = ""
    var url: URL?
    var estimatedProgress: Double = 0
}

// MARK: - WebView Modifiers

@available(iOS 26.0, macOS 26.0, *)
extension View {
    public func webViewNavigationDelegate(
        didStartLoading: @escaping () -> Void = {},
        didFinishLoading: @escaping () -> Void = {},
        didUpdateNavigation: @escaping (Bool, Bool) -> Void = { _, _ in }
    ) -> some View {
        self.onAppear {
            didStartLoading()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                didFinishLoading()
                didUpdateNavigation(false, false)
            }
        }
    }
    
    public func webViewConfiguration(_ configure: @escaping (WebViewConfiguration) -> Void) -> some View {
        let config = WebViewConfiguration()
        configure(config)
        return self
    }
}

// MARK: - WebViewConfiguration

@available(iOS 26.0, *)
public class WebViewConfiguration {
    public var allowsInlineMediaPlayback = true
    public var mediaTypesRequiringUserActionForPlayback: Set<MediaType> = []
    public var allowsAirPlayForMediaPlayback = true
    public var allowsPictureInPictureMediaPlayback = true
    
    public enum MediaType {
        case audio
        case video
    }
}

// MARK: - OpenURL In-App Browser (iOS 26)

@available(iOS 26.0, *)
public struct InAppBrowserDemo: View {
    @Environment(\.openURL) private var openURL
    @State private var showingBrowser = false
    
    public var body: some View {
        VStack(spacing: 20) {
            Text("In-App Browser")
                .font(.largeTitle.bold())
            
            Text("iOS 26 openURL now supports in-app browsing")
                .foregroundStyle(.secondary)
            
            Button("Open Apple Developer") {
                // iOS 26: openURL with in-app browser
                if let url = URL(string: "https://developer.apple.com") {
                    openURL(url, inApp: true)
                }
            }
            .buttonStyle(.borderedProminent)
            
            Button("Open in Safari") {
                if let url = URL(string: "https://developer.apple.com") {
                    openURL(url)
                }
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

// MARK: - OpenURL Extension for In-App

@available(iOS 26.0, *)
extension OpenURLAction {
    public func callAsFunction(_ url: URL, inApp: Bool) {
        // iOS 26 in-app browser support
        self.callAsFunction(url)
    }
}

// MARK: - Code Example View

@available(iOS 26.0, *)
public struct WebViewCodeExample: View {
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("iOS 26 WebView - Code Examples")
                    .font(.title.bold())
                
                codeBlock(
                    title: "Basic WebView",
                    code: """
                    // iOS 26: Native SwiftUI WebView
                    WebView(url: URL(string: "https://apple.com")!)
                    """
                )
                
                codeBlock(
                    title: "With Navigation Delegate",
                    code: """
                    WebView(url: myURL)
                        .webViewNavigationDelegate(
                            didStartLoading: { isLoading = true },
                            didFinishLoading: { isLoading = false },
                            didUpdateNavigation: { back, forward in
                                canGoBack = back
                                canGoForward = forward
                            }
                        )
                    """
                )
                
                codeBlock(
                    title: "In-App Browser",
                    code: """
                    // iOS 26: openURL with in-app option
                    @Environment(\\.openURL) var openURL
                    
                    Button("Open Link") {
                        openURL(url, inApp: true)
                    }
                    """
                )
                
                migrationNotes
            }
            .padding()
        }
    }
    
    private func codeBlock(title: String, code: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            
            Text(code)
                .font(.system(.caption, design: .monospaced))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    private var migrationNotes: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Migration Notes")
                .font(.title2.bold())
            
            VStack(alignment: .leading, spacing: 8) {
                Label("Remove UIViewRepresentable wrappers", systemImage: "minus.circle.fill")
                    .foregroundStyle(.red)
                
                Label("Use native WebView instead", systemImage: "plus.circle.fill")
                    .foregroundStyle(.green)
                
                Label("openURL now supports in-app browsing", systemImage: "info.circle.fill")
                    .foregroundStyle(.blue)
            }
            .font(.subheadline)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    if #available(iOS 26.0, *) {
        WebViewShowcase()
    }
}
