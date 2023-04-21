//
//  GIDConfiguration+Ext.swift
//  bffPay
//
//  Created by Eugene Ned on 21.04.2023.
//

import Firebase
import GoogleSignIn

extension GIDConfiguration {
    static func getGIDConfigurationInstance() -> GIDConfiguration {
        GIDConfiguration(clientID: FirebaseApp.app()?.options.clientID ?? "")
    }
}
