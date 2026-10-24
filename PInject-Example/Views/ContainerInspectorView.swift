import SwiftUI
import PInject

public struct ContainerInspectorView: View {
    @StateObject private var viewModel = ContainerInspectorViewModel()

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "slider.horizontal.3")
                            .font(.title2)
                            .foregroundColor(.blue)
                        Text("DI Container Console")
                            .font(.title3.bold())
                    }

                    Text("Directly inspect, toggle, unregister, or reset dependencies in `PIContainer.shared` in real-time.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.cardBackground)
                .cornerRadius(12)

                if let message = viewModel.notificationMessage {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.blue)
                        Text(message)
                            .font(.subheadline)
                        Spacer()
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                }

                // Registry Status Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Registered Types in Container")
                        .font(.headline)

                    ForEach(viewModel.statuses) { status in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(status.displayName)
                                    .font(.subheadline.monospaced())
                                Text(status.scopeDescription)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            if status.isCurrentlyRegistered {
                                DependencyBadge("Registered", color: .green)
                            } else {
                                DependencyBadge("Not Registered", color: .red)
                            }
                        }
                        .padding()
                        .background(Color.cardBackground)
                        .cornerRadius(10)
                    }
                }

                // Dynamic Swapping Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Dynamic Dependency Swapping")
                        .font(.headline)

                    Text("Swap between DefaultAuthService (production simulation) and MockAuthService (instant mock) without restarting the app.")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Button(action: viewModel.toggleAuthServiceMock) {
                        HStack {
                            Image(systemName: viewModel.isUsingMockAuth ? "checkmark.circle.fill" : "circle")
                            Text(viewModel.isUsingMockAuth ? "Using MockAuthService (Tap to use Default)" : "Using DefaultAuthService (Tap to use Mock)")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.isUsingMockAuth ? Color.purple : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color.cardBackground)
                .cornerRadius(12)

                // Dangerous Operations Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Container Management")
                        .font(.headline)

                    HStack(spacing: 12) {
                        Button(role: .destructive, action: viewModel.resetContainer) {
                            HStack {
                                Image(systemName: "exclamationmark.triangle")
                                Text("Reset Container")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .foregroundColor(.red)
                            .cornerRadius(10)
                        }

                        Button(action: viewModel.rebindAllDependencies) {
                            HStack {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                Text("Re-bind All")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                }
                .padding()
                .background(Color.cardBackground)
                .cornerRadius(12)
            }
            .padding()
        }
        .onAppear(perform: viewModel.refresh)
        .navigationTitle("Container Console")
    }
}
