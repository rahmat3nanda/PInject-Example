import Foundation

/// Protocol defining authentication services for the application.
@MainActor
public protocol AuthServiceProtocol: AnyObject {
    var currentUser: UserProfile? { get }
    var isAuthenticated: Bool { get }
    func login(email: String) async throws
    func logout()
}
