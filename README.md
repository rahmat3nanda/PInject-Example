# PInject-Example

An interactive showcase application demonstrating the features, patterns, and best practices of [**PInject**](https://github.com/rahmat3nanda/PInject) — a lightweight, thread-safe dependency injection framework for Swift & SwiftUI.

---

## Features Demonstrated

1. **Protocol-based Singleton Injection (`@Inject`)**
   - Injects `AuthServiceProtocol` into `AuthViewModel` using the `@Inject` property wrapper.
   - Demonstrates separation of concerns between business logic and UI.

2. **Transient / Factory Scope (`PIContainer.register(_:factory:)`)**
   - Demonstrates factory registration where a fresh instance of `SessionReportGenerator` is instantiated per resolution.
   - Shows independent isolated state and counters across resolved instances.

3. **Singleton State Preservation**
   - Demonstrates a shared `AnalyticsServiceProtocol` singleton tracking actions across multiple screens and ViewModels.

4. **Dynamic Runtime Dependency Swapping**
   - Demonstrates live swapping between `DefaultAuthService` (simulated network latency) and `MockAuthService` (instant test double) directly inside the app without relaunching.

5. **Container Live Inspection & Management**
   - Interactive console inspecting registered types in `PIContainer.shared` via `isRegistered(_:)`.
   - Testing `reset()` and re-binding dependencies dynamically.

---

## Architecture & Project Structure

```
PInject-Example/
├── AppDependencies.swift           # Centralized dependency bootstrapper for PIContainer.shared
├── PInject_ExampleApp.swift        # App entry point initializing AppDependencies.setup()
├── Models/
│   ├── UserProfile.swift           # Domain user entity
│   └── AnalyticsEvent.swift        # Domain analytics event entity
├── Services/
│   ├── AuthServiceProtocol.swift   # Authentication service abstraction
│   ├── DefaultAuthService.swift    # Production implementation
│   ├── MockAuthService.swift       # Mock test double
│   ├── AnalyticsServiceProtocol.swift # Analytics tracking abstraction
│   ├── ConsoleAnalyticsService.swift  # In-memory & console analytics implementation
│   └── SessionReportGenerator.swift   # Transient factory object
├── ViewModels/
│   ├── AuthViewModel.swift         # ViewModel using @Inject for auth & analytics
│   ├── TransientDemoViewModel.swift# ViewModel handling transient factory resolutions
│   └── ContainerInspectorViewModel.swift # ViewModel managing container inspection & swapping
└── Views/
    ├── ContentView.swift           # TabView navigation container
    ├── AuthDemoView.swift          # Protocol injection UI
    ├── TransientDemoView.swift     # Factory transient resolution UI
    ├── AnalyticsLogsView.swift     # Live analytics stream UI
    ├── ContainerInspectorView.swift# Container inspection & live swapping UI
    ├── DependencyBadge.swift       # Visual indicator badge
    └── Color+Extensions.swift      # Cross-platform adaptive color helpers
```

---

## Quick Code Examples

### 1. Bootstrapping Dependencies

```swift
import PInject

@MainActor
public enum AppDependencies {
    public static func setup() {
        let container = PIContainer.shared

        // Singleton by protocol
        container.register((any AuthServiceProtocol).self, dependency: DefaultAuthService())

        // Singleton concrete & protocol
        let analytics = ConsoleAnalyticsService()
        container.register(ConsoleAnalyticsService.self, dependency: analytics)
        container.register((any AnalyticsServiceProtocol).self, dependency: analytics)

        // Transient factory
        container.register(SessionReportGenerator.self) {
            SessionReportGenerator()
        }
    }
}
```

### 2. Injecting into ViewModels

```swift
import SwiftUI
import PInject

@MainActor
final class AuthViewModel: ObservableObject {
    @Inject private var authService: any AuthServiceProtocol
    @Inject private var analytics: any AnalyticsServiceProtocol

    func login() async {
        try? await authService.login(email: "user@example.com")
        analytics.track(event: "login_success")
    }
}
```

---

## Requirements & Platforms

- **iOS**: 16.0+
- **macOS**: 13.0+
- **Xcode**: 15.0+ / 16.0+
- **Swift**: 5.9+ (Swift 6 compatible)

---

## License

MIT License. See [LICENSE](LICENSE) for details.
