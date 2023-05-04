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
    @Published var debts = [DebtSettlement]()
    
    var id = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init(party: Party) {
        self.party = party
        $party
            .compactMap { $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
    
    func resolveDebts(transactions: [Transaction]) {
        var balances: [String: Double] = [:]
        let epsilon = 1e-6
        
        // Populate initial balances
        for (id, _) in party.participants {
            balances[id] = 0.0
        }
        
        print("Initial balances: \(balances)")
        
        // Calculate the balances for each participant
        for transaction in transactions {
            let share = transaction.amount / Double(transaction.paidForIDs.count)
            balances[transaction.paidByID]! += transaction.amount
            
            for beneficiary in transaction.paidForIDs {
                balances[beneficiary]! -= share
            }
        }
        
        print("Balances after transactions: \(balances)")
        
        var debtSettlements: [DebtSettlement] = []
        
        while true {
            if let maxDebtor = balances.max(by: { $0.value < $1.value }),
               let maxCreditor = balances.min(by: { $0.value < $1.value }),
               maxDebtor.value > epsilon, abs(maxCreditor.value) > epsilon,
               maxDebtor.key != maxCreditor.key {
                
                let transactionAmount = min(abs(maxDebtor.value), abs(maxCreditor.value))
                
                debtSettlements.append(DebtSettlement(id: UUID(), fromID: maxCreditor.key, toID: maxDebtor.key, amount: transactionAmount))
                
                balances[maxDebtor.key]! -= transactionAmount
                balances[maxCreditor.key]! += transactionAmount
                
//                print("Current debt settlement: \(DebtSettlement(fromID: maxCreditor.key, toID: maxDebtor.key, amount: transactionAmount))")
                print("Updated balances: \(balances)")
            } else {
                break
            }
        }
        
        DispatchQueue.main.async {
            self.debts = debtSettlements
        }
    }
}
