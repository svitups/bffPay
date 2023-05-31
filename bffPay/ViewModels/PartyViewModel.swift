//
//  PartyViewModel.swift
//  bffPay
//
//  Created by Eugene Ned on 23.04.2023.
//

import Foundation
import Combine

final class PartyViewModel: ObservableObject, Identifiable {
    @Published var party: Party
    @Published var debts = [Debt]()
    
    var id = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init(party: Party) {
        self.party = party
        $party
            .compactMap { $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
    
    private func calculateDebts(transactions: [Transaction]) -> [String: Double] {
        var balance = [String: Double]()

        for transaction in transactions {
            let splitAmount = transaction.amount / Double(transaction.payeeIDs.count)
            
            for payee in transaction.payeeIDs {
                balance[transaction.payerID, default: 0] += splitAmount
                balance[payee, default: 0] -= splitAmount
            }
        }
        
        return balance
    }

    func resolveDebts(transactions: [Transaction]) {
        let balance = calculateDebts(transactions: transactions)
        
        var debtors = balance.filter { $0.value < 0 }.map { ($0.key, -$0.value) }
        var creditors = balance.filter { $0.value > 0 }.map { $0 }
        
        var settlements = [Debt]()
        
        while !debtors.isEmpty && !creditors.isEmpty {
            let (debtor, debt) = debtors.removeFirst()
            let (creditor, credit) = creditors.removeFirst()
            
            if debt > credit {
                settlements.append(Debt(id: UUID(), payer: debtor, payee: creditor, amount: credit))
                debtors.insert((debtor, debt - credit), at: 0)
            } else if debt < credit {
                settlements.append(Debt(id: UUID(), payer: debtor, payee: creditor, amount: debt))
                creditors.insert((creditor, credit - debt), at: 0)
            } else {
                settlements.append(Debt(id: UUID(), payer: debtor, payee: creditor, amount: debt))
            }
        }
        
        DispatchQueue.main.async {
            self.debts = settlements
        }
    }
}
