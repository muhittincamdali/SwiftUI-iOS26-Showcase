import Foundation

/// The demos available on one platform, with search and grouping.
///
/// The gallery is a thin view over this type, so its behavior is covered by
/// plain unit tests.
public struct ShowcaseCatalog: Sendable {
    /// One gallery section: a category and its demos in declaration order.
    public struct Section: Identifiable, Equatable, Sendable {
        public let category: ShowcaseCategory
        public let demos: [ShowcaseDemo]

        public var id: ShowcaseCategory { category }
    }

    public let platform: ShowcasePlatform
    public let demos: [ShowcaseDemo]

    public init(platform: ShowcasePlatform = .current) {
        self.platform = platform
        self.demos = ShowcaseDemo.allCases.filter { $0.isAvailable(on: platform) }
    }

    /// Demos whose title, summary or API list contains every word of `query`.
    ///
    /// Matching ignores case and diacritics. An empty or whitespace-only
    /// query returns all demos.
    public func demos(matching query: String) -> [ShowcaseDemo] {
        let terms = query
            .split(whereSeparator: \.isWhitespace)
            .map(String.init)
        guard !terms.isEmpty else { return demos }

        return demos.filter { demo in
            let haystack = ([demo.title, demo.summary] + demo.apis).joined(separator: " ")
            return terms.allSatisfy { term in
                haystack.range(of: term, options: [.caseInsensitive, .diacriticInsensitive]) != nil
            }
        }
    }

    /// The demos matching `query`, grouped by category. Empty categories are omitted.
    public func sections(matching query: String = "") -> [Section] {
        let matches = demos(matching: query)
        return ShowcaseCategory.allCases.compactMap { category in
            let demosInCategory = matches.filter { $0.category == category }
            guard !demosInCategory.isEmpty else { return nil }
            return Section(category: category, demos: demosInCategory)
        }
    }

    /// Looks up a demo by its identifier, for deep links and launch arguments.
    ///
    /// Returns `nil` for unknown identifiers and for demos that are not
    /// available on this catalog's platform.
    public func demo(withID id: String) -> ShowcaseDemo? {
        guard let demo = ShowcaseDemo(rawValue: id) else { return nil }
        return demos.contains(demo) ? demo : nil
    }
}
