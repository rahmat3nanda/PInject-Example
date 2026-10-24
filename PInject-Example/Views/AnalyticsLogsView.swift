import SwiftUI
import PInject

public struct AnalyticsLogsView: View {
    @Inject private var analytics: any AnalyticsServiceProtocol
    @State private var events: [AnalyticsEvent] = []

    public init() {}

    private func reload() {
        events = analytics.events
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "chart.xyaxis.line")
                            .font(.title2)
                            .foregroundColor(.green)
                        Text("Analytics Activity Log")
                            .font(.title3.bold())
                    }

                    Text("All view models record events into `(any AnalyticsServiceProtocol).self`. Because it's a Singleton, state is preserved across screens.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    HStack {
                        DependencyBadge("Scope: Singleton", color: .green)
                        DependencyBadge("Total Events: \(events.count)", color: .blue)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.cardBackground)
                .cornerRadius(12)

                // Actions
                HStack {
                    Button(action: reload) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Refresh")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }

                    Button {
                        analytics.clearEvents()
                        reload()
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Clear")
                        }
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .foregroundColor(.red)
                        .cornerRadius(10)
                    }
                }

                if events.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "list.bullet.rectangle")
                            .font(.system(size: 44))
                            .foregroundColor(.secondary)
                        Text("No analytics events yet.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("Perform actions in the Auth or Transient tabs to trigger events.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                } else {
                    LazyVStack(spacing: 10) {
                        ForEach(events) { event in
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(event.name)
                                        .font(.headline)
                                    Spacer()
                                    Text(event.timestamp, style: .time)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }

                                if !event.parameters.isEmpty {
                                    Text(event.parameters.map { "\($0.key): \($0.value)" }.joined(separator: " • "))
                                        .font(.caption.monospaced())
                                        .foregroundColor(.secondary)
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
        .onAppear(perform: reload)
        .navigationTitle("Analytics Log")
    }
}
