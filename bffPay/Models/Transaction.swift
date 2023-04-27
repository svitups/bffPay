//
//  Transaction.swift
//  bffPay
//
//  Created by Eugene Ned on 23.04.2023.
//

import Foundation
import FirebaseFirestoreSwift

struct Transaction: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var amount: Double
    var currency: String
    var date: Date
    var paidByID: String
    var paidForIDs: [String]
    var partyID: String
}
