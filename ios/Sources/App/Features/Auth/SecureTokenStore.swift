import Foundation

protocol SecureTokenStore {
    func loadTokens() throws -> AuthTokens?
    func save(tokens: AuthTokens) throws
    func clear() throws
}

final class InMemorySecureTokenStore: SecureTokenStore {
    private let queue = DispatchQueue(label: "InMemorySecureTokenStore")
    private var cachedTokens: AuthTokens?

    func loadTokens() throws -> AuthTokens? {
        var tokens: AuthTokens?
        queue.sync {
            tokens = cachedTokens
        }
        return tokens
    }

    func save(tokens: AuthTokens) throws {
        queue.sync {
            cachedTokens = tokens
        }
    }

    func clear() throws {
        queue.sync {
            cachedTokens = nil
        }
    }
}

final class EphemeralKeychainStore: SecureTokenStore {
    private let storageKey = "dab.auth.tokens"
    private let userDefaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func loadTokens() throws -> AuthTokens? {
        guard let data = userDefaults.data(forKey: storageKey) else {
            return nil
        }
        do {
            return try decoder.decode(AuthTokens.self, from: data)
        } catch {
            throw AuthError.secureStoreFailure
        }
    }

    func save(tokens: AuthTokens) throws {
        do {
            let data = try encoder.encode(tokens)
            userDefaults.set(data, forKey: storageKey)
        } catch {
            throw AuthError.secureStoreFailure
        }
    }

    func clear() throws {
        userDefaults.removeObject(forKey: storageKey)
    }
}
