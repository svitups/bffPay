//
//  TransactionRepository.swift
//  bffPay
//
//  Created by Eugene Ned on 27.04.2023.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebasePerformance
import Combine

class TransactionRepository: ObservableObject {
    
    private let store = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isLoading = false
    @Published var transactions: [Transaction] = []
    
    private let authService = AuthService()
    
    private let partyID: String
    
    init(partyID: String) {
        self.partyID = partyID
    }
    
    func get(partyID: String) {
        let trace = Performance.startTrace(name: "TransactionRepository: fetch all transactions for the party")
        isLoading = true
        store.collection("parties").document(partyID).collection("transactions")
            .addSnapshotListener { querySnapshot, error in
                defer {
                    trace?.stop()
                }
                
                if let error = error {
                    print("Error getting transactions: \(error.localizedDescription)")
                    return
                }
                guard let documents = querySnapshot?.documents else { return }
                
                self.transactions = documents.compactMap { document -> Transaction? in
                    return try? document.data(as: Transaction.self)
                }
                self.transactions.sort(by: {
                    $0.date > $1.date
                })
                
                self.isLoading = false
            }
    }
    
    func create(_ transaction: Transaction, completion: @escaping () -> Void) {
        do {
            try store.collection("parties").document(partyID).collection("transactions").addDocument(from: transaction) { error in
                if let error = error {
                    print("Error adding transaction: \(error.localizedDescription)")
                } else {
                    completion()
                }
            }
        } catch {
            print("Unable to create transaction: \(error.localizedDescription)")
        }
    }
    
    func update(_ transaction: Transaction, completion: @escaping () -> Void) {
        guard let transactionID = transaction.id else { return }
        
        do {
            try store.collection("parties").document(partyID).collection("transactions").document(transactionID).setData(from: transaction) { error in
                if let error = error {
                    print("Error updating transaction: \(error.localizedDescription)")
                } else {
                    completion()
                }
            }
        } catch {
            print("Unable to update transaction: \(error.localizedDescription)")
        }
    }
    
    func delete(_ transactionID: String, completion: @escaping () -> Void) {        
        store.collection("parties").document(partyID).collection("transactions").document(transactionID).delete { error in
            if let error = error {
                print("Error deleting transaction: \(error.localizedDescription)")
            } else {
                completion()
            }
        }
    }
}

