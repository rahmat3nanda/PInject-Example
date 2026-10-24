import Foundation
import Combine

/// Mock implementation of `AuthServiceProtocol` useful for tests, previews, and debug toggling.
@MainActor
public final class MockAuthService: AuthServiceProtocol, ObservableObject {
    @Published public private(set) var currentUser: UserProfile? = UserProfile.sample

    public var isAuthenticated: Bool {
        currentUser != nil
    }

    public init() {}

    public func login(email: String) async throws {
        currentUser = UserProfile(
            id: "MOCK-999",
            name: "Mocked User (\(email))",
            email: email,
            role: "Mock Tester"
        )
    }

    public func logout() {
        currentUser = nil
    }
}
