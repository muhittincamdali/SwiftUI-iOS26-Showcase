import SwiftUI

struct BackgroundExtensionDemo: View {
    @State private var isEnabled = true

    var body: some View {
        DemoScrollView {
            VStack(alignment: .leading, spacing: 24) {
                hero
                VStack(alignment: .leading, spacing: 24) {
                    Text(ShowcaseDemo.backgroundExtension.summary)
                        .foregroundStyle(.secondary)
                    Toggle("Background extension effect", isOn: $isEnabled)
                    Text("""
                        With the effect on, the artwork is mirrored and blurred into the area under the \
                        navigation bar, so the image appears to continue behind it instead of ending at a hard edge.
                        """)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    APIList(demo: .backgroundExtension)
                }
                .padding(.horizontal)
            }
        }
        .ignoresSafeArea(edges: .top)
    }

    private var hero: some View {
        ShowcaseBackdrop()
            .frame(height: 320)
            .overlay(alignment: .bottomLeading) {
                Text("Northern Lights")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                    .shadow(radius: 6)
                    .padding()
            }
            .backgroundExtensionEffect(isEnabled: isEnabled)
    }
}

#Preview {
    NavigationStack { BackgroundExtensionDemo() }
}
