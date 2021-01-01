//
//  ArtObjectJSONTests.swift
//  RijksMuseumTests
//
//  Created by Alexander Vorobjov on 12/31/20.
//

import XCTest
@testable import RijksMuseum

class ArtObjectJSONTests: XCTestCase {
    static let identifier = "identifier"
    static let title = "test object title"
    static let author = "test author"
    static let detailsURL = "http://details.url/"
    static let webURL = "http://web.url/"
    static let imageURL = "http://image.url/"

    func testMinimal() throws {
        let json = createJson(title: nil, author: nil, web: nil)
        let model = json.toModel()
        XCTAssertNotNil(model)

        XCTAssertEqual(model!.id.rawValue, Self.identifier)
        XCTAssertEqual(model!.title, "")
        XCTAssertEqual(model!.author, "")
        XCTAssertEqual(model!.detailsURL.absoluteString, Self.detailsURL)
        XCTAssertEqual(model!.imageURL.absoluteString, Self.imageURL)
        XCTAssertNil(model!.webURL)
    }

    func testFull() {
        let json = createJson()
        let model = json.toModel()
        XCTAssertNotNil(model)

        XCTAssertEqual(model!.id.rawValue, Self.identifier)
        XCTAssertEqual(model!.title, Self.title)
        XCTAssertEqual(model!.author, Self.author)
        XCTAssertEqual(model!.detailsURL.absoluteString, Self.detailsURL)
        XCTAssertEqual(model!.imageURL.absoluteString, Self.imageURL)
        XCTAssertEqual(model!.webURL?.absoluteString, Self.webURL)
    }

    func testOptionalParameters() {
        XCTAssertNil(createJson(id: "").toModel())
        XCTAssertNotNil(createJson(title: nil).toModel())
        XCTAssertNotNil(createJson(author: nil).toModel())
        XCTAssertNil(createJson(details: nil).toModel())
        XCTAssertNotNil(createJson(web: nil).toModel())
        XCTAssertNil(createJson(image: nil).toModel())
    }

    // MARK: - Helpers
    func createJson(id: String = identifier, title: String? = title, author: String? = author,
                    details: String? = detailsURL, web: String? = webURL, image: String? = imageURL) -> ArtObjectJSON
    {
        return ArtObjectJSON(id: id, title: title, principalOrFirstMaker: author,
                             links: ArtObjectJSON.Links(details: details, web: web),
                             webImage: ArtObjectJSON.Image(url: image))
    }
}
