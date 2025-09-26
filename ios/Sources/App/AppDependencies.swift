struct AppDependencies {
    let authService: AuthenticationService
    let tokenStore: SecureTokenStore

    static var preview: AppDependencies {
        AppDependencies(
            authService: MockAuthenticationService(behaviour: .success),
            tokenStore: InMemorySecureTokenStore()
        )
    }

    static var live: AppDependencies {
        // TODO: Replace with production implementations once networking and Keychain storage are available.
        preview
    }
}
