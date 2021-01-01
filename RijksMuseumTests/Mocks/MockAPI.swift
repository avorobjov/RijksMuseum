//
//  MockAPI.swift
//  RijksMuseumTests
//
//  Created by Alexander Vorobjov on 1/2/21.
//

import Alamofire
@testable import RijksMuseum

enum MockAPI {
    static let paramName = "paramName"
    static let paramValue = "paramValue"

    case test
    case overrideDefault
}

extension MockAPI: API {
    var path: String {
        return "/api/en/collection"
    }

    var parameters: Parameters {
        switch self {
        case .test:
            return [Self.paramName: Self.paramValue]

        case .overrideDefault:
            return [
                Self.paramName: Self.paramValue,
                APITests.defaultName: APITests.defaultValue2,
            ]
        }
    }
}
