import SwiftUI
import WebKit

struct WebViewDemo: View {
    private static let startAddress = "https://www.swift.org"

    @State private var page = WebPage()
    @State private var address = startAddress
    @State private var isAddressInvalid = false

    var body: some View {
        VStack(spacing: 0) {
            addressBar
            WebView(page)
            statusBar
        }
        .navigationSubtitle(page.title.isEmpty ? "Loading" : page.title)
        .onAppear {
            if page.url == nil { load() }
        }
    }

    private var addressBar: some View {
        HStack {
            TextField("Address", text: $address)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .onSubmit(load)
            #if os(iOS)
                .textInputAutocapitalization(.never)
                .keyboardType(.URL)
            #endif
            Button("Go", systemImage: "arrow.right", action: load)
                .labelStyle(.iconOnly)
                .buttonStyle(.glass)
            if page.isLoading {
                Button("Stop", systemImage: "xmark") { page.stopLoading() }
                    .labelStyle(.iconOnly)
                    .buttonStyle(.glass)
            }
        }
        .padding()
    }

    private var statusBar: some View {
        HStack {
            if isAddressInvalid {
                Label("Enter an http or https address", systemImage: "exclamationmark.triangle")
                    .foregroundStyle(.orange)
            } else if page.isLoading {
                ProgressView(value: page.estimatedProgress)
            } else {
                Text(page.url?.host() ?? "")
                    .foregroundStyle(.secondary)
            }
        }
        .font(.footnote)
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

    private func load() {
        guard let url = WebAddress.url(from: address) else {
            isAddressInvalid = true
            return
        }
        isAddressInvalid = false
        address = url.absoluteString
        page.load(URLRequest(url: url))
    }
}

#Preview {
    NavigationStack { WebViewDemo() }
}
