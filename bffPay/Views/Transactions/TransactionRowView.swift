//
//  TransactionRowView.swift
//  bffPay
//
//  Created by Eugene Ned on 27.04.2023.
//

import SwiftUI

struct TransactionRowView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var transaction: Transaction
    
    init(_ transaction: Transaction) {
        self.transaction = transaction
    }
    
    var body: some View {
        VStack() {
            HStack() {
                Text(transaction.title)
                    .font(.headline)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
                Spacer()
                
                Text("\(transaction.amount.stringWithoutZeroFraction) \(transaction.currency)")
                    .font(.headline)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
            }
            HStack() {
                Text("paid by ")
                    .font(.subheadline)
                    .foregroundColor(.gray) +
                Text(PartyRepository.shared.getNameOfUser(withID: transaction.paidByID, in: transaction.partyID) ?? "Unknown user")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(transaction.date.compactDate())
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
}
