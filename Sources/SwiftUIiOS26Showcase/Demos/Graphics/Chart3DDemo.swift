import Charts
import SwiftUI

struct Chart3DDemo: View {
    @State private var function: SurfaceFunction = .ripple
    @State private var pose: Chart3DPose = .default
    @State private var colorsByHeight = true

    var body: some View {
        DemoPage(demo: .chart3D) {
            DemoSection(title: "Surface") {
                Picker("Function", selection: $function) {
                    ForEach(SurfaceFunction.allCases) { Text($0.title).tag($0) }
                }
                .pickerStyle(.segmented)

                chart
                    .frame(height: 340)

                Toggle("Color by height", isOn: $colorsByHeight)
                HStack {
                    Button("Front") { withAnimation { pose = .front } }
                    Button("Default") { withAnimation { pose = .default } }
                }
                .buttonStyle(.glass)
                Text("Drag the chart to rotate it.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var chart: some View {
        let function = function
        let domain = SurfaceFunction.domain
        return Chart3D {
            SurfacePlot(x: "x", y: "height", z: "z") { x, z in
                function.height(x: x, z: z)
            }
            .foregroundStyle(colorsByHeight ? .heightBased : .normalBased)
        }
        .chartXScale(domain: domain)
        .chartYScale(domain: -1.0...1.0)
        .chartZScale(domain: domain)
        .chart3DPose($pose)
    }
}

#Preview {
    NavigationStack { Chart3DDemo() }
}
