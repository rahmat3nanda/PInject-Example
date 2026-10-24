import Foundation

/// Demonstrates Transient Scope (Factory registration in `PIContainer`).
/// A brand new instance is instantiated upon each resolution, with its own unique identifier and state.
@MainActor
public final class SessionReportGenerator: Identifiable {
    public let id: UUID
    public let createdAt: Date
    public private(set) var operationCount: Int = 0

    public init() {
        self.id = UUID()
        self.createdAt = Date()
    }

    public func performWork() -> String {
        operationCount += 1
        return "Operation #\(operationCount) executed on instance \(id.uuidString.prefix(6))"
    }
}
