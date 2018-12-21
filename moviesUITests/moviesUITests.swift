//
//  moviesUITests.swift
//  moviesUITests
//
//  Created by Ahmed Salah on 12/17/18.
//  Copyright © 2018 Ahmed Salah. All rights reserved.
//

import XCTest

class moviesUITests: XCTestCase {
        
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
        
        super.tearDown()
    }
    
    func testExpandCollapseSection() {
        
        let app = XCUIApplication()
        let allMoviesButton = app.tables/*@START_MENU_TOKEN@*/.buttons["All Movies"]/*[[".otherElements[\"All Movies\"].buttons[\"All Movies\"]",".buttons[\"All Movies\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        allMoviesButton.tap()
        XCTAssertEqual(XCUIApplication().tables.cells.count , 0)
        allMoviesButton.tap()
        XCTAssertGreaterThan(XCUIApplication().tables.cells.count , 0)

    }

    
}
