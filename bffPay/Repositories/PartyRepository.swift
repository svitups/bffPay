//
//  PartyRepository.swift
//  bffPay
//
//  Created by Eugene Ned on 23.04.2023.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebasePerformance
import Combine

class PartyRepository: ObservableObject {
    
    static var shared = PartyRepository()
    
    private let path = "parties"
    private let store = Firestore.firestore()
    
    @Published var isLoading = true
    @Published var parties: [Party] = []
    
    var userID = ""
    
    private let authService = AuthService()
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
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
    
    // MARK: Basic methods
    
    func get() {
        let trace = Performance.startTrace(name: "PartiesRepository: fetch all parties for the user")
        isLoading = true
        store.collection(path)
            .whereField(FieldPath(["participants", userID]), isGreaterThanOrEqualTo: "")
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
    
    // MARK: Custom methods
    
    func getNameOfUser(withID userID: String, in partyID: String) -> String? {
        if let currentParty = parties.first(where: { $0.id == partyID && $0.participants.keys.contains(userID) }) {
            return currentParty.participants[userID]
        }
        return nil
    }
    
    func joinParty(with partyID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard !partyID.isEmpty, !userID.isEmpty else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Empty partyID or userID"])))
            return
        }
        
        let partyDocumentReference = store.collection(path).document(partyID)
        
        // Retrieve the party document
        partyDocumentReference.getDocument { [weak self] documentSnapshot, error in
            if let error = error {
                print("Error joining party: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            if let document = documentSnapshot, document.exists {
                if var party = try? document.data(as: Party.self) {
                    // Check if the user is already a participant
                    if party.participants.keys.contains(self?.userID ?? "") {
                        print("User is already a participant in the party.")
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User is already a participant in the party"])))
                        return
                    }
                    
                    // Retrieve user's display name
                    self?.authService.$user
                        .compactMap { user in
                            user?.displayName
                        }
                        .sink { displayName in
                            // Add the current user and their display name to the participants field
                            party.participants[self?.userID ?? ""] = displayName
                            
                            // Update the party using the existing method
                            self?.update(party) {
                                completion(.success(()))
                            }
                        }
                        .store(in: &self!.cancellables)
                }
            } else {
                print("Party not found.")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Party not found"])))
            }
        }
    }
    
}
