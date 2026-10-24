import SwiftUI

public struct AuthDemoView: View {
    @StateObject private var viewModel = AuthViewModel()

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header info
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "lock.shield.fill")
                            .font(.title2)
                            .foregroundColor(.indigo)
                        Text("Protocol Injection (@Inject)")
                            .font(.title3.bold())
                    }

                    Text("Resolves `(any AuthServiceProtocol).self` as a Singleton registered in `PIContainer.shared`.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    HStack {
                        DependencyBadge("Scope: Singleton", color: .purple)
                        DependencyBadge("Active: \(viewModel.serviceImplementationName)", color: .blue)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.cardBackground)
                .cornerRadius(12)

                // Current Session Card
                if viewModel.isAuthenticated, let user = viewModel.currentUser {
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 48, height: 48)
                                .foregroundColor(.indigo)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.name)
                                    .font(.headline)
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            DependencyBadge(user.role, color: .green)
                        }

                        Divider()

                        HStack {
                            Text("User ID: \(user.id)")
                                .font(.caption.monospaced())
                                .foregroundColor(.secondary)
                            Spacer()
                        }

                        Button(role: .destructive, action: viewModel.logout) {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("Log Out")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .foregroundColor(.red)
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color.cardBackground)
                    .cornerRadius(12)
                } else {
                    // Login Card
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Sign In with Injected Service")
                            .font(.headline)

                        TextField("Email Address", text: $viewModel.emailInput)
                            .textFieldStyle(.roundedBorder)
                            #if os(iOS)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            #endif

                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }

                        Button {
                            Task {
                                await viewModel.login()
                            }
                        } label: {
                            HStack {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .padding(.trailing, 6)
                                }
                                Text(viewModel.isLoading ? "Authenticating..." : "Sign In")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.indigo)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .disabled(viewModel.isLoading)
                    }
                    .padding()
                    .background(Color.cardBackground)
                    .cornerRadius(12)
                }

                // Code snippet explanation
                VStack(alignment: .leading, spacing: 8) {
                    Text("Code Implementation:")
                        .font(.footnote.bold())
                        .foregroundColor(.secondary)

                    Text("""
                    @MainActor
                    final class AuthViewModel: ObservableObject {
                        @Inject private var authService: any AuthServiceProtocol
                        @Inject private var analytics: any AnalyticsServiceProtocol
                        ...
                    }
                    """)
                    .font(.caption.monospaced())
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.black.opacity(0.85))
                    .foregroundColor(.green)
                    .cornerRadius(8)
                }
            }
            .padding()
        }
        .navigationTitle("Auth Service Demo")
    }
}
