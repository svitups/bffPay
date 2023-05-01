//
//  bffPayTests.swift
//  bffPayTests
//
//  Created by Eugene Ned on 01.05.2023.
//

import XCTest
@testable import bffPay

final class bffPayTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateParty() throws {
        // Arrange
        let partyListVM = PartyListViewModel()
        let expectedPartyName = "Unit Test Party"
        let party = Party(name: expectedPartyName,
                          description: "Description ....",
                          currency: "USD",
                          category: .roommates,
                          ownerUserID: UserRepository.shared.userId,
                          participants: [UserRepository.shared.userId: UserRepository.shared.userInfo?.displayName ?? "No name"])
        
        // Act
        partyListVM.add(party) {
            // Assert
            XCTAssertEqual(partyListVM.partyViewModels.first?.party.name, expectedPartyName)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
