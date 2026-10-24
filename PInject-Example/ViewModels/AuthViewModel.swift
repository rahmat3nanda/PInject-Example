import SwiftUI
import Combine
import PInject

/// ViewModel demonstrating `@Inject` with a protocol dependency (`any AuthServiceProtocol`).
@MainActor
public final class AuthViewModel: ObservableObject {
    @Inject private var authService: any AuthServiceProtocol
    @Inject private var analytics: any AnalyticsServiceProtocol

    @Published public var emailInput: String = "rahmat@example.com"
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?

    public init() {}

    public var currentUser: UserProfile? {
        authService.currentUser
    }

    public var isAuthenticated: Bool {
        authService.isAuthenticated
    }

    public var serviceImplementationName: String {
        String(describing: type(of: authService))
    }

    public func login() async {
        let trimmed = emailInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            errorMessage = "Please enter an email address."
            return
        }

        isLoading = true
        errorMessage = nil

        analytics.track(event: "login_initiated", parameters: ["email": trimmed])

        do {
            try await authService.login(email: trimmed)
            analytics.track(event: "login_completed", parameters: [
                "userId": authService.currentUser?.id ?? "unknown",
                "service": serviceImplementationName
            ])
        } catch {
            errorMessage = error.localizedDescription
            analytics.track(event: "login_failed", parameters: ["error": error.localizedDescription])
        }

        isLoading = false
    }

    public func logout() {
        analytics.track(event: "logout_performed", parameters: ["service": serviceImplementationName])
        authService.logout()
    }
}
