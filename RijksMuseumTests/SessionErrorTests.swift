//
//  SessionErrorTests.swift
//  RijksMuseumTests
//
//  Created by Alexander Vorobjov on 12/31/20.
//

import Alamofire
@testable import RijksMuseum
import XCTest

class SessionErrorTests: XCTestCase {
    func test_URLError_noInternetConnection() throws {
        let error = URLError(.notConnectedToInternet)
        let converted = SessionError(error)
        XCTAssertEqual(converted, .noInternetConnection)
    }

    func test_URLError_connectionError() throws {
        let error = URLError(.callIsActive) // any other error
        let converted = SessionError(error)
        XCTAssertEqual(converted, .connectionError)
    }

    func test_AFError_noInternetConnection() throws {
        let error = AFError.sessionTaskFailed(error: URLError(.notConnectedToInternet))
        let converted = SessionError(error)
        XCTAssertEqual(converted, .noInternetConnection)
    }

    func test_AFError_connectionError() throws {
        let error = AFError.invalidURL(url: "url")
        let converted = SessionError(error)
        XCTAssertEqual(converted, .connectionError)
    }
}
