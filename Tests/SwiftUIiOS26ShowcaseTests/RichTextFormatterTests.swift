import SwiftUI
import Testing
@testable import SwiftUIiOS26Showcase

@Suite("RichTextFormatter")
@MainActor
struct RichTextFormatterTests {
    private let formatter = RichTextFormatter(fontContext: EnvironmentValues().fontResolutionContext)

    /// "Hello world" with "world" selected.
    private func makeText() -> (AttributedString, AttributedTextSelection) {
        let text = AttributedString("Hello world")
        let start = text.index(text.startIndex, offsetByCharacters: 6)
        return (text, AttributedTextSelection(range: start..<text.endIndex))
    }

    @Test(arguments: RichTextStyle.allCases)
    func toggleAppliesThenRemovesTheStyle(style: RichTextStyle) {
        var (text, selection) = makeText()
        #expect(!formatter.isApplied(style, in: text, selection: selection))

        formatter.toggle(style, in: &text, selection: &selection)
        #expect(formatter.isApplied(style, in: text, selection: selection))

        formatter.toggle(style, in: &text, selection: &selection)
        #expect(!formatter.isApplied(style, in: text, selection: selection))
    }

    @Test func onlyTheSelectionChanges() {
        var (text, selection) = makeText()
        formatter.toggle(.underline, in: &text, selection: &selection)

        let underlined = text.runs
            .filter { $0.underlineStyle != nil }
            .map { String(text[$0.range].characters) }
        #expect(underlined == ["world"])
    }

    @Test func boldAndItalicCombine() {
        var (text, selection) = makeText()
        formatter.toggle(.bold, in: &text, selection: &selection)
        formatter.toggle(.italic, in: &text, selection: &selection)

        #expect(formatter.isApplied(.bold, in: text, selection: selection))
        #expect(formatter.isApplied(.italic, in: text, selection: selection))
    }

    @Test func partiallyStyledSelectionIsNotApplied() {
        var text = AttributedString("Hello world")
        let world = text.index(text.startIndex, offsetByCharacters: 6)..<text.endIndex
        text[world].strikethroughStyle = .single
        var selection = AttributedTextSelection(range: text.startIndex..<text.endIndex)

        #expect(!formatter.isApplied(.strikethrough, in: text, selection: selection))

        // Toggling a mixed selection applies the style everywhere.
        formatter.toggle(.strikethrough, in: &text, selection: &selection)
        #expect(text.runs.allSatisfy { $0.strikethroughStyle != nil })
    }

    @Test func systemImagesAreSFSymbolNames() {
        #expect(RichTextStyle.allCases.map(\.systemImage) == ["bold", "italic", "underline", "strikethrough"])
    }
}
