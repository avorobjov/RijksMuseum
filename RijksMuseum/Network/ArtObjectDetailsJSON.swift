//
//  ArtObjectDetailsJSON.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 1/2/21.
//

import Foundation

struct ArtObjectDetailsJSON: Decodable {
    let id: String

    let title: String?
    let longTitle: String?
    let subTitle: String?
    let scLabelLine: String?
    let copyrightHolder: String?

    let acquisition: Acquisition?

    struct Acquisition: Decodable {
        let creditLine: String?
    }
}

extension ArtObjectDetailsJSON {
    func toModel() -> ArtObjectDetails? {
        if id.isEmpty {
            return nil
        }

        return ArtObjectDetails(
            id: ArtObjectId(stringLiteral: id),
            title: title,
            size: subTitle,
            authorYearMaterial: scLabelLine,
            credit: acquisition?.creditLine,
            copyright: copyrightHolder)
    }
}
