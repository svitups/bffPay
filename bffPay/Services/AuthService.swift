//
//  AuthService.swift
//  bffPay
//
//  Created by Eugene Ned on 21.04.2023.
//

import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import AuthenticationServices
import CryptoKit

class AuthService: ObservableObject {
    @Published var user: User? = Auth.auth().currentUser
    @Published var errorMessage = ""
    
    private var authenticationStateHandler: AuthStateDidChangeListenerHandle?
    
    private var currentNonce: String?
    
    init() {
        addListeners()
    }
    
    private func addListeners() {
        if let handle = authenticationStateHandler {
            Auth.auth().removeStateDidChangeListener(handle)
        }
        
        authenticationStateHandler = Auth.auth()
            .addStateDidChangeListener { _, user in
                self.user = user
            }
    }
    
    func handleSignInWithGoogle() {
        do {
            let config = GIDConfiguration(clientID: FirebaseApp.app()?.options.clientID ?? "")
            GIDSignIn.sharedInstance.configuration = config
            
            let uiViewController = try UIApplication.getRootViewController()
            
            GIDSignIn.sharedInstance.signIn(withPresenting: uiViewController) { user, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                guard let idToken = user?.user.idToken, let accessToken = user?.user.accessToken else {
                    print("Can't get google user credentials")
                    return
                }
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
                
                Auth.auth().signIn(with: credential) { result, error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    guard result?.credential as? OAuthCredential != nil else { return }
                    
                    self.processUser()
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
    }
    
    func handleSignInWithAppleCompletiion(_ result: Result<ASAuthorization, Error>) {
        if case .failure(let failure) = result {
            errorMessage = failure.localizedDescription
        } else if case .success(let success) = result {
            print("Apple sign-in successful")
            if let appleIDCredential = success.credential as? ASAuthorizationAppleIDCredential {
                print("Apple ID credential: \(appleIDCredential)")
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: a login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identity token.")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                
                let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                          idToken: idTokenString,
                                                          rawNonce: nonce)
                
                Task {
                    do {
                        let result = try await Auth.auth().signIn(with: credential)
                        
                        self.processUser()
                    } catch {
                        print("Error authentificating: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteAccount() async {
        do {
            try await user?.delete()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: Private methods
    
    private func processUser() {
        guard let user = self.user, let email = user.email else { return }
        
        UserRepository.shared.isExist(with: user.uid) { result in
            switch result {
            case .success(let userInfo):
                if userInfo == nil {
                    UserRepository.shared.add(UserInfo(userId: user.uid, displayName: user.displayName ?? "No name", email: email))
                }
            case .failure(let error): print(error.localizedDescription)
            }
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}
