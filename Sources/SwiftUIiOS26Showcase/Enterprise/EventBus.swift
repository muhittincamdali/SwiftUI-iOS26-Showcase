import Foundation

/// A high-integrity event bus for decoupled communication.
public actor SwiftUIiOS26ShowcaseEventBus {
    public static let shared = SwiftUIiOS26ShowcaseEventBus()
    
    private var listeners: [String: [@Sendable (Any) async -> Void]] = [:]
    
    public init() {}
    
    public func subscribe(to event: String, handler: @escaping @Sendable (Any) async -> Void) {
        listeners[event, default: []].append(handler)
    }
    
    public func publish(event: String, payload: Any) async {
        guard let handlers = listeners[event] else { return }
        for handler in handlers {
            await handler(payload)
        }
    }
}
