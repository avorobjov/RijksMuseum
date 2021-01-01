//
//  ArtObjectJSON.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 12/31/20.
//

import Foundation

struct ArtObjectJSON: Decodable {
    let id: String
    let title: String?
    let principalOrFirstMaker: String?

    let links: Links
    let webImage: Image

    // MARK: - Utility types

    struct Links: Decodable {
        let details: String?
        let web: String?

        // swiftlint:disable:next nesting
        enum CodingKeys: String, CodingKey {
            case details = "self"   // rename key for convenience
            case web
        }
    }

    struct Image: Decodable {
        let url: String?
    }
}

extension ArtObjectJSON {
    func toModel() -> ArtObject? {
        guard
            let detailsURL = links.details.flatMap({ URL(string: $0) }),
            let imageURL = webImage.url.flatMap({ URL(string: $0) })
        else {
            return nil
        }

        if id.isEmpty {
            return nil
        }

        let webURL = links.web.flatMap { URL(string: $0) }

        return ArtObject(id: ArtObjectId(stringLiteral: id),
                         title: title ?? "",
                         author: principalOrFirstMaker ?? "",
                         imageURL: imageURL,
                         detailsURL: detailsURL,
                         webURL: webURL)
    }
}
