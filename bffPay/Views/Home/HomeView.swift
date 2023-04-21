//
//  HomeView.swift
//  bffPay
//
//  Created by Eugene Ned on 21.04.2023.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var authService: AuthService
    
    var body: some View {
        Text("Home view")
        
        Button {
            authService.signOut()
        } label: {
            Text("Sign out")
                .bold()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
