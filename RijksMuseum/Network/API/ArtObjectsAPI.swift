//
//  ArtObjectsAPI.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 1/1/21.
//

import Alamofire

enum ArtObjectsAPI {
    case home
    case search(query: String)
    case details(objectNumber: ArtObjectNumber)
}

extension ArtObjectsAPI: API {
    var path: String {
        switch self {
        case .home, .search:
            return "/api/en/collection"

        case .details(let objectNumber):
            return "/api/en/collection/\(objectNumber)"
        }
    }

    var parameters: Parameters {
        switch self {
        case .home:
            return [
                "toppieces": "True",
                "imgonly": "True",
                "ps": Constants.defaultPageSize,
            ]

        case .search(let query):
            return [
                "q": query,
                "imgonly": "True",
                "ps": Constants.defaultPageSize,
            ]

        default:
            return [:]
        }
    }
}
