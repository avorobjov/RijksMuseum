//
//  ArtObject.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 12/31/20.
//

import Foundation

struct ArtObject {
    let id: ArtObjectId
    let title: String
    let author: String

    let imageURL: URL

    let detailsURL: URL
    let webURL: URL?
}
