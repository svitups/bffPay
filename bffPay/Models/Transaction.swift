//
//  Transaction.swift
//  bffPay
//
//  Created by Eugene Ned on 23.04.2023.
//

import Foundation
import FirebaseFirestoreSwift

struct Transaction {
    @DocumentID var id: String?
    var title: String
    var amoutn: Int
    var date: Date
    var paidByID: String
    var paidForIDs: [String]
}
