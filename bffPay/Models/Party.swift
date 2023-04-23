//
//  Party.swift
//  bffPay
//
//  Created by Eugene Ned on 23.04.2023.
//

import Foundation
import FirebaseFirestoreSwift

struct Party: Codable {
    @DocumentID var id: String?
    var name: String
    var description: String?
    var currency: String
    var category: Category
    var ownerUserID: String
    var participantIDs: [String]

    enum CodingKeys: String, CodingKey {
        case id, name, description, currency, category, ownerUserID, participantIDs
    }
}

enum Category: String, Codable {
    case couple, sharedHouse = "Shared House", event, project, trip, other
}

