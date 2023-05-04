//
//  DebtSettlement.swift
//  bffPay
//
//  Created by Eugene Ned on 04.05.2023.
//

import Foundation

struct DebtSettlement: Identifiable {
    var id: UUID
    
    var fromID: String
    var toID: String
    var amount: Double
}
