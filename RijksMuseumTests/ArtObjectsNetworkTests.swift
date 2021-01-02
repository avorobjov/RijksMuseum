//
//  ArtObjectsNetworkTests.swift
//  RijksMuseumTests
//
//  Created by Alexander Vorobjov on 1/2/21.
//

import XCTest
@testable import RijksMuseum

class ArtObjectsNetworkTests: XCTestCase {
    func testEmpty() throws {
        let session = try MockSession(json: "empty_art_objects")
        let network = ArtObjectsNetworkImpl(session: session)

        network.fetchHome { result in
            switch result {
            case .failure:
                XCTAssert(false, "Failed to parse response")

            case .success(let response):
                XCTAssertTrue(response.isEmpty)
            }
        }

        network.fetchSearch(query: "any") { result in
            switch result {
            case .failure:
                XCTAssert(false, "Failed to parse response")

            case .success(let response):
                XCTAssertTrue(response.isEmpty)
            }
        }
    }

    func testSingle() throws {
        let session = try MockSession(json: "single_art_object")
        let network = ArtObjectsNetworkImpl(session: session)

        network.fetchHome { result in
            switch result {
            case .failure:
                XCTAssert(false, "Failed to parse response")

            case .success(let response):
                XCTAssertEqual(response.count, 1)
            }
        }

        network.fetchSearch(query: "any") { result in
            switch result {
            case .failure:
                XCTAssert(false, "Failed to parse response")

            case .success(let response):
                XCTAssertEqual(response.count, 1)
            }
        }
    }

    func testError() throws {
        let requiredError = SessionError.connectionError
        let session = MockSession { $0(.failure(requiredError)) }
        let network = ArtObjectsNetworkImpl(session: session)

        network.fetchHome { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, requiredError)

            case .success:
                XCTAssert(false, "Should return error")
            }
        }

        network.fetchSearch(query: "any") { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, requiredError)

            case .success:
                XCTAssert(false, "Should return error")
            }
        }
    }

    func testDetails() throws {
        let session = try MockSession(json: "details_night_watch")
        let network = ArtObjectsNetworkImpl(session: session)

        network.fetchDetails(id: ArtObjectId(stringLiteral: "-")) { result in
            switch result {
            case .failure:
                XCTAssert(false, "Failed to parse response")

            case .success(let response):
                XCTAssertEqual(response.id, "en-SK-C-5")
                XCTAssertEqual(response.title, "Night Watch, Militia Company of District II under the Command of Captain Frans Banninck Cocq")
                XCTAssertEqual(response.credit, "On loan from the City of Amsterdam")
                XCTAssertEqual(response.size, "h 379.5cm × w 453.5cm × w 337kg")
                XCTAssertEqual(response.authorYearMaterial, "Rembrandt van Rijn (1606-1669), oil on canvas, 1642")
                XCTAssertEqual(response.copyright, "test copyrightHolder")
            }
        }
    }
}
