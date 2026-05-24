import SwiftUI
import AuthenticationServices

private func keyWindow() -> UIWindow? {
    let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
    let windows = scenes.flatMap { $0.windows }
    if let key = windows.first(where: { $0.isKeyWindow }) {
        return key
    }
    let fallback = windows.first
    if fallback == nil { print("AuthView: No window found for presentation anchor") }
    return fallback
}

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.dismiss) private var dismiss

    init() {
        print("AuthView: initialized")
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("AuthView loaded: \(UUID().uuidString.prefix(6))")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Image(systemName: "person.crop.circle")
                    .font(.system(size: 52))
                    .foregroundStyle(isDarkMode ? .white : .black)

                VStack(spacing: 8) {
                    Text("Sign in")
                        .font(.title2).bold()
                        .foregroundStyle(isDarkMode ? .white : .black)

                    Text("Use your Apple ID to sign in and sync your profile.")
                        .font(.subheadline)
                        .foregroundStyle(isDarkMode ? .white.opacity(0.7) : .black.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Button {
                    print("AuthView: Sign in button tapped")
                    if let anchor = keyWindow() {
                        Task { await viewModel.signInWithApple(anchor: anchor) }
                    } else {
                        print("AuthView: Anchor is nil; cannot start Sign in with Apple")
                    }
                } label: {
                    HStack {
                        Image(systemName: "apple.logo")
                            .font(.headline)
                        Text("Sign in with Apple")
                            .font(.headline)
                    }
                    .foregroundStyle(isDarkMode ? .black : .white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(isDarkMode ? Color.white : Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .disabled(viewModel.isLoading)
                .opacity(viewModel.isLoading ? 0.6 : 1.0)

                if viewModel.isLoading {
                    ProgressView().padding(.top, 8)
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Spacer()
            }
            .padding()
            .background(isDarkMode ? Color(red: 0.04, green: 0.06, blue: 0.12) : Color(red: 0.98, green: 0.97, blue: 0.94))
            .onAppear { print("AuthView: onAppear") }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
            .onChange(of: viewModel.user) { _, newValue in
                if newValue != nil {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AuthView()
}
