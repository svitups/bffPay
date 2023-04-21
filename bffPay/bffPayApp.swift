//
//  bffPayApp.swift
//  bffPay
//
//  Created by Eugene Ned on 18.04.2023.
//

import SwiftUI

@main
struct bffPayApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
