import Foundation

/// Turns what a user types into an address bar into a loadable URL.
public enum WebAddress {
    private static let allowedSchemes: Set<String> = ["http", "https"]
    private static let defaultScheme = "https"

    /// Returns an `http` or `https` URL for `input`, or `nil` if it cannot be one.
    ///
    /// Leading and trailing whitespace is ignored. Input without a scheme gets
    /// `https://`. Input with any other scheme (`file:`, `javascript:` ...),
    /// with inner whitespace, without a host, or with user credentials is rejected.
    public static func url(from input: String) -> URL? {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !trimmed.contains(where: \.isWhitespace) else { return nil }

        let candidate = trimmed.contains("://") ? trimmed : "\(defaultScheme)://\(trimmed)"
        guard
            let components = URLComponents(string: candidate),
            let scheme = components.scheme?.lowercased(),
            allowedSchemes.contains(scheme),
            let host = components.host,
            !host.isEmpty,
            // Also catches "mailto:a@b.com", which would otherwise parse as user "mailto" on host "b.com".
            components.user == nil,
            components.password == nil
        else { return nil }

        return components.url
    }
}
