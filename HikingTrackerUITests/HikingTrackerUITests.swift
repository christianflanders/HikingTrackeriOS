//
//  HikingTrackerUITests.swift
//  HikingTrackerUITests
//
//  Created by Christian Flanders on 12/4/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import XCTest

class HikingTrackerUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.

     


        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }


    func testSignUpScreen() {

        let app = XCUIApplication()
        let element = app.otherElements.containing(.image, identifier:"Topo map").children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element
        let textField = element.children(matching: .other).element(boundBy: 0).children(matching: .other).element(boundBy: 0).children(matching: .textField).element
        textField.tap()
        textField.typeText("Chri")
        app/*@START_MENU_TOKEN@*/.otherElements["Christian"]/*[[".keyboards",".otherElements[\"Typing Predictions\"].otherElements[\"Christian\"]",".otherElements[\"Christian\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        element.children(matching: .other).element(boundBy: 1).buttons["Not Set"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.typeText("\n")
        app/*@START_MENU_TOKEN@*/.pickerWheels["100"]/*[[".pickers.pickerWheels[\"100\"]",".pickerWheels[\"100\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        app/*@START_MENU_TOKEN@*/.pickerWheels["117"]/*[[".pickers.pickerWheels[\"117\"]",".pickerWheels[\"117\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        app/*@START_MENU_TOKEN@*/.pickerWheels["130"]/*[[".pickers.pickerWheels[\"130\"]",".pickerWheels[\"130\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        app/*@START_MENU_TOKEN@*/.pickerWheels["131"].press(forDuration: 1.1);/*[[".pickers.pickerWheels[\"131\"]",".tap()",".press(forDuration: 1.1);",".pickerWheels[\"131\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/

        let doneButton = app.buttons["Done"]
        doneButton.tap()
        element.children(matching: .other).element(boundBy: 2).buttons["Not Set"].tap()
        app/*@START_MENU_TOKEN@*/.pickerWheels["5"]/*[[".pickers.pickerWheels[\"5\"]",".pickerWheels[\"5\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        app/*@START_MENU_TOKEN@*/.pickerWheels["19"]/*[[".pickers.pickerWheels[\"19\"]",".pickerWheels[\"19\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        app/*@START_MENU_TOKEN@*/.pickerWheels["34"]/*[[".pickers.pickerWheels[\"34\"]",".pickerWheels[\"34\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        app/*@START_MENU_TOKEN@*/.pickerWheels["44"]/*[[".pickers.pickerWheels[\"44\"]",".pickerWheels[\"44\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()

        let pickerWheel = app/*@START_MENU_TOKEN@*/.pickerWheels["42"]/*[[".pickers.pickerWheels[\"42\"]",".pickerWheels[\"42\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        pickerWheel.swipeUp()
        pickerWheel.swipeDown()
        
        let decemberPickerWheel = app.datePickers.pickerWheels["December"]
        decemberPickerWheel/*@START_MENU_TOKEN@*/.press(forDuration: 0.7);/*[[".tap()",".press(forDuration: 0.7);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        doneButton.tap()
        element.children(matching: .other).element(boundBy: 3).buttons["Not Set"].tap()
        decemberPickerWheel.swipeDown()
        doneButton.tap()
        app.buttons["Not Set"].tap()
        app/*@START_MENU_TOKEN@*/.pickerWheels["Male"].press(forDuration: 1.4);/*[[".pickers.pickerWheels[\"Male\"]",".tap()",".press(forDuration: 1.4);",".pickerWheels[\"Male\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
        doneButton.tap()
        app.buttons["Save"].tap()
        app.alerts["Allow “HikingTracker” to access your location?"].buttons["Always Allow"].tap()

        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Turn All Categories On"]/*[[".cells.staticTexts[\"Turn All Categories On\"]",".staticTexts[\"Turn All Categories On\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Health Access"].buttons["Allow"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Enter your email"]/*[[".cells[\"EmailCellAccessibilityID\"].textFields[\"Enter your email\"]",".textFields[\"Enter your email\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.textFields.containing(.button, identifier:"Clear text").element/*[[".cells[\"EmailCellAccessibilityID\"].textFields.containing(.button, identifier:\"Clear text\").element",".textFields.containing(.button, identifier:\"Clear text\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.typeText("shredflanders@me.co")
        app.typeText("m")
        app.navigationBars["Sign in"].buttons["Sign in"].tap()


    }
}
