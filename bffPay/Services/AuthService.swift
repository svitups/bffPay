//
//  AuthService.swift
//  bffPay
//
//  Created by Eugene Ned on 21.04.2023.
//

import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class AuthService: ObservableObject {
    @Published var user: User? = Auth.auth().currentUser
    @Published var errorMessage = ""
    private var authenticationStateHandler: AuthStateDidChangeListenerHandle?
    
    init() {
        addListeners()
    }
    
    func signInWithGoogle() {
        processGoogleAuth {
            guard let user = self.user, let name = user.displayName, let email = user.email else { return }
            
            UserRepository.shared.isExist(with: user.uid) { result in
                switch result {
                case .success(let userInfo):
                    if userInfo == nil {
                        UserRepository.shared.add(UserInfo(userId: user.uid, displayName: name, email: email))
                    }
                case .failure(let error): print(error.localizedDescription)
                }
            }
        }
    }
    
    func signInWithApple() {
        // TODO
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
    
    private func addListeners() {
        if let handle = authenticationStateHandler {
            Auth.auth().removeStateDidChangeListener(handle)
        }
        
        authenticationStateHandler = Auth.auth()
            .addStateDidChangeListener { _, user in
                self.user = user
            }
    }
    
    // MARK: Private methods
    
    private func processGoogleAuth(completion: @escaping () -> Void) {
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
                    
                    completion()
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
