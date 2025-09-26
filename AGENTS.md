# Repository Guidance for Agents

## Scope
These instructions apply to the entire repository unless overridden by a nested `AGENTS.md`.

## Key Goals
- The `android/` directory now contains the original Flutter project. Treat it as read-only reference material unless a task explicitly calls for changes to the legacy app.
- All new iOS-native work should live under `ios/`.

## Working Guidelines
1. **Preserve Reference:** Do not delete or substantially restructure files inside `android/` without explicit direction, as they document expected behaviour for the native implementation.
2. **Swift Native Development:** Place new Swift/SwiftUI source, configuration files, and documentation inside `ios/`.
3. **Documentation Updates:** Keep `README.md` focused on the iOS-native roadmap. If you need to document Android-specific behaviour, add documentation under `android/` instead.
4. **Testing:** When adding Swift code, include placeholders or tests where feasible and document any missing coverage.

If uncertain about where a change belongs, err on the side of keeping `android/` untouched and add new work in `ios/`.
