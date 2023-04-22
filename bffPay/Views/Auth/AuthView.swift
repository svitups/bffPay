//
//  AuthView.swift
//  bffPay
//
//  Created by Eugene Ned on 21.04.2023.
//

import SwiftUI
import AuthenticationServices

struct AuthView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @EnvironmentObject private var authService: AuthService
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("bffPay")
                .font(.largeTitle)
                .bold()
            
            Spacer()
            VStack(spacing: 0) {
                signInWithGoogleButton
                
                signInWithAppleButton
            }
        }
    }
    
    private var signInWithGoogleButton: some View {
        Button {
            authService.handleSignInWithGoogle()
        } label: {
            HStack(spacing: 0) {
                Image("googleLogo")
                    .resizable()
                    .frame(width: Constants.googleLogoSize, height: Constants.googleLogoSize)
                    .padding(.trailing, 4)
                
                Text("Sign in with Google")
                    .bold()
                    .font(.system(size: Constants.buttonTextFontSize))
            }
            .frame(minWidth: Constants.signInButtonMinWidth, minHeight: Constants.signInButtonMinHeight)
            .background(colorScheme == .dark ? .white : .black)
            .cornerRadius(Constants.buttonCornerRadius)
            .foregroundColor(Color(uiColor: .systemBackground))
            .padding(Constants.buttonPadding)
        }
    }
    
    @ViewBuilder
    private var signInWithAppleButton: some View {
        // TODO: Standard approach with .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black) doesn't work on current version of iOS
        VStack {
            switch colorScheme {
            case .dark:
                SignInWithAppleButton { request in
                    authService.handleSignInWithAppleRequest(request)
                } onCompletion: { result in
                    authService.handleSignInWithAppleCompletiion(result)
                }.signInWithAppleButtonStyle(.white)
            case .light:
                SignInWithAppleButton { request in
                    authService.handleSignInWithAppleRequest(request)
                } onCompletion: { result in
                    authService.handleSignInWithAppleCompletiion(result)
                }.signInWithAppleButtonStyle(.black)
            @unknown default:
                fatalError("Not Yet Implemented")
            }
        }
        .frame(maxWidth: Constants.signInButtonMinWidth, maxHeight: Constants.signInButtonMinHeight)
        .cornerRadius(Constants.buttonCornerRadius)
        .padding(Constants.buttonPadding)
    }
    
    private enum Constants {
        static let signInButtonMinHeight: CGFloat = 50
        static let signInButtonMinWidth: CGFloat = UIScreen.main.bounds.width * 0.7
        static let buttonCornerRadius: CGFloat = 10
        static let buttonPadding: CGFloat = 10
        static let buttonTextFontSize: CGFloat = 18
        
        static let googleLogoSize: CGFloat = 18
        static let googleLogoPadding: CGFloat = 24
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
