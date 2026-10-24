import SwiftUI
import Combine
import PInject

public struct RegisteredTypeStatus: Identifiable {
    public let id = UUID()
    public let displayName: String
    public let scopeDescription: String
    public let isCurrentlyRegistered: Bool
}

/// ViewModel for live inspection and manipulation of `PIContainer.shared`.
@MainActor
public final class ContainerInspectorViewModel: ObservableObject {
    @Inject private var analytics: any AnalyticsServiceProtocol

    @Published public var statuses: [RegisteredTypeStatus] = []
    @Published public var isUsingMockAuth: Bool = false
    @Published public var notificationMessage: String?

    public init() {
        refresh()
    }

    public func refresh() {
        let container = PIContainer.shared
        statuses = [
            RegisteredTypeStatus(
                displayName: "(any AuthServiceProtocol).self",
                scopeDescription: "Singleton (Protocol)",
                isCurrentlyRegistered: container.isRegistered((any AuthServiceProtocol).self)
            ),
            RegisteredTypeStatus(
                displayName: "ConsoleAnalyticsService.self",
                scopeDescription: "Singleton (Concrete)",
                isCurrentlyRegistered: container.isRegistered(ConsoleAnalyticsService.self)
            ),
            RegisteredTypeStatus(
                displayName: "(any AnalyticsServiceProtocol).self",
                scopeDescription: "Singleton (Protocol)",
                isCurrentlyRegistered: container.isRegistered((any AnalyticsServiceProtocol).self)
            ),
            RegisteredTypeStatus(
                displayName: "SessionReportGenerator.self",
                scopeDescription: "Transient (Factory)",
                isCurrentlyRegistered: container.isRegistered(SessionReportGenerator.self)
            )
        ]
    }

    public func toggleAuthServiceMock() {
        isUsingMockAuth.toggle()
        AppDependencies.useMockAuthService(isUsingMockAuth)
        refresh()

        let name = isUsingMockAuth ? "MockAuthService" : "DefaultAuthService"
        notificationMessage = "Switched to \(name)"
        analytics.track(event: "di_service_swapped", parameters: ["target": name])
    }

    public func resetContainer() {
        PIContainer.shared.reset()
        refresh()
        notificationMessage = "PIContainer.shared.reset() called. Container is empty."
    }

    public func rebindAllDependencies() {
        AppDependencies.setup()
        isUsingMockAuth = false
        refresh()
        notificationMessage = "AppDependencies.setup() completed."
        analytics.track(event: "di_container_reinitialized", parameters: [:])
    }
}
