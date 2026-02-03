// GlassFormsDemo.swift
// SwiftUI-iOS26-Showcase
//
// Demonstrates Liquid Glass styled form elements
// Includes text fields, toggles, pickers, and validation

import SwiftUI

// MARK: - Glass Text Field Style

/// A glass-styled text field
struct GlassTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let icon: String?
    let isSecure: Bool
    let validation: ((String) -> ValidationResult)?
    
    @State private var isFocused = false
    @State private var showPassword = false
    @FocusState private var fieldFocus: Bool
    
    enum ValidationResult {
        case valid
        case invalid(String)
        case none
        
        var isValid: Bool {
            if case .valid = self { return true }
            return false
        }
        
        var message: String? {
            if case .invalid(let msg) = self { return msg }
            return nil
        }
    }
    
    init(
        _ title: String,
        placeholder: String = "",
        text: Binding<String>,
        icon: String? = nil,
        isSecure: Bool = false,
        validation: ((String) -> ValidationResult)? = nil
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.icon = icon
        self.isSecure = isSecure
        self.validation = validation
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Label
            Text(title)
                .font(.subheadline.bold())
                .foregroundStyle(.white.opacity(0.8))
            
            // Field
            HStack(spacing: 12) {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundStyle(.white.opacity(0.5))
                        .frame(width: 20)
                }
                
                if isSecure && !showPassword {
                    SecureField(placeholder, text: $text)
                        .textFieldStyle(.plain)
                        .foregroundStyle(.white)
                        .focused($fieldFocus)
                } else {
                    TextField(placeholder, text: $text)
                        .textFieldStyle(.plain)
                        .foregroundStyle(.white)
                        .focused($fieldFocus)
                }
                
                if isSecure {
                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundStyle(.white.opacity(0.5))
                    }
                }
                
                // Validation indicator
                if let validation = validation {
                    let result = validation(text)
                    if !text.isEmpty {
                        Image(systemName: result.isValid ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundStyle(result.isValid ? .green : .red)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(fieldFocus ? 0.08 : 0.03))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(
                                fieldFocus ? Color.blue.opacity(0.5) : Color.white.opacity(0.1),
                                lineWidth: fieldFocus ? 2 : 1
                            )
                    )
            )
            .animation(.easeInOut(duration: 0.2), value: fieldFocus)
            
            // Validation message
            if let validation = validation,
               case .invalid(let message) = validation(text),
               !text.isEmpty {
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.red.opacity(0.8))
                    .padding(.leading, 4)
            }
        }
        .onChange(of: fieldFocus) { _, newValue in
            isFocused = newValue
        }
    }
}

// MARK: - Glass Text Area

/// A glass-styled multi-line text area
struct GlassTextArea: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let minHeight: CGFloat
    let maxCharacters: Int?
    
    @FocusState private var isFocused: Bool
    
    init(
        _ title: String,
        placeholder: String = "",
        text: Binding<String>,
        minHeight: CGFloat = 100,
        maxCharacters: Int? = nil
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.minHeight = minHeight
        self.maxCharacters = maxCharacters
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundStyle(.white.opacity(0.8))
                
                Spacer()
                
                if let max = maxCharacters {
                    Text("\(text.count)/\(max)")
                        .font(.caption)
                        .foregroundStyle(text.count > max ? .red : .white.opacity(0.5))
                }
            }
            
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundStyle(.white.opacity(0.3))
                        .padding(.horizontal, 4)
                        .padding(.vertical, 8)
                }
                
                TextEditor(text: $text)
                    .scrollContentBackground(.hidden)
                    .foregroundStyle(.white)
                    .focused($isFocused)
                    .frame(minHeight: minHeight)
                    .onChange(of: text) { _, newValue in
                        if let max = maxCharacters, newValue.count > max {
                            text = String(newValue.prefix(max))
                        }
                    }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(isFocused ? 0.08 : 0.03))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(
                                isFocused ? Color.blue.opacity(0.5) : Color.white.opacity(0.1),
                                lineWidth: isFocused ? 2 : 1
                            )
                    )
            )
        }
    }
}

// MARK: - Glass Toggle

/// A glass-styled toggle switch
struct GlassToggle: View {
    let title: String
    let subtitle: String?
    let icon: String?
    @Binding var isOn: Bool
    
    init(
        _ title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        isOn: Binding<Bool>
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self._isOn = isOn
    }
    
    var body: some View {
        HStack(spacing: 14) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(isOn ? .blue : .white.opacity(0.5))
                    .frame(width: 28)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .foregroundStyle(.white)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.5))
                }
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.blue)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.white.opacity(0.03))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
    }
}

// MARK: - Glass Picker

/// A glass-styled picker
struct GlassPicker<T: Hashable & CustomStringConvertible>: View {
    let title: String
    let options: [T]
    @Binding var selection: T
    let icon: String?
    
    init(
        _ title: String,
        options: [T],
        selection: Binding<T>,
        icon: String? = nil
    ) {
        self.title = title
        self.options = options
        self._selection = selection
        self.icon = icon
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.bold())
                .foregroundStyle(.white.opacity(0.8))
            
            HStack(spacing: 12) {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundStyle(.white.opacity(0.5))
                        .frame(width: 20)
                }
                
                Picker("", selection: $selection) {
                    ForEach(options, id: \.self) { option in
                        Text(option.description)
                            .tag(option)
                    }
                }
                .pickerStyle(.menu)
                .tint(.white)
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.03))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
    }
}

// MARK: - Glass Segmented Control

/// A glass-styled segmented control
struct GlassSegmentedControl<T: Hashable & CaseIterable & CustomStringConvertible>: View where T.AllCases: RandomAccessCollection {
    let title: String?
    @Binding var selection: T
    
    init(_ title: String? = nil, selection: Binding<T>) {
        self.title = title
        self._selection = selection
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title = title {
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundStyle(.white.opacity(0.8))
            }
            
            HStack(spacing: 4) {
                ForEach(Array(T.allCases), id: \.self) { option in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selection = option
                        }
                    } label: {
                        Text(option.description)
                            .font(.subheadline.bold())
                            .foregroundStyle(selection == option ? .white : .white.opacity(0.6))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(selection == option ? Color.blue.opacity(0.4) : Color.clear)
                            )
                    }
                }
            }
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.white.opacity(0.03))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
    }
}

// MARK: - Glass Slider

/// A glass-styled slider
struct GlassSlider: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double?
    let showValue: Bool
    let valueFormatter: ((Double) -> String)?
    
    init(
        _ title: String,
        value: Binding<Double>,
        in range: ClosedRange<Double>,
        step: Double? = nil,
        showValue: Bool = true,
        valueFormatter: ((Double) -> String)? = nil
    ) {
        self.title = title
        self._value = value
        self.range = range
        self.step = step
        self.showValue = showValue
        self.valueFormatter = valueFormatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundStyle(.white.opacity(0.8))
                
                Spacer()
                
                if showValue {
                    Text(formattedValue)
                        .font(.subheadline.monospacedDigit())
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
            
            if let step = step {
                Slider(value: $value, in: range, step: step)
                    .tint(.blue)
            } else {
                Slider(value: $value, in: range)
                    .tint(.blue)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.white.opacity(0.03))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
    }
    
    private var formattedValue: String {
        if let formatter = valueFormatter {
            return formatter(value)
        }
        return String(format: "%.1f", value)
    }
}

// MARK: - Glass Stepper

/// A glass-styled stepper
struct GlassStepper: View {
    let title: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    
    init(_ title: String, value: Binding<Int>, in range: ClosedRange<Int>) {
        self.title = title
        self._value = value
        self.range = range
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .foregroundStyle(.white)
            
            Spacer()
            
            HStack(spacing: 0) {
                Button {
                    if value > range.lowerBound {
                        value -= 1
                    }
                } label: {
                    Image(systemName: "minus")
                        .font(.headline)
                        .foregroundStyle(value > range.lowerBound ? .white : .white.opacity(0.3))
                        .frame(width: 44, height: 36)
                }
                .disabled(value <= range.lowerBound)
                
                Text("\(value)")
                    .font(.headline.monospacedDigit())
                    .foregroundStyle(.white)
                    .frame(width: 50)
                
                Button {
                    if value < range.upperBound {
                        value += 1
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.headline)
                        .foregroundStyle(value < range.upperBound ? .white : .white.opacity(0.3))
                        .frame(width: 44, height: 36)
                }
                .disabled(value >= range.upperBound)
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.1))
            )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.white.opacity(0.03))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
    }
}

// MARK: - Glass Date Picker

/// A glass-styled date picker
struct GlassDatePicker: View {
    let title: String
    @Binding var date: Date
    let displayedComponents: DatePicker.Components
    
    init(
        _ title: String,
        selection: Binding<Date>,
        displayedComponents: DatePicker.Components = [.date, .hourAndMinute]
    ) {
        self.title = title
        self._date = selection
        self.displayedComponents = displayedComponents
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.bold())
                .foregroundStyle(.white.opacity(0.8))
            
            DatePicker("", selection: $date, displayedComponents: displayedComponents)
                .datePickerStyle(.compact)
                .labelsHidden()
                .tint(.blue)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.03))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
        }
    }
}

// MARK: - Demo View

/// Comprehensive form elements demonstration
public struct GlassFormsDemo: View {
    // Form state
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var bio = ""
    @State private var notifications = true
    @State private var darkMode = false
    @State private var autoBackup = true
    @State private var selectedCountry = "United States"
    @State private var selectedTheme: ThemeOption = .system
    @State private var brightness: Double = 75
    @State private var fontSize: Int = 16
    @State private var selectedDate = Date()
    
    enum ThemeOption: String, CaseIterable, CustomStringConvertible {
        case light = "Light"
        case dark = "Dark"
        case system = "System"
        
        var description: String { rawValue }
    }
    
    let countries = ["United States", "Canada", "United Kingdom", "Germany", "France", "Japan", "Australia"]
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                
                textFieldsSection
                
                textAreaSection
                
                togglesSection
                
                pickersSection
                
                slidersSection
                
                datePickerSection
                
                submitSection
            }
            .padding()
        }
        .background(backgroundGradient)
        .navigationTitle("Glass Forms")
    }
    
    // MARK: - Sections
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Glass Form Elements")
                .font(.title.bold())
                .foregroundStyle(.white)
            
            Text("A comprehensive collection of form controls styled with the Liquid Glass design language. All components support validation, accessibility, and keyboard navigation.")
                .font(.body)
                .foregroundStyle(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var textFieldsSection: some View {
        VStack(spacing: 16) {
            SectionHeader(title: "Text Fields", icon: "textformat")
            
            GlassTextField(
                "Username",
                placeholder: "Enter username",
                text: $username,
                icon: "person",
                validation: { text in
                    if text.isEmpty { return .none }
                    return text.count >= 3 ? .valid : .invalid("Minimum 3 characters")
                }
            )
            
            GlassTextField(
                "Email",
                placeholder: "your@email.com",
                text: $email,
                icon: "envelope",
                validation: { text in
                    if text.isEmpty { return .none }
                    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                    let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
                    return predicate.evaluate(with: text) ? .valid : .invalid("Invalid email format")
                }
            )
            
            GlassTextField(
                "Password",
                placeholder: "Enter password",
                text: $password,
                icon: "lock",
                isSecure: true,
                validation: { text in
                    if text.isEmpty { return .none }
                    return text.count >= 8 ? .valid : .invalid("Minimum 8 characters")
                }
            )
        }
    }
    
    private var textAreaSection: some View {
        VStack(spacing: 16) {
            SectionHeader(title: "Text Area", icon: "text.alignleft")
            
            GlassTextArea(
                "Bio",
                placeholder: "Tell us about yourself...",
                text: $bio,
                minHeight: 100,
                maxCharacters: 200
            )
        }
    }
    
    private var togglesSection: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Toggles", icon: "switch.2")
            
            GlassToggle(
                "Push Notifications",
                subtitle: "Receive alerts for important updates",
                icon: "bell",
                isOn: $notifications
            )
            
            GlassToggle(
                "Dark Mode",
                subtitle: "Use dark appearance",
                icon: "moon",
                isOn: $darkMode
            )
            
            GlassToggle(
                "Auto Backup",
                subtitle: "Backup data to iCloud",
                icon: "icloud",
                isOn: $autoBackup
            )
        }
    }
    
    private var pickersSection: some View {
        VStack(spacing: 16) {
            SectionHeader(title: "Pickers", icon: "list.bullet")
            
            GlassPicker(
                "Country",
                options: countries,
                selection: $selectedCountry,
                icon: "globe"
            )
            
            GlassSegmentedControl(
                "Theme",
                selection: $selectedTheme
            )
        }
    }
    
    private var slidersSection: some View {
        VStack(spacing: 16) {
            SectionHeader(title: "Sliders & Steppers", icon: "slider.horizontal.3")
            
            GlassSlider(
                "Brightness",
                value: $brightness,
                in: 0...100,
                valueFormatter: { "\(Int($0))%" }
            )
            
            GlassStepper("Font Size", value: $fontSize, in: 12...24)
        }
    }
    
    private var datePickerSection: some View {
        VStack(spacing: 16) {
            SectionHeader(title: "Date Picker", icon: "calendar")
            
            GlassDatePicker(
                "Event Date",
                selection: $selectedDate,
                displayedComponents: [.date, .hourAndMinute]
            )
        }
    }
    
    private var submitSection: some View {
        VStack(spacing: 16) {
            Button {
                // Submit action
            } label: {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Save Settings")
                }
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(.blue.opacity(0.4))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .strokeBorder(Color.blue.opacity(0.6), lineWidth: 1)
                        )
                )
            }
            
            Button {
                resetForm()
            } label: {
                Text("Reset to Defaults")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
    }
    
    // MARK: - Helpers
    
    private func resetForm() {
        username = ""
        email = ""
        password = ""
        bio = ""
        notifications = true
        darkMode = false
        autoBackup = true
        selectedCountry = "United States"
        selectedTheme = .system
        brightness = 75
        fontSize = 16
        selectedDate = Date()
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 0.1, green: 0.12, blue: 0.18),
                Color(red: 0.15, green: 0.1, blue: 0.2)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

// MARK: - Section Header

struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(.white.opacity(0.6))
            
            Text(title)
                .font(.headline)
                .foregroundStyle(.white.opacity(0.8))
            
            Spacer()
        }
    }
}

// MARK: - Preview

#Preview("Glass Forms Demo") {
    NavigationStack {
        GlassFormsDemo()
    }
}
