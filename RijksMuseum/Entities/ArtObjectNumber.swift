//
//  ArtObjectNumber.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 1/2/21.
//

import Foundation

struct ArtObjectNumber: Hashable {
    let rawValue: String
}

extension ArtObjectNumber: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        rawValue = value
    }
}

extension ArtObjectNumber: CustomStringConvertible {
    var description: String {
        return rawValue
    }
}
