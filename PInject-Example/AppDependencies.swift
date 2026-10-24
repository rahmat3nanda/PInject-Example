import Foundation
import PInject

/// Central registry bootstrapper configuring `PIContainer.shared` for the application.
@MainActor
public enum AppDependencies {

    /// Registers all application dependencies in the shared container.
    public static func setup() {
        let container = PIContainer.shared

        // 1. Singleton Protocol Registration
        container.register(
            (any AuthServiceProtocol).self,
            dependency: DefaultAuthService()
        )

        // 2. Concrete Singleton Registration
        let analytics = ConsoleAnalyticsService()
        container.register(
            ConsoleAnalyticsService.self,
            dependency: analytics
        )

        // Also expose via protocol interface
        container.register(
            (any AnalyticsServiceProtocol).self,
            dependency: analytics
        )

        // 3. Transient Scope (Factory) Registration
        // Produces a fresh instance upon every resolution call
        container.register(SessionReportGenerator.self) {
            SessionReportGenerator()
        }
    }

    /// Dynamically swaps between Default and Mock AuthService at runtime.
    public static func useMockAuthService(_ useMock: Bool) {
        let container = PIContainer.shared
        if useMock {
            container.register(
                (any AuthServiceProtocol).self,
                dependency: MockAuthService()
            )
        } else {
            container.register(
                (any AuthServiceProtocol).self,
                dependency: DefaultAuthService()
            )
        }
    }
}
