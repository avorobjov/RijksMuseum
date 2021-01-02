//
//  MockArtObjectsDatabase.swift
//  RijksMuseumTests
//
//  Created by Alexander Vorobjov on 1/3/21.
//

import Foundation
@testable import RijksMuseum

class MockArtObjectsDatabase: ArtObjectsDatabase {
    var home: [ArtObject] = []
    var search: [ArtObject] = []

    func readHomeItems() -> [ArtObject] {
        return home
    }

    func saveHomeItems(_ items: [ArtObject]) {
        home = items
    }

    func searchItems(query: String) -> [ArtObject] {
        return search
    }

    func saveSearchItems(_ items: [ArtObject]) {
        search = items
    }
}
