import Foundation

/// Height functions plotted by the 3D chart demo.
///
/// Every function maps the square `domain` x `domain` to heights in `-1...1`.
public enum SurfaceFunction: String, CaseIterable, Identifiable, Sendable {
    /// Concentric waves that fade out from the center.
    case ripple
    /// A hyperbolic paraboloid ("Pringle") shape.
    case saddle
    /// A smooth single peak at the origin.
    case peak

    public static let domain: ClosedRange<Double> = -3...3

    public var id: Self { self }

    public var title: String { rawValue.capitalized }

    public func height(x: Double, z: Double) -> Double {
        switch self {
        case .ripple:
            let radius = (x * x + z * z).squareRoot()
            return cos(radius * 2) * exp(-radius / 3)
        case .saddle:
            // x² - z² reaches ±9 at the edges of the domain; scale it into -1...1.
            let limit = Self.domain.upperBound * Self.domain.upperBound
            return (x * x - z * z) / limit
        case .peak:
            return exp(-(x * x + z * z) / 2)
        }
    }
}
