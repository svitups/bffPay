//
//  SettingsView.swift
//  bffPay
//
//  Created by Eugene Ned on 22.04.2023.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject private var authService: AuthService
    
    var body: some View {
        NavigationView {
            VStack {
                Button {
                    authService.signOut()
                } label: {
                    Text("Sign out")
                        .bold()
                }.buttonStyle(.bordered)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Close")
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
