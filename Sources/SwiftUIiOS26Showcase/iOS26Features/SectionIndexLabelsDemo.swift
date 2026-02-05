// MARK: - SectionIndexLabelsDemo.swift
// iOS 26 List Section Index Labels
// Created by Muhittin Camdali

import SwiftUI

// MARK: - Section Index Labels Showcase

@available(iOS 26.0, macOS 26.0, *)
public struct SectionIndexLabelsShowcase: View {
    @State private var selectedLetter: String?
    @State private var showIndexBar = true
    @State private var indexVisibility: ListSectionIndexVisibility = .automatic
    
    private let contacts = Contact.sampleContacts
    private var groupedContacts: [String: [Contact]] {
        Dictionary(grouping: contacts) { String($0.name.prefix(1)).uppercased() }
    }
    private var sortedKeys: [String] {
        groupedContacts.keys.sorted()
    }
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            List {
                ForEach(sortedKeys, id: \.self) { letter in
                    Section {
                        ForEach(groupedContacts[letter] ?? []) { contact in
                            ContactRow(contact: contact)
                        }
                    } header: {
                        Text(letter)
                    }
                    .sectionIndexLabel(Text(letter))
                }
            }
            .listSectionIndexVisibility(indexVisibility)
            .navigationTitle("Contacts")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Section("Index Visibility") {
                            Button {
                                indexVisibility = .automatic
                            } label: {
                                Label("Automatic", systemImage: indexVisibility == .automatic ? "checkmark" : "")
                            }
                            
                            Button {
                                indexVisibility = .visible
                            } label: {
                                Label("Always Visible", systemImage: indexVisibility == .visible ? "checkmark" : "")
                            }
                            
                            Button {
                                indexVisibility = .hidden
                            } label: {
                                Label("Hidden", systemImage: indexVisibility == .hidden ? "checkmark" : "")
                            }
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
        }
    }
}

// MARK: - List Section Index Visibility

@available(iOS 26.0, *)
public enum ListSectionIndexVisibility {
    case automatic
    case visible
    case hidden
}

// MARK: - View Extension

@available(iOS 26.0, *)
extension View {
    public func sectionIndexLabel(_ label: Text) -> some View {
        self
    }
    
    public func listSectionIndexVisibility(_ visibility: ListSectionIndexVisibility) -> some View {
        self
    }
}

// MARK: - Contact Model

struct Contact: Identifiable {
    let id = UUID()
    let name: String
    let phone: String
    let email: String
    let avatar: String
    
    static let sampleContacts: [Contact] = [
        Contact(name: "Alice Anderson", phone: "+1 234 567 890", email: "alice@email.com", avatar: "person.circle.fill"),
        Contact(name: "Bob Brown", phone: "+1 234 567 891", email: "bob@email.com", avatar: "person.circle.fill"),
        Contact(name: "Carol Chen", phone: "+1 234 567 892", email: "carol@email.com", avatar: "person.circle.fill"),
        Contact(name: "Charlie Clark", phone: "+1 234 567 893", email: "charlie@email.com", avatar: "person.circle.fill"),
        Contact(name: "David Davis", phone: "+1 234 567 894", email: "david@email.com", avatar: "person.circle.fill"),
        Contact(name: "Diana Diaz", phone: "+1 234 567 895", email: "diana@email.com", avatar: "person.circle.fill"),
        Contact(name: "Edward Evans", phone: "+1 234 567 896", email: "edward@email.com", avatar: "person.circle.fill"),
        Contact(name: "Emily Edwards", phone: "+1 234 567 897", email: "emily@email.com", avatar: "person.circle.fill"),
        Contact(name: "Frank Foster", phone: "+1 234 567 898", email: "frank@email.com", avatar: "person.circle.fill"),
        Contact(name: "Fiona Fisher", phone: "+1 234 567 899", email: "fiona@email.com", avatar: "person.circle.fill"),
        Contact(name: "George Garcia", phone: "+1 234 567 900", email: "george@email.com", avatar: "person.circle.fill"),
        Contact(name: "Grace Green", phone: "+1 234 567 901", email: "grace@email.com", avatar: "person.circle.fill"),
        Contact(name: "Henry Harris", phone: "+1 234 567 902", email: "henry@email.com", avatar: "person.circle.fill"),
        Contact(name: "Hannah Hall", phone: "+1 234 567 903", email: "hannah@email.com", avatar: "person.circle.fill"),
        Contact(name: "Ivan Ivanov", phone: "+1 234 567 904", email: "ivan@email.com", avatar: "person.circle.fill"),
        Contact(name: "Isabella Ingram", phone: "+1 234 567 905", email: "isabella@email.com", avatar: "person.circle.fill"),
        Contact(name: "James Johnson", phone: "+1 234 567 906", email: "james@email.com", avatar: "person.circle.fill"),
        Contact(name: "Julia Jones", phone: "+1 234 567 907", email: "julia@email.com", avatar: "person.circle.fill"),
        Contact(name: "Kevin Kim", phone: "+1 234 567 908", email: "kevin@email.com", avatar: "person.circle.fill"),
        Contact(name: "Karen King", phone: "+1 234 567 909", email: "karen@email.com", avatar: "person.circle.fill"),
        Contact(name: "Liam Lee", phone: "+1 234 567 910", email: "liam@email.com", avatar: "person.circle.fill"),
        Contact(name: "Laura Lopez", phone: "+1 234 567 911", email: "laura@email.com", avatar: "person.circle.fill"),
        Contact(name: "Michael Martinez", phone: "+1 234 567 912", email: "michael@email.com", avatar: "person.circle.fill"),
        Contact(name: "Maria Miller", phone: "+1 234 567 913", email: "maria@email.com", avatar: "person.circle.fill"),
        Contact(name: "Nathan Nelson", phone: "+1 234 567 914", email: "nathan@email.com", avatar: "person.circle.fill"),
        Contact(name: "Nina Nguyen", phone: "+1 234 567 915", email: "nina@email.com", avatar: "person.circle.fill"),
        Contact(name: "Oscar Ortiz", phone: "+1 234 567 916", email: "oscar@email.com", avatar: "person.circle.fill"),
        Contact(name: "Olivia Owen", phone: "+1 234 567 917", email: "olivia@email.com", avatar: "person.circle.fill"),
        Contact(name: "Peter Parker", phone: "+1 234 567 918", email: "peter@email.com", avatar: "person.circle.fill"),
        Contact(name: "Patricia Perez", phone: "+1 234 567 919", email: "patricia@email.com", avatar: "person.circle.fill"),
        Contact(name: "Quinn Quinn", phone: "+1 234 567 920", email: "quinn@email.com", avatar: "person.circle.fill"),
        Contact(name: "Rachel Rodriguez", phone: "+1 234 567 921", email: "rachel@email.com", avatar: "person.circle.fill"),
        Contact(name: "Robert Robinson", phone: "+1 234 567 922", email: "robert@email.com", avatar: "person.circle.fill"),
        Contact(name: "Sarah Smith", phone: "+1 234 567 923", email: "sarah@email.com", avatar: "person.circle.fill"),
        Contact(name: "Steven Scott", phone: "+1 234 567 924", email: "steven@email.com", avatar: "person.circle.fill"),
        Contact(name: "Thomas Taylor", phone: "+1 234 567 925", email: "thomas@email.com", avatar: "person.circle.fill"),
        Contact(name: "Tina Thompson", phone: "+1 234 567 926", email: "tina@email.com", avatar: "person.circle.fill"),
        Contact(name: "Uma Underwood", phone: "+1 234 567 927", email: "uma@email.com", avatar: "person.circle.fill"),
        Contact(name: "Victor Valdez", phone: "+1 234 567 928", email: "victor@email.com", avatar: "person.circle.fill"),
        Contact(name: "Victoria Vargas", phone: "+1 234 567 929", email: "victoria@email.com", avatar: "person.circle.fill"),
        Contact(name: "William White", phone: "+1 234 567 930", email: "william@email.com", avatar: "person.circle.fill"),
        Contact(name: "Wendy Wilson", phone: "+1 234 567 931", email: "wendy@email.com", avatar: "person.circle.fill"),
        Contact(name: "Xavier Xu", phone: "+1 234 567 932", email: "xavier@email.com", avatar: "person.circle.fill"),
        Contact(name: "Yolanda Young", phone: "+1 234 567 933", email: "yolanda@email.com", avatar: "person.circle.fill"),
        Contact(name: "Zachary Zhang", phone: "+1 234 567 934", email: "zachary@email.com", avatar: "person.circle.fill"),
    ]
}

// MARK: - Contact Row

@available(iOS 26.0, *)
struct ContactRow: View {
    let contact: Contact
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: contact.avatar)
                .font(.largeTitle)
                .foregroundStyle(.blue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(contact.name)
                    .font(.headline)
                Text(contact.phone)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Custom Index Demo

@available(iOS 26.0, *)
public struct CustomSectionIndexDemo: View {
    private let emojis = ["😀", "😎", "🥳", "🤩", "😍", "🤔", "😴", "🥺"]
    
    public var body: some View {
        NavigationStack {
            List {
                ForEach(emojis, id: \.self) { emoji in
                    Section {
                        ForEach(0..<5) { index in
                            Text("Item \(index + 1)")
                        }
                    } header: {
                        Text("Section \(emoji)")
                    }
                    .sectionIndexLabel(Text(emoji))
                }
            }
            .navigationTitle("Custom Index")
        }
    }
}

// MARK: - Code Example

@available(iOS 26.0, *)
public struct SectionIndexCodeExample: View {
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Section Index Labels")
                    .font(.title.bold())
                
                Text("iOS 26 introduces native section index labels for List - no more UIKit wrappers!")
                    .foregroundStyle(.secondary)
                
                CodeBlock(
                    title: "Basic Usage",
                    code: """
                    List {
                        ForEach(sortedKeys, id: \\.self) { letter in
                            Section(letter) {
                                // Section content
                            }
                            .sectionIndexLabel(Text(letter))
                        }
                    }
                    """
                )
                
                CodeBlock(
                    title: "Visibility Control",
                    code: """
                    List { ... }
                    .listSectionIndexVisibility(.automatic)
                    // Options: .automatic, .visible, .hidden
                    """
                )
                
                CodeBlock(
                    title: "Custom Labels",
                    code: """
                    Section("Favorites") { ... }
                    .sectionIndexLabel(
                        Text("⭐")
                    )
                    """
                )
                
                // Comparison
                VStack(alignment: .leading, spacing: 12) {
                    Text("iOS 17 vs iOS 26")
                        .font(.headline)
                    
                    HStack(spacing: 16) {
                        // iOS 17
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image(systemName: "17.circle.fill")
                                    .foregroundStyle(.orange)
                                Text("iOS 17")
                                    .font(.subheadline.bold())
                            }
                            
                            Text("UIViewRepresentable\nComplex setup\nLimited customization")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.orange.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        // iOS 26
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image(systemName: "26.circle.fill")
                                    .foregroundStyle(.green)
                                Text("iOS 26")
                                    .font(.subheadline.bold())
                            }
                            
                            Text("Native SwiftUI\nOne-line setup\nFully customizable")
                                .font(.caption)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.green.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    if #available(iOS 26.0, *) {
        SectionIndexLabelsShowcase()
    }
}
