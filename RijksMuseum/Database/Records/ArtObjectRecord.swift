//
//  ArtObjectRecord.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 1/2/21.
//

import GRDB

struct ArtObjectRecord {
    let id: String
    let objectNumber: String
    let title: String
    let author: String
    let imageURL: String
    let detailsURL: String
    let webURL: String?
    let isHomeItem: Bool
    let fetchDate: Date
}

extension ArtObjectRecord: Codable {
}

extension ArtObjectRecord: FetchableRecord, PersistableRecord, TableRecord {
    public static let databaseTableName = "art_objects"

    enum Columns: String, ColumnExpression {
        case id, objectNumber, title, author, imageURL, detailsURL, webURL, isHomeItem, fetchDate
    }
}

// MARK: - Convertors
extension ArtObjectRecord {
    init(_ model: ArtObject, isHomeItem: Bool, fetchDate: Date = Date()) {
        id = model.id.rawValue
        objectNumber = model.objectNumber.rawValue
        title = model.title
        author = model.author
        imageURL = model.imageURL.absoluteString
        detailsURL = model.detailsURL.absoluteString
        webURL = model.webURL?.absoluteString
        self.isHomeItem = isHomeItem
        self.fetchDate = fetchDate
    }

    func toModel() -> ArtObject? {
        guard
            let image = URL(string: imageURL),
            let details = URL(string: detailsURL)
        else {
            return nil
        }

        let web = webURL.flatMap { URL(string: $0) }

        return ArtObject(
            id: ArtObjectId(stringLiteral: id),
            objectNumber: ArtObjectNumber(stringLiteral: objectNumber),
            title: title,
            author: author,
            imageURL: image,
            detailsURL: details,
            webURL: web)
    }}
