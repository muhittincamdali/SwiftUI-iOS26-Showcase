import SwiftUI

struct NavigationSubtitleDemo: View {
    private struct Message: Identifiable {
        let id: Int
        let sender: String
        var isUnread: Bool
    }

    @State private var messages = [
        Message(id: 1, sender: "Design Review", isUnread: true),
        Message(id: 2, sender: "Release Notes", isUnread: true),
        Message(id: 3, sender: "Build Server", isUnread: false),
        Message(id: 4, sender: "Weekly Sync", isUnread: true),
        Message(id: 5, sender: "App Review", isUnread: false)
    ]

    private var unreadCount: Int {
        messages.count(where: \.isUnread)
    }

    private var subtitle: String {
        unreadCount == 0 ? "All caught up" : "\(unreadCount) unread"
    }

    var body: some View {
        List {
            Section {
                ForEach($messages) { $message in
                    Toggle(isOn: $message.isUnread) {
                        Label(message.sender, systemImage: message.isUnread ? "envelope.badge" : "envelope.open")
                    }
                }
            } footer: {
                Text("Toggle messages to update the subtitle under the navigation title.")
            }
            Section {
                APIList(demo: .navigationSubtitle)
            }
        }
        .navigationSubtitle(subtitle)
    }
}

#Preview {
    NavigationStack {
        NavigationSubtitleDemo()
            .navigationTitle("Inbox")
    }
}
