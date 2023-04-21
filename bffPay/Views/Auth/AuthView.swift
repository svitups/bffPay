//
//  AuthView.swift
//  bffPay
//
//  Created by Eugene Ned on 21.04.2023.
//

import SwiftUI
import SwiftUIFontIcon

struct AuthView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @EnvironmentObject private var authService: AuthService
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Text("bffPay")
                    .font(.system(.largeTitle, design: .rounded))
                    .bold()
                Spacer(minLength: geometry.size.height * 0.7)
                VStack(spacing: 0) {
                    Group {
                        Button {
                            authService.signInWithGoogle()
                        } label: {
                            Text("Sign in with Google")
                                .bold()
                                .font(.system(size: 18))
                                .frame(maxWidth: geometry.size.width * 0.7, alignment: .center)
                                .frame(minHeight: 50)
                                .background(colorScheme == .dark ? Color.white : Color.black)
                                .cornerRadius(10)
                                .foregroundColor(Color(uiColor: .systemBackground))
                                .padding(20)
                        }
                    }
                }
                .frame(maxWidth: geometry.size.width)
                .frame(height: geometry.size.height * 0.1)
                Spacer()
            }
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
