# iOS Native App Workspace

This directory holds the new Swift-based implementation for the Dab application. The goal is to recreate feature parity with the existing Flutter project located under `../android` while embracing native iOS patterns and tooling.

## Structure

- `Package.swift` – Swift Package manifest that lets us bootstrap the project before generating an Xcode workspace.
- `Sources/App/` – SwiftUI entry point and shared application scaffolding.
- `Sources/App/Features/Auth/` – Onboarding, sign-in, and token management scaffolding for the authentication journey.
- `Resources/` – Placeholder for assets that will be ported or recreated for iOS.
- `Docs/` – Design notes, technical decisions, and references collected during development. See [`Docs/SelfHostedTheosRunner.md`](Docs/SelfHostedTheosRunner.md) for guidance on preparing a Linux self-hosted runner with Theos.

## Next Steps

1. Add dependencies (e.g., Alamofire, Combine, async/await networking) to `Package.swift` as the architecture solidifies.
2. Generate an Xcode project or workspace that consumes this package for previews and simulator builds.
3. Build SwiftUI views by referencing layout and flow from the Flutter implementation. Start with the onboarding/authentication flow documented in [`Docs/AuthFlow.md`](Docs/AuthFlow.md).
4. Write unit tests with XCTest and snapshot/UI tests as modules mature.

Keep the Flutter project untouched unless specifically instructed, and mirror behaviour in Swift whenever possible.
