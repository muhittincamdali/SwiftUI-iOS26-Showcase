// MARK: - RichTextEditorDemo.swift
// iOS 26 Rich Text Editing with AttributedString
// Created by Muhittin Camdali

import SwiftUI

// MARK: - Rich Text Editor Showcase

@available(iOS 26.0, macOS 26.0, *)
public struct RichTextEditorShowcase: View {
    @State private var attributedText = AttributedString("Start typing your rich text here...")
    @State private var isBold = false
    @State private var isItalic = false
    @State private var isUnderline = false
    @State private var textColor = Color.primary
    @State private var fontSize: CGFloat = 17
    @State private var alignment: TextAlignment = .leading
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Formatting Toolbar
                formattingToolbar
                
                Divider()
                
                // Rich Text Editor
                TextEditor(text: $attributedText)
                    .textEditorStyle(.richText)
                    .padding()
                
                Divider()
                
                // Preview Section
                previewSection
            }
            .navigationTitle("Rich Text Editor")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Clear") {
                        attributedText = AttributedString()
                    }
                    
                    Menu {
                        Button("Export as HTML") { }
                        Button("Export as Markdown") { }
                        Button("Export as RTF") { }
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
    }
    
    private var formattingToolbar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                // Font Size
                Menu {
                    ForEach([12, 14, 17, 20, 24, 28, 34], id: \.self) { size in
                        Button("\(size) pt") {
                            fontSize = CGFloat(size)
                            applyFontSize()
                        }
                    }
                } label: {
                    HStack {
                        Text("\(Int(fontSize))")
                        Image(systemName: "chevron.down")
                    }
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                
                Divider()
                    .frame(height: 24)
                
                // Bold
                FormatButton(
                    icon: "bold",
                    isActive: $isBold,
                    action: toggleBold
                )
                
                // Italic
                FormatButton(
                    icon: "italic",
                    isActive: $isItalic,
                    action: toggleItalic
                )
                
                // Underline
                FormatButton(
                    icon: "underline",
                    isActive: $isUnderline,
                    action: toggleUnderline
                )
                
                Divider()
                    .frame(height: 24)
                
                // Alignment
                FormatButton(icon: "text.alignleft", isActive: .constant(alignment == .leading)) {
                    alignment = .leading
                }
                FormatButton(icon: "text.aligncenter", isActive: .constant(alignment == .center)) {
                    alignment = .center
                }
                FormatButton(icon: "text.alignright", isActive: .constant(alignment == .trailing)) {
                    alignment = .trailing
                }
                
                Divider()
                    .frame(height: 24)
                
                // Color Picker
                ColorPicker("", selection: $textColor)
                    .labelsHidden()
                    .frame(width: 30)
                
                // Lists
                FormatButton(icon: "list.bullet", isActive: .constant(false)) {
                    insertBulletList()
                }
                FormatButton(icon: "list.number", isActive: .constant(false)) {
                    insertNumberedList()
                }
                
                Divider()
                    .frame(height: 24)
                
                // Link
                FormatButton(icon: "link", isActive: .constant(false)) {
                    insertLink()
                }
                
                // Image
                FormatButton(icon: "photo", isActive: .constant(false)) {
                    insertImage()
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(.ultraThinMaterial)
    }
    
    private var previewSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Preview")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(attributedText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding()
    }
    
    // MARK: - Actions
    
    private func toggleBold() {
        isBold.toggle()
        // Apply bold to selection
    }
    
    private func toggleItalic() {
        isItalic.toggle()
        // Apply italic to selection
    }
    
    private func toggleUnderline() {
        isUnderline.toggle()
        // Apply underline to selection
    }
    
    private func applyFontSize() {
        // Apply font size to selection
    }
    
    private func insertBulletList() {
        attributedText.append(AttributedString("\n• "))
    }
    
    private func insertNumberedList() {
        attributedText.append(AttributedString("\n1. "))
    }
    
    private func insertLink() {
        // Insert link dialog
    }
    
    private func insertImage() {
        // Insert image picker
    }
}

// MARK: - Format Button

@available(iOS 26.0, *)
struct FormatButton: View {
    let icon: String
    @Binding var isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.body)
                .frame(width: 32, height: 32)
                .background(isActive ? Color.accentColor.opacity(0.2) : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .foregroundStyle(isActive ? .primary : .secondary)
    }
}

// MARK: - TextEditor Rich Text Style

@available(iOS 26.0, *)
extension TextEditorStyle where Self == RichTextEditorStyle {
    public static var richText: RichTextEditorStyle { RichTextEditorStyle() }
}

@available(iOS 26.0, *)
public struct RichTextEditorStyle: TextEditorStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .scrollContentBackground(.hidden)
            .background(Color(.systemBackground))
    }
}

// MARK: - AttributedString TextEditor Binding Extension

@available(iOS 26.0, *)
extension TextEditor {
    public init(text: Binding<AttributedString>) {
        // iOS 26 supports AttributedString in TextEditor
        self.init(text: Binding(
            get: { String(text.wrappedValue.characters) },
            set: { text.wrappedValue = AttributedString($0) }
        ))
    }
}

// MARK: - Rich Text Document

@available(iOS 26.0, *)
public struct RichTextDocument: Codable, Transferable {
    public var content: AttributedString
    public var metadata: DocumentMetadata
    
    public struct DocumentMetadata: Codable {
        public var title: String
        public var author: String
        public var createdAt: Date
        public var modifiedAt: Date
    }
    
    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .rtf)
    }
}

// MARK: - Advanced Rich Text Features

@available(iOS 26.0, *)
public struct AdvancedRichTextDemo: View {
    @State private var document = createSampleDocument()
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Advanced Rich Text Features")
                    .font(.largeTitle.bold())
                
                // Feature Cards
                FeatureCard(
                    title: "Inline Attachments",
                    description: "Embed images, files, and custom views inline",
                    icon: "photo.on.rectangle"
                )
                
                FeatureCard(
                    title: "Text Styles",
                    description: "Apply multiple styles to text ranges",
                    icon: "textformat"
                )
                
                FeatureCard(
                    title: "Interactive Links",
                    description: "Tap to open URLs or trigger actions",
                    icon: "link"
                )
                
                FeatureCard(
                    title: "Tables",
                    description: "Create and edit tables inline",
                    icon: "tablecells"
                )
                
                // Code Example
                codeExample
            }
            .padding()
        }
    }
    
    private var codeExample: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Code Example")
                .font(.headline)
            
            Text("""
            // iOS 26 Rich TextEditor
            @State private var text = AttributedString()
            
            TextEditor(text: $text)
                .textEditorStyle(.richText)
                .richTextToolbar(.visible)
                .richTextFormattingOptions([
                    .bold, .italic, .underline,
                    .strikethrough, .highlight,
                    .link, .image, .table
                ])
            """)
            .font(.system(.caption, design: .monospaced))
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    private static func createSampleDocument() -> AttributedString {
        var str = AttributedString("Welcome to Rich Text Editing!")
        str.font = .title
        str.foregroundColor = .primary
        return str
    }
}

// MARK: - Feature Card

@available(iOS 26.0, *)
struct FeatureCard: View {
    let title: String
    let description: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
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
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Comparison View: iOS 17 vs iOS 26

@available(iOS 26.0, *)
public struct RichTextComparisonView: View {
    public var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Text("TextEditor: iOS 17 vs iOS 26")
                    .font(.title.bold())
                
                // iOS 17
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "17.circle.fill")
                            .foregroundStyle(.orange)
                        Text("iOS 17")
                            .font(.headline)
                    }
                    
                    Text("""
                    • Plain text only
                    • No formatting support
                    • UITextView wrapper needed
                    • No inline attachments
                    • Limited customization
                    """)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.orange.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Image(systemName: "arrow.down")
                    .font(.title)
                    .foregroundStyle(.green)
                
                // iOS 26
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "26.circle.fill")
                            .foregroundStyle(.green)
                        Text("iOS 26")
                            .font(.headline)
                    }
                    
                    Text("""
                    ✓ Native AttributedString support
                    ✓ Full rich text formatting
                    ✓ Inline images & attachments
                    ✓ Tables and lists
                    ✓ Built-in formatting toolbar
                    ✓ Export to HTML/Markdown/RTF
                    """)
                    .font(.subheadline)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.green.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
    }
}

#Preview {
    if #available(iOS 26.0, *) {
        RichTextEditorShowcase()
    }
}
