import CoreGraphics
import Testing
@testable import SwiftUIiOS26Showcase

@Suite("SurfaceFunction")
struct SurfaceFunctionTests {
    private static let gridSteps = 24

    /// Evenly spaced points covering the domain, including both ends.
    private static var grid: [Double] {
        let domain = SurfaceFunction.domain
        let step = (domain.upperBound - domain.lowerBound) / Double(gridSteps)
        return (0...gridSteps).map { domain.lowerBound + Double($0) * step }
    }

    @Test(arguments: SurfaceFunction.allCases)
    func heightsStayInsideTheChartScale(function: SurfaceFunction) {
        for x in Self.grid {
            for z in Self.grid {
                let height = function.height(x: x, z: z)
                #expect((-1.0...1.0).contains(height), "\(function) at (\(x), \(z)) = \(height)")
            }
        }
    }

    @Test func knownValues() {
        #expect(SurfaceFunction.peak.height(x: 0, z: 0) == 1)
        #expect(SurfaceFunction.ripple.height(x: 0, z: 0) == 1)
        #expect(SurfaceFunction.saddle.height(x: 3, z: 0) == 1)
        #expect(SurfaceFunction.saddle.height(x: 0, z: 3) == -1)
        #expect(SurfaceFunction.saddle.height(x: 2, z: 2) == 0)
    }

    @Test func titles() {
        #expect(SurfaceFunction.allCases.map(\.title) == ["Ripple", "Saddle", "Peak"])
    }
}

@Suite("WaveShape")
struct WaveShapeTests {
    private let rect = CGRect(x: 10, y: 20, width: 300, height: 100)

    @Test func pointsSpanTheWidthAndStayInside() {
        let shape = WaveShape(amplitude: 1, frequency: 3, sampleCount: 60)
        let points = shape.points(in: rect)

        #expect(points.count == 61)
        #expect(points.first?.x == rect.minX)
        #expect(points.last?.x == rect.maxX)
        for point in points {
            #expect(point.y >= rect.minY - 0.0001 && point.y <= rect.maxY + 0.0001)
        }
    }

    @Test func zeroAmplitudeIsAFlatLine() {
        let shape = WaveShape(amplitude: 0, frequency: 5, sampleCount: 10)
        #expect(shape.points(in: rect).allSatisfy { $0.y == rect.midY })
    }

    @Test func emptyInputsProduceNoPath() {
        #expect(WaveShape(amplitude: 1, frequency: 1, sampleCount: 0).points(in: rect).isEmpty)
        #expect(WaveShape(amplitude: 1, frequency: 1, sampleCount: 10).points(in: .zero).isEmpty)
        #expect(WaveShape(amplitude: 1, frequency: 1, sampleCount: 0).path(in: rect).isEmpty)
    }

    @Test func animatableDataInterpolatesAmplitudeAndFrequencyOnly() {
        var shape = WaveShape(amplitude: 0.2, frequency: 2, sampleCount: 40)
        let target = WaveShape(amplitude: 0.8, frequency: 6, sampleCount: 100)

        // Halfway between the two values, the way an animation interpolates.
        var difference = target.animatableData
        difference -= shape.animatableData
        difference.scale(by: 0.5)
        shape.animatableData += difference

        #expect(abs(shape.amplitude - 0.5) < 0.0001)
        #expect(abs(shape.frequency - 4) < 0.0001)
        #expect(shape.sampleCount == 40)
    }
}
