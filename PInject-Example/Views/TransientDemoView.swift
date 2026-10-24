import SwiftUI

public struct TransientDemoView: View {
    @StateObject private var viewModel = TransientDemoViewModel()

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header info
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.title2)
                            .foregroundColor(.orange)
                        Text("Transient Scope (Factory)")
                            .font(.title3.bold())
                    }

                    Text("Registered via `container.register(SessionReportGenerator.self) { ... }`. Each resolution instantiates a fresh object with an isolated state and counter.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    HStack {
                        DependencyBadge("Scope: Transient", color: .orange)
                        DependencyBadge("Active Instances: \(viewModel.items.count)", color: .blue)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.cardBackground)
                .cornerRadius(12)

                // Controls
                HStack(spacing: 12) {
                    Button(action: viewModel.resolveNewInstance) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Resolve New Instance")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }

                    if !viewModel.items.isEmpty {
                        Button(action: viewModel.clearAll) {
                            Image(systemName: "trash")
                                .padding()
                                .background(Color.red.opacity(0.1))
                                .foregroundColor(.red)
                                .cornerRadius(10)
                        }
                    }
                }

                // Instance list
                if viewModel.items.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "cube.transparent")
                            .font(.system(size: 44))
                            .foregroundColor(.secondary)
                        Text("No instances created yet.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("Tap 'Resolve New Instance' to instantiate a new transient object.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                } else {
                    VStack(spacing: 12) {
                        ForEach(viewModel.items) { item in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text("Instance #\(item.label)")
                                            .font(.headline.monospaced())
                                        Spacer()
                                        Text(item.timeFormatted)
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }

                                    Text("Executions count: \(item.operationsRun)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }

                                Button {
                                    viewModel.runWork(on: item.id)
                                } label: {
                                    HStack(spacing: 4) {
                                        Image(systemName: "play.fill")
                                        Text("Run")
                                    }
                                    .font(.caption.bold())
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.orange.opacity(0.15))
                                    .foregroundColor(.orange)
                                    .cornerRadius(8)
                                }
                            }
                            .padding()
                            .background(Color.cardBackground)
                            .cornerRadius(10)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Transient Scope Demo")
    }
}
