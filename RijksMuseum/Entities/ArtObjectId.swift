//
//  ArtObjectId.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 1/2/21.
//

import Foundation

struct ArtObjectId: Hashable {
    let rawValue: String
}

extension ArtObjectId: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        rawValue = value
    }
}

extension ArtObjectId: CustomStringConvertible {
    var description: String {
        return rawValue
    }
}
