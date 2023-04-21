//
//  UIApplication+UIViewController.swift
//  bffPay
//
//  Created by Eugene Ned on 21.04.2023.
//

import UIKit

extension UIApplication {
    static func getRootViewController() throws -> UIViewController {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first

        guard let uiViewController = window?.rootViewController else { fatalError() }
        return uiViewController
    }
}
