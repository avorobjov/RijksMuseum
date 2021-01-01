//
//  ArtObjectsNetwork.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 1/2/21.
//

import Foundation

protocol ArtObjectsNetwork {
    func fetchHome(completion: @escaping SessionCompletion<[ArtObject]>)
    func fetchSearch(query: String, completion: @escaping SessionCompletion<[ArtObject]>)
}

final class ArtObjectsNetworkImpl {
    private let session: Session

    init(session: Session) {
        self.session = session
    }
}

extension ArtObjectsNetworkImpl: ArtObjectsNetwork {
    func fetchHome(completion: @escaping SessionCompletion<[ArtObject]>) {
        let api = ArtObjectsAPI.home
        session.fetch(ArtObjectsSearchResponse.self, api) { result in
            switch result {
            case .success(let response):
                let objects = response.artObjects.compactMap { $0.toModel() }
                completion(.success(objects))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchSearch(query: String, completion: @escaping SessionCompletion<[ArtObject]>) {
        let api = ArtObjectsAPI.search(query: query)
        session.fetch(ArtObjectsSearchResponse.self, api) { result in
            switch result {
            case .success(let response):
                let objects = response.artObjects.compactMap { $0.toModel() }
                completion(.success(objects))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
