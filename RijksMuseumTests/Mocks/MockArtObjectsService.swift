//
//  MockArtObjectsService.swift
//  RijksMuseumTests
//
//  Created by Alexander Vorobjov on 1/3/21.
//

import Foundation
@testable import RijksMuseum

class MockArtObjectsService: ArtObjectsService {
    var home: ArtObjectsResult?
    var search: ArtObjectsResult?
    var details: ArtObjectDetailsResult?

    func loadHome(completion: @escaping ArtObjectsCompletion) {
        if let home = home {
            completion(home)
        }
    }

    func search(query: String, completion: @escaping ArtObjectsCompletion) {
        if let search = search {
            completion(search)
        }
    }

    func details(objectNumber: ArtObjectNumber, completion: @escaping ArtObjectDetailsCompletion) {
        if let details = details {
            completion(details)
        }
    }
}
