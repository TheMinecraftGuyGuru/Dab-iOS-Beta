# Onboarding & Authentication Plan

The onboarding and sign-in surfaces now mirror the structure of the Flutter `features/auth` module while leaning on SwiftUI and async/await APIs.

## Flow Overview

1. **Welcome** – Presents the marketing headline and CTA to begin sign-in.
2. **Sign In** – Collects email/password and invokes the `AuthenticationService`.
3. **Signed-In Shell** – Confirms the active session and provides a stub for future home/library navigation.

## View Model

`AuthViewModel` coordinates the UI state machine, session persistence, and refresh logic:

- Loads any stored tokens on launch and transitions to the proper step.
- Calls the async `AuthenticationService` to sign in or refresh tokens.
- Surfaces friendly error messaging for invalid credentials, expired sessions, or connectivity failures.

## Services

- `AuthenticationService` is protocol-oriented so a real API client can replace the mock implementation pulled from Flutter contracts.
- `SecureTokenStore` abstracts Keychain persistence. A simple in-memory store aids previews/tests while `EphemeralKeychainStore` leverages `UserDefaults` until Keychain integration lands.

## Next Steps

- Replace the mock service with a concrete client once networking modules are in place.
- Swap the ephemeral secure store with a Keychain-backed implementation.
- Extend the flow to support account creation, two-factor challenges, and password recovery once the corresponding APIs are mapped.
