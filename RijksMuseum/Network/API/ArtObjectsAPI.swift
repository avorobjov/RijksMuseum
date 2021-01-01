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
    case details(id: ArtObjectId)
}

extension ArtObjectsAPI: API {
    var path: String {
        switch self {
        case .home, .search:
            return "/api/en/collection"

        case .details(let id):
            return "/api/en/collection/\(id)"
        }
    }

    var parameters: Parameters {
        switch self {
        case .search(let query):
            return ["q": query]

        default:
            return [:]
        }
    }
}