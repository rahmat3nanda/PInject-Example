import Foundation
import Combine

/// In-memory and console-based analytics tracker.
@MainActor
public final class ConsoleAnalyticsService: AnalyticsServiceProtocol, ObservableObject {
    @Published public private(set) var events: [AnalyticsEvent] = []

    public init() {}

    public func track(event: String, parameters: [String: String] = [:]) {
        let entry = AnalyticsEvent(name: event, parameters: parameters)
        events.insert(entry, at: 0)
        #if DEBUG
        print("📊 [Analytics] \(event) -> \(parameters)")
        #endif
    }

    public func clearEvents() {
        events.removeAll()
    }
}
