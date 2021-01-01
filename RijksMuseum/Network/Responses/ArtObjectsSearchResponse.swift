//
//  ArtObjectsSearchResponse.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 1/2/21.
//

import Foundation

struct ArtObjectsSearchResponse: Decodable {
    let artObjects: [ArtObjectJSON]
}
