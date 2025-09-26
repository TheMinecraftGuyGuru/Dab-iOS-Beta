import Foundation

struct AuthCredentials: Equatable {
    var email: String
    var password: String
}

struct AuthTokens: Equatable, Codable {
    var accessToken: String
    var refreshToken: String
    var expiresAt: Date

    var isExpired: Bool {
        expiresAt <= Date()
    }
}

enum AuthError: Error, LocalizedError, Equatable {
    case invalidCredentials
    case sessionExpired
    case networkFailure
    case secureStoreFailure

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "The email or password you entered is incorrect."
        case .sessionExpired:
            return "Your session has expired. Please sign in again."
        case .networkFailure:
            return "We couldn't reach the authentication service. Check your connection and try again."
        case .secureStoreFailure:
            return "We couldn't persist your session securely."
        }
    }
}

extension AuthTokens {
    static func mock(accessToken: String = "access", refreshToken: String = "refresh", expiresIn seconds: TimeInterval = 3600) -> AuthTokens {
        AuthTokens(
            accessToken: accessToken,
            refreshToken: refreshToken,
            expiresAt: Date().addingTimeInterval(seconds)
        )
    }
}
