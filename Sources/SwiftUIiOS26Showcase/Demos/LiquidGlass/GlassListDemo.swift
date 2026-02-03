// GlassListDemo.swift
// SwiftUI-iOS26-Showcase
//
// Demonstrates Liquid Glass styled lists and collection views
// Features swipe actions, selection, and modern list patterns

import SwiftUI

// MARK: - Data Models

/// A sample item for demonstrating glass list features
struct GlassListItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let iconColor: Color
    let badge: Int?
    let isNew: Bool
    
    static let sampleItems: [GlassListItem] = [
        GlassListItem(title: "Inbox", subtitle: "4 unread messages", icon: "envelope.fill", iconColor: .blue, badge: 4, isNew: true),
        GlassListItem(title: "Starred", subtitle: "12 items", icon: "star.fill", iconColor: .yellow, badge: nil, isNew: false),
        GlassListItem(title: "Sent", subtitle: "Last sent 2 hours ago", icon: "paperplane.fill", iconColor: .green, badge: nil, isNew: false),
        GlassListItem(title: "Drafts", subtitle: "2 drafts saved", icon: "doc.fill", iconColor: .orange, badge: 2, isNew: false),
        GlassListItem(title: "Archive", subtitle: "156 archived items", icon: "archivebox.fill", iconColor: .purple, badge: nil, isNew: false),
        GlassListItem(title: "Trash", subtitle: "Empty", icon: "trash.fill", iconColor: .red, badge: nil, isNew: false),
        GlassListItem(title: "Important", subtitle: "8 important items", icon: "exclamationmark.circle.fill", iconColor: .pink, badge: 8, isNew: true),
        GlassListItem(title: "Work", subtitle: "Project updates", icon: "briefcase.fill", iconColor: .indigo, badge: nil, isNew: false),
        GlassListItem(title: "Personal", subtitle: "Family & friends", icon: "person.2.fill", iconColor: .teal, badge: nil, isNew: false)
    ]
}

/// A user item for contact list demos
struct ContactItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let role: String
    let initials: String
    let status: Status
    let color: Color
    
    enum Status: String {
        case online = "Online"
        case away = "Away"
        case offline = "Offline"
        
        var color: Color {
            switch self {
            case .online: return .green
            case .away: return .yellow
            case .offline: return .gray
            }
        }
    }
    
    static let sampleContacts: [ContactItem] = [
        ContactItem(name: "Sarah Miller", role: "Product Designer", initials: "SM", status: .online, color: .blue),
        ContactItem(name: "James Wilson", role: "iOS Developer", initials: "JW", status: .online, color: .purple),
        ContactItem(name: "Emily Chen", role: "UX Researcher", initials: "EC", status: .away, color: .pink),
        ContactItem(name: "Michael Brown", role: "Backend Engineer", initials: "MB", status: .offline, color: .green),
        ContactItem(name: "Lisa Anderson", role: "Project Manager", initials: "LA", status: .online, color: .orange),
        ContactItem(name: "David Kim", role: "QA Engineer", initials: "DK", status: .away, color: .teal),
        ContactItem(name: "Rachel Green", role: "Marketing Lead", initials: "RG", status: .offline, color: .indigo),
        ContactItem(name: "Tom Harris", role: "DevOps Engineer", initials: "TH", status: .online, color: .red)
    ]
}

// MARK: - Glass List Row

/// A glass-styled row for lists
struct GlassListRow: View {
    let item: GlassListItem
    let onTap: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(item.iconColor.opacity(0.2))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: item.icon)
                        .font(.system(size: 18))
                        .foregroundStyle(item.iconColor)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(item.title)
                            .font(.headline)
                            .foregroundStyle(.white)
                        
                        if item.isNew {
                            Text("NEW")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(
                                    Capsule()
                                        .fill(Color.blue)
                                )
                        }
                    }
                    
                    Text(item.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.6))
                }
                
                Spacer()
                
                // Badge
                if let badge = item.badge {
                    Text("\(badge)")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(item.iconColor)
                        )
                }
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.4))
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(isPressed ? 0.1 : 0.05))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
        .scaleEffect(isPressed ? 0.98 : 1)
        .animation(.easeInOut(duration: 0.15), value: isPressed)
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

// MARK: - Glass Contact Row

/// A glass-styled contact list row
struct GlassContactRow: View {
    let contact: ContactItem
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [contact.color, contact.color.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)
                    
                    Text(contact.initials)
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    // Status indicator
                    Circle()
                        .fill(contact.status.color)
                        .frame(width: 12, height: 12)
                        .overlay(
                            Circle()
                                .strokeBorder(Color.black.opacity(0.3), lineWidth: 2)
                        )
                        .offset(x: 16, y: 16)
                }
                
                // Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(contact.name)
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    Text(contact.role)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.6))
                }
                
                Spacer()
                
                // Selection indicator
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.blue)
                        .font(.title3)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(isSelected ? Color.blue.opacity(0.15) : Color.white.opacity(0.03))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(
                                isSelected ? Color.blue.opacity(0.4) : Color.white.opacity(0.08),
                                lineWidth: 1
                            )
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Glass Section Header

/// A glass-styled section header
struct GlassSectionHeader: View {
    let title: String
    let icon: String?
    let action: (() -> Void)?
    
    init(title: String, icon: String? = nil, action: (() -> Void)? = nil) {
        self.title = title
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        HStack {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.6))
            }
            
            Text(title)
                .font(.subheadline.bold())
                .foregroundStyle(.white.opacity(0.6))
                .textCase(.uppercase)
            
            Spacer()
            
            if let action = action {
                Button(action: action) {
                    Text("See All")
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                }
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 8)
    }
}

// MARK: - Swipeable Glass Row

/// A glass row with swipe actions
struct SwipeableGlassRow<Content: View>: View {
    @ViewBuilder let content: Content
    let leadingActions: [SwipeAction]
    let trailingActions: [SwipeAction]
    
    @State private var offset: CGFloat = 0
    @State private var showingLeading = false
    @State private var showingTrailing = false
    
    struct SwipeAction: Identifiable {
        let id = UUID()
        let icon: String
        let color: Color
        let action: () -> Void
    }
    
    var body: some View {
        ZStack {
            // Leading actions
            HStack(spacing: 0) {
                ForEach(leadingActions) { action in
                    Button {
                        action.action()
                        resetOffset()
                    } label: {
                        Image(systemName: action.icon)
                            .font(.title3)
                            .foregroundStyle(.white)
                            .frame(width: 60, height: 60)
                            .background(action.color)
                    }
                }
                Spacer()
            }
            
            // Trailing actions
            HStack(spacing: 0) {
                Spacer()
                ForEach(trailingActions) { action in
                    Button {
                        action.action()
                        resetOffset()
                    } label: {
                        Image(systemName: action.icon)
                            .font(.title3)
                            .foregroundStyle(.white)
                            .frame(width: 60, height: 60)
                            .background(action.color)
                    }
                }
            }
            
            // Main content
            content
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let translation = value.translation.width
                            
                            if translation > 0 && !leadingActions.isEmpty {
                                offset = min(translation, CGFloat(leadingActions.count) * 60)
                            } else if translation < 0 && !trailingActions.isEmpty {
                                offset = max(translation, -CGFloat(trailingActions.count) * 60)
                            }
                        }
                        .onEnded { value in
                            let threshold: CGFloat = 50
                            
                            if value.translation.width > threshold && !leadingActions.isEmpty {
                                withAnimation(.spring(response: 0.3)) {
                                    offset = CGFloat(leadingActions.count) * 60
                                    showingLeading = true
                                }
                            } else if value.translation.width < -threshold && !trailingActions.isEmpty {
                                withAnimation(.spring(response: 0.3)) {
                                    offset = -CGFloat(trailingActions.count) * 60
                                    showingTrailing = true
                                }
                            } else {
                                resetOffset()
                            }
                        }
                )
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func resetOffset() {
        withAnimation(.spring(response: 0.3)) {
            offset = 0
            showingLeading = false
            showingTrailing = false
        }
    }
}

// MARK: - Glass Grouped List

/// A grouped list with glass styling
struct GlassGroupedList<Header: View, Content: View>: View {
    let header: Header
    let content: Content
    
    init(
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content
    ) {
        self.header = header()
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            header
            
            VStack(spacing: 1) {
                content
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
            )
        }
    }
}

// MARK: - Demo View

/// Comprehensive demo of glass list styles
public struct GlassListDemo: View {
    @State private var selectedItem: GlassListItem?
    @State private var selectedContacts: Set<UUID> = []
    @State private var searchText = ""
    @State private var listStyle: ListStyleOption = .separated
    
    enum ListStyleOption: String, CaseIterable {
        case separated = "Separated"
        case grouped = "Grouped"
        case inset = "Inset"
    }
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                
                stylePickerSection
                
                searchSection
                
                switch listStyle {
                case .separated:
                    separatedListSection
                case .grouped:
                    groupedListSection
                case .inset:
                    insetListSection
                }
                
                contactsSection
                
                swipeActionsSection
                
                codeSection
            }
            .padding()
        }
        .background(backgroundGradient)
        .navigationTitle("Glass Lists")
    }
    
    // MARK: - Sections
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Glass List Styles")
                .font(.title.bold())
                .foregroundStyle(.white)
            
            Text("Modern list presentations with Liquid Glass effects, supporting swipe actions, multi-selection, and various layout styles.")
                .font(.body)
                .foregroundStyle(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var stylePickerSection: some View {
        HStack(spacing: 8) {
            ForEach(ListStyleOption.allCases, id: \.self) { style in
                Button(style.rawValue) {
                    withAnimation {
                        listStyle = style
                    }
                }
                .font(.subheadline.bold())
                .foregroundStyle(listStyle == style ? .white : .white.opacity(0.6))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(listStyle == style ? Color.blue.opacity(0.4) : Color.white.opacity(0.1))
                )
            }
        }
    }
    
    private var searchSection: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.white.opacity(0.5))
            
            TextField("Search...", text: $searchText)
                .foregroundStyle(.white)
                .textFieldStyle(.plain)
            
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.white.opacity(0.5))
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    private var separatedListSection: some View {
        VStack(spacing: 12) {
            GlassSectionHeader(title: "Folders", icon: "folder")
            
            ForEach(filteredItems) { item in
                GlassListRow(item: item) {
                    selectedItem = item
                }
            }
        }
    }
    
    private var groupedListSection: some View {
        GlassGroupedList {
            GlassSectionHeader(title: "Mailboxes", icon: "tray")
        } content: {
            ForEach(filteredItems) { item in
                GroupedListRow(item: item)
            }
        }
    }
    
    private var insetListSection: some View {
        VStack(spacing: 0) {
            GlassSectionHeader(title: "Quick Access", icon: "bolt")
            
            VStack(spacing: 0) {
                ForEach(filteredItems) { item in
                    InsetListRow(item: item)
                    
                    if item.id != filteredItems.last?.id {
                        Divider()
                            .background(Color.white.opacity(0.1))
                            .padding(.leading, 76)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
            )
        }
    }
    
    private var contactsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                GlassSectionHeader(title: "Team Members", icon: "person.2")
                
                Spacer()
                
                Text("\(selectedContacts.count) selected")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
            }
            
            ForEach(ContactItem.sampleContacts) { contact in
                GlassContactRow(
                    contact: contact,
                    isSelected: selectedContacts.contains(contact.id)
                ) {
                    toggleContactSelection(contact)
                }
            }
        }
    }
    
    private var swipeActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            GlassSectionHeader(title: "Swipe Actions", icon: "hand.draw")
            
            SwipeableGlassRow(
                content: {
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundStyle(.blue)
                        Text("Swipe me left or right")
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                    )
                },
                leadingActions: [
                    .init(icon: "flag.fill", color: .orange) { },
                    .init(icon: "bell.fill", color: .purple) { }
                ],
                trailingActions: [
                    .init(icon: "archivebox.fill", color: .blue) { },
                    .init(icon: "trash.fill", color: .red) { }
                ]
            )
            
            Text("← Swipe right for flag/notify • Swipe left for archive/delete →")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.5))
                .frame(maxWidth: .infinity)
        }
    }
    
    private var codeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Implementation")
                .font(.headline)
                .foregroundStyle(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                Text(codeExample)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(.green)
                    .padding()
            }
            .background(Color.black.opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    // MARK: - Helpers
    
    private var filteredItems: [GlassListItem] {
        if searchText.isEmpty {
            return GlassListItem.sampleItems
        }
        return GlassListItem.sampleItems.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.subtitle.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private func toggleContactSelection(_ contact: ContactItem) {
        if selectedContacts.contains(contact.id) {
            selectedContacts.remove(contact.id)
        } else {
            selectedContacts.insert(contact.id)
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 0.12, green: 0.12, blue: 0.18),
                Color(red: 0.08, green: 0.1, blue: 0.2)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
    
    private var codeExample: String {
        """
        // Glass list row
        GlassListRow(item: item) {
            // Handle tap
        }
        
        // Contact row with selection
        GlassContactRow(
            contact: contact,
            isSelected: isSelected
        ) {
            toggleSelection()
        }
        
        // Swipeable row
        SwipeableGlassRow(
            content: { rowContent },
            leadingActions: [.init(icon: "flag", color: .orange) { }],
            trailingActions: [.init(icon: "trash", color: .red) { }]
        )
        """
    }
}

// MARK: - Supporting Row Views

struct GroupedListRow: View {
    let item: GlassListItem
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: item.icon)
                .font(.title3)
                .foregroundStyle(item.iconColor)
                .frame(width: 28)
            
            Text(item.title)
                .foregroundStyle(.white)
            
            Spacer()
            
            if let badge = item.badge {
                Text("\(badge)")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.6))
            }
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.3))
        }
        .padding()
    }
}

struct InsetListRow: View {
    let item: GlassListItem
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(item.iconColor.opacity(0.2))
                    .frame(width: 44, height: 44)
                
                Image(systemName: item.icon)
                    .foregroundStyle(item.iconColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.body)
                    .foregroundStyle(.white)
                
                Text(item.subtitle)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
            }
            
            Spacer()
            
            if let badge = item.badge {
                Text("\(badge)")
                    .font(.caption.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(item.iconColor)
                    )
            }
        }
        .padding()
    }
}

// MARK: - Preview

#Preview("Glass List Demo") {
    NavigationStack {
        GlassListDemo()
    }
}
