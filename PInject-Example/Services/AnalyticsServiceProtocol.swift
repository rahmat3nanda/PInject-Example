import Foundation

/// Protocol defining analytics event tracking.
@MainActor
public protocol AnalyticsServiceProtocol: AnyObject {
    var events: [AnalyticsEvent] { get }
    func track(event: String, parameters: [String: String])
    func clearEvents()
}
