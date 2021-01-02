//
//  ArtObjectsDatabase.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 1/2/21.
//

import Foundation
import GRDB

protocol ArtObjectsDatabase {
    func readHomeItems(showOutdated: Bool) -> [ArtObject]
    func saveHomeItems(_ items: [ArtObject])

    func searchItems(query: String) -> [ArtObject]
    func saveSearchItems(_ items: [ArtObject])
}

final class ArtObjectsDatabaseImpl {
    static let cacheLifetimeSeconds: TimeInterval = 5 * 60  // 5 minutes

    /// calculate the minimum date when cache is still valid
    static func minimumFetchDate() -> Date {
        return Date().addingTimeInterval(-cacheLifetimeSeconds)
    }

    private let database: Database

    init(database: Database) {
        self.database = database
    }
}

extension ArtObjectsDatabaseImpl: ArtObjectsDatabase {
    func readHomeItems(showOutdated: Bool) -> [ArtObject] {
        let minFetchDate = Self.minimumFetchDate()

        let records = try? database.queue.read { db -> [ArtObjectRecord] in
            var query = ArtObjectRecord
                .filter(ArtObjectRecord.Columns.isHomeItem == true)
                .limit(Constants.defaultPageSize)

            if !showOutdated {
                query = query
                    .filter(ArtObjectRecord.Columns.fetchDate >= minFetchDate)
            }

            return try query.fetchAll(db)
        }

        return (records ?? []).compactMap { $0.toModel() }
    }

    func saveHomeItems(_ items: [ArtObject]) {
        let records = items.map { ArtObjectRecord($0, isHomeItem: true) }
        saveArtObjectRecords(records)
    }

    func searchItems(query: String) -> [ArtObject] {
        guard query.count > 1 else {
            return []
        }

        let records = try? database.queue.read { db in
            try ArtObjectRecord
                .filter(ArtObjectRecord.Columns.title.like("%\(query)%") || ArtObjectRecord.Columns.author.like("%\(query)%"))
                .limit(Constants.defaultPageSize)
                .fetchAll(db)
        }

        return (records ?? []).compactMap { $0.toModel() }
    }

    func saveSearchItems(_ items: [ArtObject]) {
        let records = items.map { ArtObjectRecord($0, isHomeItem: false) }
        saveArtObjectRecords(records)
    }
}

private extension ArtObjectsDatabaseImpl {
    func saveArtObjectRecords(_ records: [ArtObjectRecord]) {
        try? database.queue.write { db -> Void in
            records.forEach { try? $0.save(db) }
        }
    }
}
