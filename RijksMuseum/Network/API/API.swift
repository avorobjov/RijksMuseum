//
//  API.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 1/1/21.
//

import Alamofire

protocol API {
    var baseURL: URL { get }
    var path: String { get }
    var method: Alamofire.HTTPMethod { get }
    var parameters: Alamofire.Parameters { get }
    var headers: Alamofire.HTTPHeaders? { get }

    func asURLRequest(defaultParameters: Alamofire.Parameters) throws -> URLRequest
}

extension API {
    var baseURL: URL {
        // swiftlint:disable:next force_unwrapping
        return URL(string: "https://www.rijksmuseum.nl/")!
    }

    var method: Alamofire.HTTPMethod {
        return .get
    }

    var headers: Alamofire.HTTPHeaders? {
        return ["content-type": "application/json"]
    }
}

// MARK: - asURLRequest implementation
extension API {
    func asURLRequest(defaultParameters: Alamofire.Parameters) throws -> URLRequest {
        guard let url = URL(string: path, relativeTo: baseURL) else {
            throw SessionError.badRequest
        }

        var extendedParameters = defaultParameters
        parameters.forEach { key, value in
            extendedParameters[key] = value
        }

        let request = try URLRequest(url: url, method: method, headers: headers)
        return try URLEncoding.default.encode(request, with: extendedParameters)
    }
}
