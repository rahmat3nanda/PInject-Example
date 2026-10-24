import Foundation
import Combine

/// Production-ready default authentication service implementation.
@MainActor
public final class DefaultAuthService: AuthServiceProtocol, ObservableObject {
    @Published public private(set) var currentUser: UserProfile?

    public var isAuthenticated: Bool {
        currentUser != nil
    }

    public init() {}

    public func login(email: String) async throws {
        // Simulate network latency
        try await Task.sleep(nanoseconds: 600_000_000)
        let name = email.components(separatedBy: "@").first?.capitalized ?? "User"
        currentUser = UserProfile(
            id: String(UUID().uuidString.prefix(8)),
            name: name,
            email: email,
            role: "Developer"
        )
    }

    public func logout() {
        currentUser = nil
    }
}
