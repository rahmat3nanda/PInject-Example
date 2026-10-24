import Foundation

/// Represents an analytics event captured by an AnalyticsService.
public struct AnalyticsEvent: Identifiable, Sendable {
    public let id: UUID
    public let name: String
    public let timestamp: Date
    public let parameters: [String: String]

    public init(name: String, parameters: [String: String] = [:]) {
        self.id = UUID()
        self.name = name
        self.timestamp = Date()
        self.parameters = parameters
    }
}
