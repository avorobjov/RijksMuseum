//
//  Database.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 1/2/21.
//

import Foundation
import GRDB

enum DatabaseError: Error {
    case databaseError
}

protocol Database {
    var queue: DatabaseQueue { get }
}

class DatabaseImpl: Database {
    static func defaultDatabaseURL() throws -> URL {
        try FileManager.default
            .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("cache.sqlite")
    }

    let queue: DatabaseQueue

    init(databaseURL: URL) throws {
        queue = try DatabaseQueue(path: databaseURL.path)
        try migrator.migrate(queue)
    }

    /// The DatabaseMigrator that defines the database schema.
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()

        migrator.registerMigration("initialTables") { db in
            try db.create(table: ArtObjectRecord.databaseTableName) { t in
                t.column(ArtObjectRecord.Columns.id.name, .text).unique(onConflict: .replace).primaryKey()
                t.column(ArtObjectRecord.Columns.objectNumber.name, .text).notNull()
                t.column(ArtObjectRecord.Columns.title.name, .text).notNull()
                t.column(ArtObjectRecord.Columns.author.name, .text).notNull()
                t.column(ArtObjectRecord.Columns.imageURL.name, .text).notNull()
                t.column(ArtObjectRecord.Columns.detailsURL.name, .text).notNull()
                t.column(ArtObjectRecord.Columns.webURL.name, .text)
                t.column(ArtObjectRecord.Columns.isHomeItem.name, .boolean).defaults(to: false)
            }
        }

        return migrator
    }
}
