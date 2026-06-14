import Foundation

/// A high-performance, actor-isolated metric collector.
public actor SwiftUIiOS26ShowcaseMetricsCollector {
    public static let shared = SwiftUIiOS26ShowcaseMetricsCollector()
    private var metrics: [String: Double] = [:]
    
    public init() {}
    
    public func record(metric: String, value: Double) {
        metrics[metric, default: 0] += value
    }
    
    public func flush() -> [String: Double] {
        let current = metrics
        metrics.removeAll()
        return current
    }
}
