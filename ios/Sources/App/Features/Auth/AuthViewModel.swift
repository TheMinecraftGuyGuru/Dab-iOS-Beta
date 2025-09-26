import Foundation
#if canImport(Combine)
import Combine
#else
protocol ObservableObject: AnyObject {}
@propertyWrapper struct Published<Value> {
    var wrappedValue: Value
    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    var projectedValue: Published<Value> { self }
}
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif

@MainActor
final class AuthViewModel: ObservableObject {
    enum Step: Equatable {
        case welcome
        case signIn
        case success
    }

    @Published private(set) var step: Step = .welcome
    @Published var email: String = ""
    @Published var password: String = ""
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var activeTokens: AuthTokens?

    private let authService: AuthenticationService
    private let tokenStore: SecureTokenStore

    init(authService: AuthenticationService, tokenStore: SecureTokenStore) {
        self.authService = authService
        self.tokenStore = tokenStore
        loadPersistedSession()
    }

    func loadPersistedSession() {
        do {
            if let tokens = try tokenStore.loadTokens() {
                activeTokens = tokens
                step = tokens.isExpired ? .signIn : .success
                if tokens.isExpired {
                    Task { [weak self] in
                        await self?.refreshSessionIfNeeded()
                    }
                }
            }
        } catch {
            errorMessage = AuthError.secureStoreFailure.errorDescription
        }
    }

    func advanceFromWelcome() {
        guard !isLoading else { return }
        animateTransition(to: .signIn)
    }

    func retry() {
        errorMessage = nil
        if activeTokens != nil {
            animateTransition(to: .success)
        }
    }

    func signIn() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = AuthError.invalidCredentials.errorDescription
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let credentials = AuthCredentials(email: email, password: password)
            let tokens = try await authService.signIn(with: credentials)
            try tokenStore.save(tokens: tokens)
            activeTokens = tokens
            animateTransition(to: .success)
        } catch let authError as AuthError {
            errorMessage = authError.errorDescription
            try? tokenStore.clear()
        } catch {
            errorMessage = AuthError.networkFailure.errorDescription
        }

        isLoading = false
    }

    func refreshSessionIfNeeded() async {
        guard let tokens = activeTokens else { return }
        guard tokens.isExpired else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let refreshedTokens = try await authService.refreshToken(using: tokens.refreshToken)
            try tokenStore.save(tokens: refreshedTokens)
            activeTokens = refreshedTokens
            animateTransition(to: .success)
        } catch let authError as AuthError {
            errorMessage = authError.errorDescription
            try? tokenStore.clear()
            activeTokens = nil
            animateTransition(to: .signIn)
        } catch {
            errorMessage = AuthError.networkFailure.errorDescription
        }
    }

    func signOut() {
        try? tokenStore.clear()
        activeTokens = nil
        email = ""
        password = ""
        animateTransition(to: .welcome)
    }

    private func animateTransition(to newStep: Step) {
#if canImport(SwiftUI)
        withAnimation {
            step = newStep
        }
#else
        step = newStep
#endif
    }
}
