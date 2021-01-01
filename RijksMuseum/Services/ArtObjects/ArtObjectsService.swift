//
//  ArtObjectsService.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 1/1/21.
//

import Foundation

protocol ArtObjectsService {
    func loadHome()
    func search(query: String)
    func loadDetails(id: ArtObjectId)
}
