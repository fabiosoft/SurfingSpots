//
//  NeatoSurfingSpotsUITests.swift
//  NeatoSurfingSpotsUITests
//
//  Created by Fabio Nisci on 25/03/22.
//

import XCTest

class NeatoSurfingSpotsUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_title() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        let surfingSpotsStaticTitle = app.navigationBars["Surfing Spots"]
        XCTAssertTrue(surfingSpotsStaticTitle.exists)
    }

    func test_tbItems() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        let tbCells = app.tables.cells
        XCTAssertTrue(tbCells.count > 1)
    }
}
