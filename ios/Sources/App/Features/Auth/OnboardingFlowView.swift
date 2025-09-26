#if canImport(SwiftUI)
import SwiftUI

struct OnboardingFlowView: View {
    @ObservedObject var viewModel: AuthViewModel

    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
    }

    init(dependencies: AppDependencies) {
        self.viewModel = AuthViewModel(
            authService: dependencies.authService,
            tokenStore: dependencies.tokenStore
        )
    }

    var body: some View {
        Group {
            switch viewModel.step {
            case .welcome:
                OnboardingWelcomeView(advanceAction: viewModel.advanceFromWelcome)
            case .signIn:
                SignInView(viewModel: viewModel)
            case .success:
                AuthenticatedHomeView(signOutAction: viewModel.signOut)
                    .task {
                        await viewModel.refreshSessionIfNeeded()
                    }
            }
        }
        .animation(.easeInOut, value: viewModel.step)
        .alert("Authentication Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { isPresented in
                if !isPresented {
                    viewModel.retry()
                }
            }
        )) {
            Button("OK", role: .cancel) {
                viewModel.retry()
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

private struct OnboardingWelcomeView: View {
    var advanceAction: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "headphones")
                .font(.system(size: 72))
                .foregroundStyle(.tint)

            Text("Stream what moves you")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Sign in with your Dab account to pick up where you left off across playlists, library, and lyrics experiences.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            Button(action: advanceAction) {
                Label("Get Started", systemImage: "arrow.right.circle.fill")
                    .font(.headline)
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .padding()
    }
}

private struct SignInView: View {
    @ObservedObject var viewModel: AuthViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Sign in to Dab")
                    .font(.title2)
                    .fontWeight(.semibold)

                VStack(alignment: .leading, spacing: 12) {
                    TextField("Email", text: $viewModel.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding()
                        .background(.regularMaterial)
                        .cornerRadius(12)

                    SecureField("Password", text: $viewModel.password)
                        .textContentType(.password)
                        .padding()
                        .background(.regularMaterial)
                        .cornerRadius(12)
                }

                Button {
                    Task {
                        await viewModel.signIn()
                    }
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(.white)
                    } else {
                        Label("Continue", systemImage: "arrow.right")
                            .fontWeight(.semibold)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.canSubmit)

                Button("Forgot password?") {}
                    .buttonStyle(.borderless)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 8) {
                Text("By continuing you agree to the Terms of Service and Privacy Policy.")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
    }
}

private struct AuthenticatedHomeView: View {
    var signOutAction: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "waveform")
                .font(.system(size: 72))
                .foregroundStyle(.tint)

            Text("You're signed in")
                .font(.title)
                .fontWeight(.semibold)

            Text("We'll finish bringing over the home, library, and playback experiences next.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            Button("Sign Out", action: signOutAction)
                .buttonStyle(.bordered)
            Spacer()
        }
        .padding()
    }
}

#Preview("Onboarding") {
    OnboardingFlowView(dependencies: .preview)
}
#endif
