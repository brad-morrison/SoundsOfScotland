import Foundation
import AuthenticationServices
import SwiftUI
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var user: AuthenticatedUser?
    @Published var isLoading = false
    @Published var errorMessage: String?

    init() {
        self.user = AuthService.shared.currentUser
        NotificationCenter.default.addObserver(forName: .authStateChanged, object: nil, queue: .main) { [weak self] _ in
            self?.user = AuthService.shared.currentUser
        }
    }

    var isAuthenticated: Bool { user != nil }

    func signInWithApple(anchor: ASPresentationAnchor) async {
        isLoading = true
        errorMessage = nil
        await withCheckedContinuation { continuation in
            AuthService.shared.signInWithApple(presentationAnchor: anchor) { [weak self] result in
                Task { @MainActor in
                    self?.isLoading = false
                    switch result {
                    case .success(let user):
                        self?.user = user
                    case .failure(let error):
                        let nsError = error as NSError
                        print("AuthViewModel error: domain=\(nsError.domain) code=\(nsError.code) userInfo=\(nsError.userInfo)")
                        if nsError.domain == ASAuthorizationError.errorDomain, let code = ASAuthorizationError.Code(rawValue: nsError.code) {
                            switch code {
                            case .canceled:
                                self?.errorMessage = "You canceled the sign-in."
                            case .failed:
                                self?.errorMessage = "Sign in with Apple failed. Please try again."
                            case .invalidResponse:
                                self?.errorMessage = "Received an invalid response from Apple."
                            case .notHandled:
                                self?.errorMessage = "Sign in with Apple couldn't be handled."
                            case .unknown:
                                self?.errorMessage = "An unknown error occurred (1000)."
                            @unknown default:
                                self?.errorMessage = "An unexpected error occurred."
                            }
                        } else {
                            self?.errorMessage = nsError.localizedDescription
                        }
                    }
                    continuation.resume()
                }
            }
        }
    }

    func signOut() {
        AuthService.shared.signOut()
        self.user = nil
    }
}

