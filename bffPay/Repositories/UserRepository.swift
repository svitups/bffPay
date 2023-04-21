//
//  UserRepository.swift
//  bffPay
//
//  Created by Eugene Ned on 21.04.2023.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class UserRepository: ObservableObject {

    static var shared = UserRepository()

    private let path: String = "usersInfo"
    private let store = Firestore.firestore()

    @Published var userInfo: UserInfo?

    var userId = ""

    private let authService = AuthService()
    private var cancellables: Set<AnyCancellable> = []

    private init() {
        authService.$user
            .compactMap { user in
                user?.uid
            }
            .assign(to: \.userId, on: self)
            .store(in: &cancellables)

        authService.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.get()
            }
            .store(in: &cancellables)
    }

    func get() {
        store.collection(path)
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error getting cards: \(error.localizedDescription)")
                    return
                }

                guard let document = querySnapshot?.documents.first else {
                    return
                }
                self.userInfo = try? document.data(as: UserInfo.self)
            }
    }

    func isExist(with userId: String, completion: @escaping (Result<UserInfo?, Error>) -> Void) {
        store.collection(path)
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error getting cards: \(error.localizedDescription)")
                    completion(.failure(error))
                }
                guard let document = querySnapshot?.documents.first else {
                    completion(.success(nil))
                    return
                }

                do {
                    let userInfo = try document.data(as: UserInfo.self)
                    completion(.success(userInfo))
                } catch {
                    completion(.failure(error))
                }

            }
    }

    func add(_ user: UserInfo) {
        do {
            var newUser = user
            newUser.id = userId
            _ = try store.collection(path).addDocument(from: newUser)
        } catch {
            print("Unable to add user: \(error.localizedDescription).")
        }
    }
}
