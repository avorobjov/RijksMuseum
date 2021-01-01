//
//  APITests.swift
//  RijksMuseumTests
//
//  Created by Alexander Vorobjov on 1/1/21.
//

import Alamofire
import XCTest
@testable import RijksMuseum

class APITests: XCTestCase {
    static let defaultName = "defaultName"
    static let defaultValue = "defaultValue"
    static let defaultValue2 = "defaultValue2"

    func testAsURLRequest() throws {
        let defaultParameters = [Self.defaultName: Self.defaultValue]

        let request = try MockAPI.test.asURLRequest(defaultParameters: defaultParameters)
        XCTAssertNotNil(request.url)
        let components = NSURLComponents(url: request.url!, resolvingAgainstBaseURL: true)
        XCTAssertNotNil(components)

        let query = components?.queryItems ?? []

        let param = query.first { $0.name == MockAPI.paramName }
        XCTAssertNotNil(param, "API parameters not encoded")
        XCTAssertEqual(param!.value, MockAPI.paramValue)

        let def = query.first { $0.name == Self.defaultName }
        XCTAssertNotNil(def, "default parameters not encoded")
        XCTAssertEqual(def!.value, Self.defaultValue)
    }

    func testAsURLRequest_overrideDefaults() throws {
        let defaultParameters = [Self.defaultName: Self.defaultValue]

        let request = try MockAPI.overrideDefault.asURLRequest(defaultParameters: defaultParameters)
        XCTAssertNotNil(request.url)
        let components = NSURLComponents(url: request.url!, resolvingAgainstBaseURL: true)
        XCTAssertNotNil(components)

        let query = components?.queryItems ?? []

        let def = query.first { $0.name == Self.defaultName }
        XCTAssertNotNil(def, "default parameters not overriden")
        XCTAssertEqual(def!.value, Self.defaultValue2)
    }
}
