# Dab iOS Native App

This repository is being restructured to build a Swift-based native iOS experience while preserving the existing Flutter codebase for reference.

## Repository Layout

- `android/` – Contains the legacy cross-platform Flutter project that previously lived at the repository root. Keep this code unchanged so it can serve as design and feature parity guidance while the native client is developed.
- `ios/` – Workspace for the new SwiftUI application. It currently contains the scaffolding for a Swift Package that will evolve into the native app target.
- `README.md` – High-level documentation for the iOS effort (this file).
- `AGENTS.md` – Guidance for contributors and AI agents about the repository plan.

## Swift Native App Roadmap

1. **Project Setup:** Finalize the Swift Package manifest and set up Xcode project/workspace files for a modular architecture.
2. **Foundational Modules:** Establish shared data models, networking layer, and design system components using SwiftUI.
3. **Feature Development:** Recreate core Android features with SwiftUI views, using the `android/` Flutter implementation as a functional reference for UI flows and API interactions.
4. **Testing & CI:** Add unit/UI tests and continuous integration workflows tailored for iOS.

## Getting Started

1. Install the latest Xcode and ensure the Swift toolchain is available (`swift --version`).
2. Open the `ios/` directory in Xcode once project files are generated.
3. Use the Android Flutter project under `android/` as a guide for expected behaviour, API contracts, and asset usage.

## Contributing

Please review `AGENTS.md` for repository-specific conventions before making changes. Submit PRs that keep the Android reference intact while iterating on the new iOS native implementation.
