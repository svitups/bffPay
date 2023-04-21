//
//  ContentView.swift
//  bffPay
//
//  Created by Eugene Ned on 18.04.2023.
//

import SwiftUI

struct MainView: View {
    @ObservedObject private var authService = AuthService()
    
    var body: some View {
        if let _ = authService.user {
            HomeView()
                .environmentObject(authService)
        } else {
            AuthView()
                .environmentObject(authService)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
