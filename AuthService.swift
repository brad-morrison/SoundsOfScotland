import Foundation
import AuthenticationServices
import Security

struct AuthenticatedUser: Codable, Equatable {
    let id: String
    let displayName: String?
    let email: String?
}

final class AuthService: NSObject {
    static let shared = AuthService()

    private let keychainService = "com.soundsofscotland.auth"
    private let keychainAccount = "appleUserID"

    private(set) var currentUser: AuthenticatedUser? {
        didSet { NotificationCenter.default.post(name: .authStateChanged, object: nil) }
    }

    override private init() {
        super.init()
        self.currentUser = loadUserFromKeychain()
    }

    func signInWithApple(presentationAnchor: ASPresentationAnchor, completion: @escaping (Result<AuthenticatedUser, Error>) -> Void) {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        print("AuthService: performRequests starting with anchor=\(String(describing: presentationAnchor))")
        controller.performRequests()

        // Store completion temporarily using associated object-like storage
        self.pendingCompletion = completion
        self.pendingPresentationAnchor = presentationAnchor
    }

    func signOut() {
        currentUser = nil
        deleteUserFromKeychain()
    }

    // MARK: - Private state for callbacks
    private var pendingCompletion: ((Result<AuthenticatedUser, Error>) -> Void)?
    private weak var pendingPresentationAnchor: ASPresentationAnchor?
}

// MARK: - ASAuthorizationControllerDelegate
extension AuthService: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            print("AuthService: didCompleteWithAuthorization success")
            let userID = appleIDCredential.user
            var fullName: String? = nil
            if let name = appleIDCredential.fullName {
                let formatter = PersonNameComponentsFormatter()
                fullName = formatter.string(from: name)
            }
            let email = appleIDCredential.email

            let user = AuthenticatedUser(id: userID, displayName: fullName, email: email)
            self.currentUser = user
            saveUserToKeychain(user)
            pendingCompletion?(.success(user))
            pendingCompletion = nil
        default:
            let error = NSError(domain: "AuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unsupported credential type"])
            pendingCompletion?(.failure(error))
            pendingCompletion = nil
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let nsError = error as NSError
        print("ASAuthorization error details: domain=\(nsError.domain) code=\(nsError.code) userInfo=\(nsError.userInfo)")
        if nsError.domain == ASAuthorizationError.errorDomain, let code = ASAuthorizationError.Code(rawValue: nsError.code) {
            switch code {
            case .canceled:
                print("Sign in with Apple canceled by user")
            case .failed:
                print("Sign in with Apple failed")
            case .invalidResponse:
                print("Sign in with Apple invalid response")
            case .notHandled:
                print("Sign in with Apple not handled")
            case .unknown:
                print("Sign in with Apple unknown error")
            @unknown default:
                print("Sign in with Apple unexpected error")
            }
        } else {
            print("Sign in with Apple error: \(nsError.localizedDescription)")
        }
        pendingCompletion?(.failure(error))
        pendingCompletion = nil
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension AuthService: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return pendingPresentationAnchor ?? ASPresentationAnchor()
    }
}

// MARK: - Keychain helpers
private extension AuthService {
    func saveUserToKeychain(_ user: AuthenticatedUser) {
        do {
            let data = try JSONEncoder().encode(user)
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: keychainService,
                kSecAttrAccount as String: keychainAccount
            ]
            SecItemDelete(query as CFDictionary)
            let addQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: keychainService,
                kSecAttrAccount as String: keychainAccount,
                kSecValueData as String: data
            ]
            SecItemAdd(addQuery as CFDictionary, nil)
        } catch {
            // Ignore encoding errors for now
        }
    }

    func loadUserFromKeychain() -> AuthenticatedUser? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecReturnData as String: true
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == errSecSuccess, let data = item as? Data {
            return try? JSONDecoder().decode(AuthenticatedUser.self, from: data)
        }
        return nil
    }

    func deleteUserFromKeychain() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount
        ]
        SecItemDelete(query as CFDictionary)
    }
}

extension Notification.Name {
    static let authStateChanged = Notification.Name("authStateChanged")
}
