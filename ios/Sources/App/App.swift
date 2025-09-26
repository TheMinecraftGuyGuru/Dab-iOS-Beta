#if canImport(SwiftUI)
import SwiftUI

@main
struct DabApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(dependencies: .live)
        }
    }
}

struct ContentView: View {
    @StateObject private var viewModel: AuthViewModel

    init(dependencies: AppDependencies) {
        _viewModel = StateObject(
            wrappedValue: AuthViewModel(
                authService: dependencies.authService,
                tokenStore: dependencies.tokenStore
            )
        )
    }

    var body: some View {
        TabView {
            NavigationStack {
                OnboardingFlowView(viewModel: viewModel)
                    .navigationTitle("Welcome")
            }
            .tabItem {
                Label("Onboarding", systemImage: "person.badge.key")
            }

            NavigationStack {
                ReferenceInstructionsView()
                    .navigationTitle("Reference")
            }
            .tabItem {
                Label("Reference", systemImage: "list.bullet")
            }
        }
    }
}

struct ReferenceInstructionsView: View {
    var body: some View {
        List {
            Section("Getting Started") {
                Label("Compare features with android/", systemImage: "doc.text.magnifyingglass")
                Label("Port assets into Resources/", systemImage: "folder")
                Label("Recreate data flows using Swift Concurrency", systemImage: "bolt.horizontal")
            }

            Section("Authentication Plan") {
                Label("Implement OAuth flows", systemImage: "key.fill")
                Label("Persist tokens in the Keychain", systemImage: "lock.circle")
                Label("Bridge refresh logic to background tasks", systemImage: "arrow.clockwise")
            }

            Section("Next Steps") {
                Label("Define networking layer", systemImage: "network")
                Label("Design reusable SwiftUI components", systemImage: "square.grid.2x2")
                Label("Add unit tests", systemImage: "checkmark.shield")
            }
        }
    }
}

#Preview("App Shell") {
    ContentView(dependencies: .preview)
}
#else
@main
struct DabApp {
    static func main() {
        print("SwiftUI is not supported on this platform.")
    }
}
#endif
