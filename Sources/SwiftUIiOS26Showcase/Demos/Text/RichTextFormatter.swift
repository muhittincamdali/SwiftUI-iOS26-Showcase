import SwiftUI

/// A character style the rich text demo can toggle.
public enum RichTextStyle: String, CaseIterable, Identifiable, Sendable {
    case bold
    case italic
    case underline
    case strikethrough

    public var id: Self { self }

    public var systemImage: String {
        switch self {
        case .bold: "bold"
        case .italic: "italic"
        case .underline: "underline"
        case .strikethrough: "strikethrough"
        }
    }
}

/// Toggles character styles on the selected part of an `AttributedString`.
///
/// This is the logic behind the rich text editor demo, kept out of the view
/// so it can be unit tested.
public struct RichTextFormatter {
    /// Used to resolve fonts, so "bold" means the resolved font is bold
    /// regardless of which text style it was created from.
    public var fontContext: Font.Context

    public init(fontContext: Font.Context) {
        self.fontContext = fontContext
    }

    /// Whether every run in the selection has `style`.
    ///
    /// For an insertion point this reports the typing attributes, which is
    /// what the next typed character will get.
    public func isApplied(
        _ style: RichTextStyle,
        in text: AttributedString,
        selection: AttributedTextSelection
    ) -> Bool {
        let containers = Array(selection.attributes(in: text))
        guard !containers.isEmpty else { return false }
        return containers.allSatisfy { isApplied(style, to: $0) }
    }

    /// Adds `style` to the selection, or removes it if the whole selection
    /// already has it.
    public func toggle(
        _ style: RichTextStyle,
        in text: inout AttributedString,
        selection: inout AttributedTextSelection
    ) {
        let enable = !isApplied(style, in: text, selection: selection)
        text.transformAttributes(in: &selection) { container in
            switch style {
            case .bold:
                container.font = (container.font ?? .body).bold(enable)
            case .italic:
                container.font = (container.font ?? .body).italic(enable)
            case .underline:
                container.underlineStyle = enable ? .single : nil
            case .strikethrough:
                container.strikethroughStyle = enable ? .single : nil
            }
        }
    }

    private func isApplied(_ style: RichTextStyle, to container: AttributeContainer) -> Bool {
        switch style {
        case .bold:
            (container.font ?? .body).resolve(in: fontContext).isBold
        case .italic:
            (container.font ?? .body).resolve(in: fontContext).isItalic
        case .underline:
            container.underlineStyle != nil
        case .strikethrough:
            container.strikethroughStyle != nil
        }
    }
}
