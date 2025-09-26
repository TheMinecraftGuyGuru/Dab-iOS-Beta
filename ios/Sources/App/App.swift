import SwiftUI

@main
struct DabApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "sparkles")
                    .font(.system(size: 48))
                    .foregroundStyle(.tint)

                Text("Welcome to Dab iOS")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("This is the native SwiftUI rewrite. Use the Android Flutter project in ../android as a reference for flows, assets, and API interactions.")
                    .multilineTextAlignment(.center)
                    .font(.body)
                    .foregroundStyle(.secondary)

                NavigationLink("Review Android Reference") {
                    ReferenceInstructionsView()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("Dab Preview")
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

            Section("Next Steps") {
                Label("Define networking layer", systemImage: "network")
                Label("Design reusable SwiftUI components", systemImage: "square.grid.2x2")
                Label("Add unit tests", systemImage: "checkmark.shield")
            }
        }
        .navigationTitle("Reference Checklist")
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
