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

## Android-to-iOS Conversion To-Do List

- [x] Audit the Flutter project to catalogue core screens, navigation flows, and API integrations that must be replicated in SwiftUI.
  - [x] Catalogued feature modules (`features/auth`, `home`, `library`, `player`, `lyrics`, `search`) and the documented user journey from account sign-in through streaming and library engagement.
  - [x] Rebuild onboarding and authentication flows (login, token refresh, secure storage) that live under the Flutter `features/auth` module.
    - Implemented SwiftUI onboarding, sign-in, and signed-in shell screens powered by a stateful `AuthViewModel`.
    - Added token persistence abstractions to mimic secure storage and covered the flows with XCTest cases.
  - [ ] Mirror home/discovery experiences from `features/home`, including curated content rails and quick entry points into playback.
  - [ ] Port library management flows from `features/library` (collection browsing, pagination, playlist organization) that rely on unlimited track handling.
  - [ ] Recreate the player module from `features/player` with advanced audio controls, background playback, and bridge hooks for the custom native audio engine.
  - [ ] Translate the lyrics presentation stack from `features/lyrics`, covering synced/unsynced lyrics and overlays on the player.
  - [ ] Implement global search surfaces aligned with `features/search`, ensuring deep-link navigation into albums, artists, and tracks.
  - [ ] Integrate REST endpoints used by the Flutter client (authentication, library, playback, search, lyrics) with Swift async networking and caching equivalents.
  - [ ] Map dependency injection/service locators (GetIt + Injectable) and shared utilities into Swift modules for modularity.
  - [ ] Plan the Swift bridge for the custom native audio engine currently accessed through Kotlin ↔ Dart method channels.
- [ ] Define SwiftUI architectural patterns (e.g., MVVM) and module boundaries that map cleanly to the existing Android feature areas.
- [ ] Draft shared data models and service interfaces that mirror the Flutter counterparts, documenting gaps or platform-specific adjustments.
- [ ] Design UI components and theming tokens that reproduce the Android look-and-feel while embracing iOS conventions.
- [ ] Plan migration of networking, authentication, and persistence layers, identifying reusable logic vs. newly implemented services.
- [ ] Prioritize feature parity milestones, including onboarding, core browsing experiences, and any monetization or social flows.
- [ ] Establish testing strategy (unit, snapshot, and UI tests) and align CI coverage with the legacy app's critical paths.
- [ ] Prepare rollout checklist for App Store delivery, analytics hooks, and user feedback loops once feature parity is achieved.

## Getting Started

1. Install the latest Xcode and ensure the Swift toolchain is available (`swift --version`).
2. Open the `ios/` directory in Xcode once project files are generated.
3. Use the Android Flutter project under `android/` as a guide for expected behaviour, API contracts, and asset usage.

## Contributing

Please review `AGENTS.md` for repository-specific conventions before making changes. Submit PRs that keep the Android reference intact while iterating on the new iOS native implementation.
