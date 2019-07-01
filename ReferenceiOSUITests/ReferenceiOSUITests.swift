//
//  ReferenceiOSUITests.swift
//  ReferenceiOSUITests
//
//  Created by Dunya Kirkali on 27/03/2019.
//  Copyright © 2019 ABN AMRO. All rights reserved.
//

import XCTest

class ReferenceiOSUITests: XCTestCase {
    
    // Create a short named constant for the application object
    let app = XCUIApplication()
    
    // Create a variable for the label text
    var label = ""

    override func setUp() {
        // Set up the tests to continue after one failed test
        continueAfterFailure = true
        
        // Launch the actual application
        app.launch()
    }
    
    override func recordFailure(withDescription description: String, inFile filePath: String, atLine lineNumber: Int, expected: Bool) {
        add(XCTAttachment(screenshot: XCUIScreen.main.screenshot()))
        super.recordFailure(withDescription: description, inFile: filePath, atLine: lineNumber, expected: expected)
    }
    
    /// Test the initial layout of the application
    func testInitialLayout() {
        
        // Assert the text "Hello" is displayed
        assertTextExists(text: "Hello!!")
        
        // Assert the button title equals the text "Button"
        assertButtonWithTextExists(buttonString: "Button")
    }

    /// Test that tapping the generate button generated a random value that is displayed on the text label
    func testGenerateValue() {

        // Tap the button with the ID "generateButton" - ID added in the Main.storyboard
        tapButton(withString: "generateButton")

        // Store the current value String value of the label in the label variable
        label = app.staticTexts.element(matching:.staticText, identifier: "label").label

        // Assert that the label contains a "€" character
        assertLabelContains(label: "label", contains: "€")

        // Assert that the label does not contain the text "Hello"
        XCTAssertNotEqual(label, "Hello")
    }

    /// Test that the label value remains when pushing the app to the background
    func testPersistenceInBackground() {

        // Tap the button with ID "generateButton"
        tapButton(withString: "generateButton")

        // Tap the Home button to push the app to the background
        XCUIDevice.shared.press(.home)

        // Relaunch the app
        app.activate()

        // Store the current value String value of the label in the label variable
        label = app.staticTexts.element(matching:.staticText, identifier: "label").label

        // Assert that the label contains a "€" character
        assertLabelContains(label: "label", contains: "€")

        // Assert that the label does not contain the text "Hello"
        XCTAssertNotEqual(label, "Hello")
    }

    /// Test that the label value resets to "Hello" when terminating and restarting the app
    func testPersistenceWhenTerminating() {
        // Tap the button with ID "generateButton"
        tapButton(withString: "generateButton")

        // Terminate the app
        app.terminate()

        // Relaunch the app
        app.launch()

        // Store the current value String value of the label in the label variable
        label = app.staticTexts.element(matching:.staticText, identifier: "label").label

        // Assert the text "Hello" is displayed
        assertTextExists(text: "Hello")
    }
}


// Frequently used functions that are easier to use and easier to maintain
extension XCTest {
    
    /// Assert that the specified text is displayed
    ///
    /// - Parameter text: The full text that will be searched for
    func assertTextExists(text: String) {
        XCTAssert(XCUIApplication().staticTexts["\(text)"].exists, "\(text) does not exist!")
    }
    
    /// Asserts that a button with a text exists
    ///
    /// - Parameter text: Text displayed on the button
    func assertButtonWithTextExists(buttonString: String) {
        XCTAssert(XCUIApplication().buttons["\(buttonString)"].exists, "\(buttonString) does not exist!")
    }
    
    /// Assert that a label contains a certain text
    ///
    /// - Parameters:
    ///   - label: Identifier for the label
    ///   - queryString: The full string that will be searched for
    func assertLabelContains(label: String, contains queryString: String) {
        XCTAssert(XCUIApplication().staticTexts.matching(NSPredicate(format: "\(label) CONTAINS '\(queryString)'")).element(boundBy: 0).exists)
    }
    
    /// Tap the specified button
    ///
    /// - Parameter buttonString: searched first for Identifier, then for button text
    func tapButton(withString buttonString: String) {
        XCUIApplication().buttons["\(buttonString)"].tap()
    }
}
