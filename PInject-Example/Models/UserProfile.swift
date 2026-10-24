import Foundation

/// Represents an authenticated user profile in the example application.
public struct UserProfile: Equatable, Sendable {
    public let id: String
    public let name: String
    public let email: String
    public let role: String

    public init(id: String, name: String, email: String, role: String) {
        self.id = id
        self.name = name
        self.email = email
        self.role = role
    }

    public static let sample = UserProfile(
        id: "USR-001",
        name: "Rahmat Trinanda",
        email: "rahmat@example.com",
        role: "Senior iOS Engineer"
    )
}
