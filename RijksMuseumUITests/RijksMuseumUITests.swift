//
//  RijksMuseumUITests.swift
//  RijksMuseumUITests
//
//  Created by Alexander Vorobjov on 12/31/20.
//

import XCTest

class RijksMuseumUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHomeStart() throws {
        XCTAssert(app.navigationBars["main.navbar"].exists)
        XCTAssert(app.searchFields["home.searchbar"].exists)
        XCTAssert(app.collectionViews["home.collection"].exists)

        XCTAssert(app.navigationBars["main.navbar"].staticTexts["Home"].exists)
        XCTAssertEqual(app.searchFields["home.searchbar"].placeholderValue, "Search")

        let cell = app.collectionViews["home.collection"].cells.firstMatch
        XCTAssert(cell.waitForExistence(timeout: 10))
        XCTAssert(cell.staticTexts["cell.title"].exists)
        XCTAssert(cell.staticTexts["cell.author"].exists)
        XCTAssert(cell.images["cell.image"].exists)

        XCTAssert(!cell.staticTexts["cell.title"].label.isEmpty)
        XCTAssert(!cell.staticTexts["cell.author"].label.isEmpty)
    }

    func testOpenDetails() {
        let cell = app.collectionViews["home.collection"].cells.firstMatch
        XCTAssert(cell.waitForExistence(timeout: 10))

        let title = cell.staticTexts["cell.title"].label
        cell.tap()

        // navigation title equals cell title
        XCTAssert(app.navigationBars["main.navbar"].staticTexts[title].exists)

        XCTAssert(app.textViews["details.text"].exists)
        XCTAssert(!(app.textViews["details.text"].value as! String).isEmpty)
    }

    func testSearch() {
        let cell = app.collectionViews["home.collection"].cells.firstMatch
        XCTAssert(cell.waitForExistence(timeout: 10))

        app.searchFields["home.searchbar"].tap()
        app.searchFields["home.searchbar"].typeText("Rembrandt")

        // search results should update
        XCTAssert(app.staticTexts["Rembrandt van Rijn"].waitForExistence(timeout: 10))
    }
}
