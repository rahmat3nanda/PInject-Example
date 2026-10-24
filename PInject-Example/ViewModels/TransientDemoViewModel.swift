import SwiftUI
import Combine
import PInject

/// Record representing a created transient instance.
public struct TransientInstanceItem: Identifiable {
    public let id: UUID
    public let label: String
    public let timeFormatted: String
    public var operationsRun: Int
    public let generator: SessionReportGenerator

    public init(generator: SessionReportGenerator) {
        self.id = generator.id
        self.label = String(generator.id.uuidString.prefix(8))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        self.timeFormatted = formatter.string(from: generator.createdAt)
        self.operationsRun = generator.operationCount
        self.generator = generator
    }
}

/// ViewModel demonstrating Transient Factory Scope resolution.
@MainActor
public final class TransientDemoViewModel: ObservableObject {
    @Inject private var analytics: any AnalyticsServiceProtocol

    @Published public var items: [TransientInstanceItem] = []

    public init() {}

    /// Resolves a fresh `SessionReportGenerator` from `PIContainer.shared`.
    public func resolveNewInstance() {
        let generator = PIContainer.shared.resolve(SessionReportGenerator.self)
        let item = TransientInstanceItem(generator: generator)
        items.insert(item, at: 0)

        analytics.track(event: "transient_resolved", parameters: [
            "instanceId": item.label,
            "totalInstances": "\(items.count)"
        ])
    }

    /// Invokes work on a specific transient instance to demonstrate that state is isolated per instance.
    public func runWork(on itemId: UUID) {
        guard let index = items.firstIndex(where: { $0.id == itemId }) else { return }
        let log = items[index].generator.performWork()
        items[index].operationsRun = items[index].generator.operationCount

        analytics.track(event: "transient_work_invoked", parameters: [
            "instanceId": items[index].label,
            "count": "\(items[index].operationsRun)",
            "message": log
        ])
    }

    public func clearAll() {
        items.removeAll()
        analytics.track(event: "transient_cleared", parameters: [:])
    }
}
