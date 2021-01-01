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
}
