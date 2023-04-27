//
//  PartyViewModel.swift
//  bffPay
//
//  Created by Eugene Ned on 23.04.2023.
//

import Foundation
import Combine

final class PartyViewModel: ObservableObject, Identifiable {
//    private let partyRepo = PartyRepository()
    @Published var party: Party
    
    var id = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init(party: Party) {
        self.party = party
        $party
            .compactMap { $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
}
