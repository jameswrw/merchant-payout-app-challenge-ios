//
//  HomeScreenUITest.swift
//  ios-interviewTests
//
//  Created by James Weatherley on 28/10/2026.
//

import XCTest

final class HomeScreenUITest: XCTestCase {

    func testNavigationFromHomeScreenToPayoutScreen() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        let sendPayoutButton = app.buttons["sendPayout"]
        sleep(2)
        XCTAssert(sendPayoutButton.exists)
        sendPayoutButton.tap()
        
        let continueButton = app.buttons["continue"]
        XCTAssert(continueButton.exists)
        XCTAssertFalse(continueButton.isEnabled)

        let amountTextField = app.textFields["amount"]
        XCTAssert(amountTextField.exists)
        amountTextField.tap()
        if let stringValue = amountTextField.value as? String {
            let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
            amountTextField.typeText(deleteString)
        }
        amountTextField.typeText("1234")
        
        let ibanTextField = app.textFields["iban"]
        XCTAssert(ibanTextField.exists)
        ibanTextField.tap()
        ibanTextField.typeText("GB29NWBK60161331926819")
        
        XCTAssertTrue(continueButton.isEnabled)
    }
}
