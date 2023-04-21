//
//  User.swift
//  bffPay
//
//  Created by Eugene Ned on 21.04.2023.
//

import SwiftUI
import FirebaseFirestoreSwift

struct UserInfo: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var userId: String = ""
    var displayName: String = ""
    var email: String = ""
//    var rooms:
}
