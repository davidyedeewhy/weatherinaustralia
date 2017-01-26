//
//  Weather_in_AustraliaUITests.swift
//  Weather in AustraliaUITests
//
//  Created by David Ye on 23/1/17.
//  Copyright © 2017 Bestau Pty Ltd. All rights reserved.
//

import XCTest

class Weather_in_AustraliaUITests: XCTestCase {
        
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
        
        let app = XCUIApplication()

        let tablesQuery = app.tables
        tablesQuery.staticTexts["16°C"].tap()
        
        let backButton = app.navigationBars["Weather_in_Australia.CityWeatherView"].children(matching: .button).matching(identifier: "Back").element(boundBy: 0)
        backButton.tap()
        tablesQuery.staticTexts["23°C"].tap()
        backButton.tap()
        tablesQuery.staticTexts["22°C"].tap()
        backButton.tap()
        tablesQuery.staticTexts["20°C"].tap()
        backButton.tap()
        
    }
    
}
