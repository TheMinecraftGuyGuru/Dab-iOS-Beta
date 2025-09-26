# Architecture Notes

The native app will follow a modular architecture that mirrors the conceptual layers in the Flutter project located at `../android`. Key ideas:

- **Feature Parity:** Audit each Flutter screen and identify SwiftUI equivalents.
- **Networking:** Reuse API contracts exposed in the Flutter code; consider using async/await with URLSession.
- **State Management:** Adopt ObservableObjects and the new Observation framework for reactive updates.

Document major decisions here as the project evolves.
