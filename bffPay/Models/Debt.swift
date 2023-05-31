//
//  DebtSettlement.swift
//  bffPay
//
//  Created by Eugene Ned on 04.05.2023.
//

import Foundation

struct Debt: Identifiable {
    var id: UUID
    
    var payer: String
    var payee: String
    var amount: Double
}
