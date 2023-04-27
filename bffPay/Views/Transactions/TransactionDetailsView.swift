//
//  TransactionDetailsView.swift
//  bffPay
//
//  Created by Eugene Ned on 27.04.2023.
//

import SwiftUI

struct TransactionDetailsView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject private var transactionsListVM: TransactionsListViewModel
    
    var transaction: Transaction
    
    init(_ transaciton: Transaction) {
        self.transaction = transaciton
    }
    
    var body: some View {
        VStack {
            Text("\(transaction.amount.stringWithoutZeroFraction) \(transaction.currency)")
                .font(.title3)
            
            Form {
                Section("Paid by \(PartyRepository.shared.getNameOfUser(withID: transaction.paidByID, in: transaction.partyID) ?? "No name") for:") {
                    ForEach(transaction.paidForIDs, id: \.self) { userID in
                        HStack {
                            Text(PartyRepository.shared.getNameOfUser(withID: userID, in: transaction.partyID) ?? "No name")
                            Spacer()
                            Text("\(calculatePart().stringWithoutZeroFraction) \(transaction.currency)")
                        }
                    }
                }
            }
        }
        .navigationTitle(transaction.title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                removeTransactionButton
            }
        }
    }
    
    private var removeTransactionButton: some View {
        Button {
            transactionsListVM.delete(transaction.id!) {
                presentationMode.wrappedValue.dismiss()
            }
        } label: {
            Image(systemName: "trash")
        }
    }
    
    private func calculatePart() -> Double {
        let peopleCount = transaction.paidForIDs.count
        return transaction.amount / Double(peopleCount)
    }
}

//struct TransactionDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        TransactionDetailsView()
//    }
//}
