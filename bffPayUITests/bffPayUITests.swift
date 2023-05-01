//
//  bffPayUITests.swift
//  bffPayUITests
//
//  Created by Eugene Ned on 01.05.2023.
//

import XCTest

final class bffPayUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCreateParty() throws {
        let app = XCUIApplication()
        app.launch()
        
        let partyName = "UI Test Party"
        let partyDescription = "UITest desc"
        let partyCurrency = "UAH"
        
        // Tap add party button
        app.buttons["plusButton"].tap()
        
        // Enter party name
        app.textFields["partyNameTextField"].tap()
        app.textFields["partyNameTextField"].typeText(partyName)
        
        app.textFields["partyDescriptionTextField"].tap()
        app.textFields["partyDescriptionTextField"].typeText(partyDescription)
        
        app.textFields["partyCurrencyTextField"].tap()
        app.textFields["partyCurrencyTextField"].typeText(partyCurrency)
        
        // Tap create button
        app.buttons["createPartyButton"].tap()
        
        // Check if party was added to the list
        XCTAssertTrue(app.staticTexts[partyName].exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
