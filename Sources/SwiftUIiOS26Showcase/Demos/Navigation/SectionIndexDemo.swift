#if os(iOS)
import SwiftUI

struct SectionIndexDemo: View {
    private static let names = [
        "Ada", "Alan", "Barbara", "Bjarne", "Brian", "Charles", "Chris", "Dennis", "Donald",
        "Edsger", "Frances", "Grace", "Guido", "Hedy", "Ivan", "James", "John", "Ken",
        "Linus", "Margaret", "Niklaus", "Radia", "Richard", "Steve", "Tim", "Yukihiro"
    ]

    /// Names grouped by their first letter, in alphabetical order.
    private static let sections: [(letter: String, names: [String])] = Dictionary(
        grouping: names, by: { String($0.prefix(1)) }
    )
    .sorted { $0.key < $1.key }
    .map { (letter: $0.key, names: $0.value.sorted()) }

    @State private var indexVisibility: Visibility = .visible

    var body: some View {
        List {
            Section {
                Picker("Section index", selection: $indexVisibility) {
                    Text("Automatic").tag(Visibility.automatic)
                    Text("Visible").tag(Visibility.visible)
                    Text("Hidden").tag(Visibility.hidden)
                }
                .pickerStyle(.segmented)
            }
            ForEach(Self.sections, id: \.letter) { section in
                Section(section.letter) {
                    ForEach(section.names, id: \.self) { name in
                        Label(name, systemImage: "person.crop.circle")
                    }
                }
                .sectionIndexLabel(section.letter)
            }
            Section {
                APIList(demo: .sectionIndex)
            }
        }
        .listSectionIndexVisibility(indexVisibility)
    }
}

#Preview {
    NavigationStack { SectionIndexDemo() }
}
#endif
