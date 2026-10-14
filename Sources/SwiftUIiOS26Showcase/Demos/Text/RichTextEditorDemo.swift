import SwiftUI

struct RichTextEditorDemo: View {
    @Environment(\.fontResolutionContext) private var fontContext
    @State private var text = AttributedString(
        "Select some of this text and use the buttons to style it. The editor is bound to an AttributedString."
    )
    @State private var selection = AttributedTextSelection()

    private var formatter: RichTextFormatter {
        RichTextFormatter(fontContext: fontContext)
    }

    var body: some View {
        DemoPage(demo: .richTextEditor) {
            DemoSection(title: "Editor") {
                styleBar
                TextEditor(text: $text, selection: $selection)
                    .frame(minHeight: 180)
                    .padding(8)
                    .background(.background.secondary, in: .rect(cornerRadius: 12))
            }
            DemoSection(title: "Rendered as Text") {
                Text(text)
            }
        }
    }

    private var styleBar: some View {
        HStack(spacing: 8) {
            ForEach(RichTextStyle.allCases) { style in
                let isActive = formatter.isApplied(style, in: text, selection: selection)
                Button(style.rawValue.capitalized, systemImage: style.systemImage) {
                    formatter.toggle(style, in: &text, selection: &selection)
                }
                .labelStyle(.iconOnly)
                .buttonStyle(.glass)
                .tint(isActive ? .accentColor : nil)
                .accessibilityAddTraits(isActive ? .isSelected : [])
            }
        }
    }
}

#Preview {
    NavigationStack { RichTextEditorDemo() }
}
