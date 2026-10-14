import Testing
@testable import SwiftUIiOS26Showcase

@Suite("WebAddress")
struct WebAddressTests {
    @Test(arguments: [
        ("swift.org", "https://swift.org"),
        ("  www.apple.com/swiftui  ", "https://www.apple.com/swiftui"),
        ("http://example.com", "http://example.com"),
        ("HTTPS://Example.com/path?q=1#top", "HTTPS://Example.com/path?q=1#top"),
        ("localhost:8080", "https://localhost:8080")
    ])
    func acceptsWebAddresses(input: String, expected: String) {
        #expect(WebAddress.url(from: input)?.absoluteString == expected)
    }

    @Test(arguments: [
        "",
        "   ",
        "file:///etc/passwd",
        "javascript:alert(1)",
        "ftp://example.com",
        "mailto:someone@example.com",
        "https://user:secret@example.com",
        "two words.com",
        "https://"
    ])
    func rejectsEverythingElse(input: String) {
        #expect(WebAddress.url(from: input) == nil)
    }
}
