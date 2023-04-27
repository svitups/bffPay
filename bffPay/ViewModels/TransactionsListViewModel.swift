//
//  TransactionsListViewModel.swift
//  bffPay
//
//  Created by Eugene Ned on 27.04.2023.
//

import Combine

class TransactionsListViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    private var cancellables = Set<AnyCancellable>()
    private let transactionsRepo: TransactionRepository

    init(partyID: String) {
        self.transactionsRepo = TransactionRepository(partyID: partyID)
        transactionsRepo.$transactions
            .assign(to: \.transactions, on: self)
            .store(in: &cancellables)

        transactionsRepo.get(partyID: partyID)
    }
    
    func create(_ transaction: Transaction, completion: @escaping () -> Void) {
        transactionsRepo.create(transaction) {
            completion()
        }
    }
    
    func update(_ transaction: Transaction, completion: @escaping () -> Void) {
        transactionsRepo.update(transaction) {
            completion()
        }
    }
    
    func delete(_ transactionID: String, completion: @escaping () -> Void) {
        transactionsRepo.delete(transactionID) {
            completion()
        }
    }
}
