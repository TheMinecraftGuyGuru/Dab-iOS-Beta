import XCTest
@testable import App

@MainActor
final class AuthViewModelTests: XCTestCase {
    func testLoadsPersistedTokens() async {
        let tokenStore = InMemorySecureTokenStore()
        try? tokenStore.save(tokens: .mock())
        let sut = AuthViewModel(
            authService: MockAuthenticationService(behaviour: .success),
            tokenStore: tokenStore
        )

        XCTAssertEqual(sut.step, .success)
        XCTAssertNotNil(sut.activeTokens)
    }

    func testSignInSuccessPersistsTokens() async throws {
        let tokenStore = InMemorySecureTokenStore()
        let sut = AuthViewModel(
            authService: MockAuthenticationService(behaviour: .success),
            tokenStore: tokenStore
        )

        sut.advanceFromWelcome()
        sut.email = "user@example.com"
        sut.password = "password"

        await sut.signIn()

        let storedTokens = try tokenStore.loadTokens()
        XCTAssertEqual(sut.step, .success)
        XCTAssertNotNil(storedTokens)
    }

    func testInvalidCredentialsShowsError() async {
        let sut = AuthViewModel(
            authService: MockAuthenticationService(behaviour: .invalidCredentials),
            tokenStore: InMemorySecureTokenStore()
        )

        sut.advanceFromWelcome()
        sut.email = "user@example.com"
        sut.password = "password"

        await sut.signIn()

        XCTAssertEqual(sut.step, .signIn)
        XCTAssertEqual(sut.errorMessage, AuthError.invalidCredentials.errorDescription)
    }

    func testRefreshSessionHandlesExpiry() async {
        let tokenStore = InMemorySecureTokenStore()
        try? tokenStore.save(tokens: AuthTokens(accessToken: "signed_in_access", refreshToken: "stale_token", expiresAt: .distantPast))

        let sut = AuthViewModel(
            authService: MockAuthenticationService(behaviour: .success),
            tokenStore: tokenStore
        )

        XCTAssertEqual(sut.step, .signIn)

        await sut.refreshSessionIfNeeded()

        XCTAssertEqual(sut.step, .signIn)
        XCTAssertEqual(sut.errorMessage, AuthError.sessionExpired.errorDescription)
        XCTAssertNil(sut.activeTokens)
    }

    func testRefreshSessionSuccessRestoresSignedInState() async {
        let tokenStore = InMemorySecureTokenStore()
        try? tokenStore.save(tokens: AuthTokens(accessToken: "signed_in_access", refreshToken: "signed_in_refresh", expiresAt: .distantPast))

        let sut = AuthViewModel(
            authService: MockAuthenticationService(behaviour: .success),
            tokenStore: tokenStore
        )

        XCTAssertEqual(sut.step, .signIn)

        await sut.refreshSessionIfNeeded()

        XCTAssertEqual(sut.step, .success)
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(sut.activeTokens?.accessToken, "refreshed_access")
    }
}
