//
//  Party.swift
//  bffPay
//
//  Created by Eugene Ned on 23.04.2023.
//

import Foundation
import FirebaseFirestoreSwift

struct Party: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var description: String?
    var currency: String
    var category: PartyCategory
    var ownerUserID: String
    var participants: [String: String] // ID: name

    enum CodingKeys: String, CodingKey {
        case id, name, description, currency, category, ownerUserID, participants
    }
}

enum PartyCategory: String, Codable, CaseIterable {
    case couple, roommates, event, project, trip, other
}

