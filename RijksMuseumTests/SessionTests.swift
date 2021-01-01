//
//  SessionTests.swift
//  RijksMuseumTests
//
//  Created by Alexander Vorobjov on 1/1/21.
//

import XCTest
@testable import RijksMuseum

class SessionTests: XCTestCase {
    struct TestObject: Codable {
        let value: String
    }

    func testPersistError_noInternetConnection() throws {
        let requiredError = SessionError.noInternetConnection
        let session = MockSession { $0(.failure(requiredError)) }

        session.fetch(TestObject.self, ArtObjectsAPI.home) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, requiredError)

            case .success:
                XCTAssert(false, "Should return noInternetConnection")
            }
        }
    }

    func testPersistError_connectionError() throws {
        let requiredError = SessionError.connectionError
        let session = MockSession { $0(.failure(requiredError)) }

        session.fetch(TestObject.self, ArtObjectsAPI.home) { result in
            switch result {
            case .failure:
                // any error is ok
                break

            case .success:
                XCTAssert(false, "Should return error")
            }
        }
    }

    func testDecode() throws {
        let obj = TestObject(value: "test")
        let data = try JSONEncoder().encode(obj)
        let session = MockSession { $0(.success(data)) }

        session.fetch(TestObject.self, ArtObjectsAPI.home) { result in
            switch result {
            case .failure:
                XCTAssert(false, "Failed to parse object")

            case .success(let parsed):
                XCTAssertEqual(parsed.value, obj.value)
            }
        }
    }

    func testDecodeFailed() throws {
        let data = "{{{invalid\":}".data(using: .utf8)!
        let session = MockSession { $0(.success(data)) }

        session.fetch(TestObject.self, ArtObjectsAPI.home) { result in
            switch result {
            case .failure:
                // any error is ok
                break

            case .success:
                XCTAssert(false, "Should return error")
            }
        }
    }

    func testEncodeKey() {
        let key = "test_api_key"
        let session = SessionImpl(key: key)

        let request = session.buildRequest(for: MockAPI.test)
        XCTAssertNotNil(request?.url)
        let components = NSURLComponents(url: request!.url!, resolvingAgainstBaseURL: true)
        XCTAssertNotNil(components)

        let query = components?.queryItems ?? []

        let param = query.first { $0.name == "key" }
        XCTAssertNotNil(param, "key parameters not added")
        XCTAssertEqual(param!.value, key)
    }
}
