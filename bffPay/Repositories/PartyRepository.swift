//
//  PartyRepository.swift
//  bffPay
//
//  Created by Eugene Ned on 23.04.2023.
//

//import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebasePerformance
import Combine

class PartyRepository: ObservableObject {
//    static let shared = PartyRepository()
    
    private let path = "parties"
    private let store = Firestore.firestore()
    
    @Published var isLoading = true
    @Published var parties: [Party] = []
    
    var userID = ""
    
    private let authService = AuthService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        authService.$user
            .compactMap { user in
                user?.uid
            }
            .assign(to: \.userID, on: self)
            .store(in: &cancellables)
        
        authService.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.get()
            }
            .store(in: &cancellables)
    }
    
    func get() {
        let trace = Performance.startTrace(name: "PartiesRepository: fetch all parties for the user")
        isLoading = true
        store.collection(path)
            .whereField("ownerUserID", isEqualTo: userID)
            .addSnapshotListener { querySnapshot, error in
                defer {
                    trace?.stop()
                }
                
                if let error = error {
                    print("Error getting parties: \(error.localizedDescription)")
                    return
                }
                guard let documents = querySnapshot?.documents else { return }
                
                self.parties = documents.compactMap { document -> Party? in
                    return try? document.data(as: Party.self)
                }
                //                self.parties.sort(by: {
                //                    $0.date > $1.date
                //                })
                
                self.isLoading = false
            }
    }
    
    func create(_ party: Party, completion: @escaping () -> Void) {
        do {
            var newParty = party
            newParty.ownerUserID = userID
            try store.collection(path).addDocument(from: newParty) { _ in
                completion()
            }
        } catch {
                print("Unable to create party: \(error.localizedDescription)")
        }
    }
    
    func update(_ party: Party, completion: @escaping () -> Void) {
        guard let partyID = party.id else { return }
        
        do {
            try store.collection(path).document(partyID).setData(from: party) { _ in
                completion()
            }
        } catch {
            print("Unable to update party: \(error.localizedDescription)")
        }
    }
    
    func delete(_ party: Party, completion: @escaping () -> Void) {
        guard let partyID = party.id else { return }
        
        store.collection(path).document(partyID).delete { error in
            if let error = error {
                print("Unable to update party: \(error.localizedDescription)")
            }
            completion()
        }
    }
}
