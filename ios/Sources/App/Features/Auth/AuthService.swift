import Foundation

protocol AuthenticationService {
    func signIn(with credentials: AuthCredentials) async throws -> AuthTokens
    func refreshToken(using refreshToken: String) async throws -> AuthTokens
}

struct MockAuthenticationService: AuthenticationService {
    enum Behaviour {
        case success
        case invalidCredentials
        case networkFailure
    }

    var behaviour: Behaviour
    var responseDelay: UInt64 = 350_000_000 // nanoseconds

    func signIn(with credentials: AuthCredentials) async throws -> AuthTokens {
        try await Task.sleep(nanoseconds: responseDelay)

        switch behaviour {
        case .success:
            guard credentials.email.contains("@"), credentials.password.count >= 6 else {
                throw AuthError.invalidCredentials
            }
            return .mock(accessToken: "signed_in_access", refreshToken: "signed_in_refresh")
        case .invalidCredentials:
            throw AuthError.invalidCredentials
        case .networkFailure:
            throw AuthError.networkFailure
        }
    }

    func refreshToken(using refreshToken: String) async throws -> AuthTokens {
        try await Task.sleep(nanoseconds: responseDelay)

        guard behaviour == .success else {
            throw AuthError.networkFailure
        }

        guard refreshToken.starts(with: "signed_in") else {
            throw AuthError.sessionExpired
        }

        return .mock(accessToken: "refreshed_access", refreshToken: refreshToken)
    }
}
