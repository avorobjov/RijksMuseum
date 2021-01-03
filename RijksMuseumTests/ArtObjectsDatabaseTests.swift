//
//  ArtObjectsDatabaseTests.swift
//  RijksMuseumTests
//
//  Created by Alexander Vorobjov on 1/3/21.
//

import XCTest
@testable import RijksMuseum

class ArtObjectsDatabaseTests: XCTestCase {
    var testURL: URL {
        try! FileManager.default
            .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("test.sqlite")

    }

    var database: Database!

    let model = ArtObject(id: ArtObjectId(stringLiteral: "identifier"),
                          objectNumber: ArtObjectNumber(stringLiteral: "object_number"),
                          title: "test title",
                          author: "test author",
                          imageURL: URL(string: "http://image.url")!,
                          detailsURL: URL(string: "http://details.url")!,
                          webURL: URL(string: "http://web.url"))

    override func setUpWithError() throws {
        database = try DatabaseImpl(databaseURL: testURL)
    }

    override func tearDownWithError() throws {
        database = nil
        try FileManager.default.removeItem(at: testURL)
    }

    func testHome() throws {
        let db = ArtObjectsDatabaseImpl(database: database)
        XCTAssertTrue(db.readHomeItems(showOutdated: false).isEmpty)

        db.saveHomeItems([model])
        let items = db.readHomeItems(showOutdated: false)
        XCTAssertEqual(items.count, 1)

        // test overwrite
        db.saveHomeItems([model])
        let items2 = db.readHomeItems(showOutdated: false)
        XCTAssertEqual(items2.count, 1)

        let converted = items2.first!
        XCTAssertEqual(model.id.rawValue, converted.id.rawValue)
        XCTAssertEqual(model.objectNumber.rawValue, converted.objectNumber.rawValue)
        XCTAssertEqual(model.title, converted.title)
        XCTAssertEqual(model.author, converted.author)
        XCTAssertEqual(model.imageURL.absoluteString, converted.imageURL.absoluteString)
        XCTAssertEqual(model.detailsURL.absoluteString, converted.detailsURL.absoluteString)
        XCTAssertEqual(model.webURL!.absoluteString, converted.webURL!.absoluteString)
    }

    func testSearch() throws {
        let db = ArtObjectsDatabaseImpl(database: database)

        XCTAssertTrue(db.searchItems(query: "test").isEmpty)

        db.saveSearchItems([model])

        let items = db.searchItems(query: "test")
        XCTAssertEqual(items.count, 1)

        // bad search
        XCTAssertEqual(db.searchItems(query: "alkfjlslaksfjdjafsd;").count, 0)

        // 0 symbols search search
        XCTAssertEqual(db.searchItems(query: "").count, 0)

        // 1 symbol search search
        XCTAssertEqual(db.searchItems(query: "a").count, 0)
    }
}
