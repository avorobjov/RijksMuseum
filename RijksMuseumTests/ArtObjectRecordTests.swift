//
//  ArtObjectRecordTests.swift
//  RijksMuseumTests
//
//  Created by Alexander Vorobjov on 1/2/21.
//

import XCTest
@testable import RijksMuseum

class ArtObjectRecordTests: XCTestCase {
    func testConvert() {
        let model = ArtObject(id: ArtObjectId(stringLiteral: "identifier"),
                              objectNumber: ArtObjectNumber(stringLiteral: "object_number"),
                              title: "test title",
                              author: "test author",
                              imageURL: URL(string: "http://image.url")!,
                              detailsURL: URL(string: "http://details.url")!,
                              webURL: URL(string: "http://web.url"))
        let record = ArtObjectRecord(model, isHomeItem: true)
        let converted = record.toModel()
        XCTAssertNotNil(converted)

        XCTAssertEqual(model.id.rawValue, converted!.id.rawValue)
        XCTAssertEqual(model.objectNumber.rawValue, converted!.objectNumber.rawValue)
        XCTAssertEqual(model.title, converted!.title)
        XCTAssertEqual(model.author, converted!.author)
        XCTAssertEqual(model.imageURL.absoluteString, converted!.imageURL.absoluteString)
        XCTAssertEqual(model.detailsURL.absoluteString, converted!.detailsURL.absoluteString)
        XCTAssertEqual(model.webURL!.absoluteString, converted!.webURL!.absoluteString)
    }
}
