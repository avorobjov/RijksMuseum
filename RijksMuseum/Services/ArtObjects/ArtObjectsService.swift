//
//  ArtObjectsService.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 1/1/21.
//

import Foundation

typealias ArtObjectsResult = Result<[ArtObject], ArtObjectsServiceError>
typealias ArtObjectsCompletion = (ArtObjectsResult) -> Void

enum ArtObjectsServiceError: LocalizedError {
    case noInternetConnection
    case commonError

    init(sessionError: SessionError) {
        if sessionError == .noInternetConnection {
            self = .noInternetConnection
        }
        else {
            self = .commonError
        }
    }
}

protocol ArtObjectsService {
    func loadHome(completion: @escaping ArtObjectsCompletion)
    func search(query: String, completion: @escaping ArtObjectsCompletion)
}

final class ArtObjectsServiceImpl {
    private let network: ArtObjectsNetwork

    init(network: ArtObjectsNetwork) {
        self.network = network
    }
}

extension ArtObjectsServiceImpl: ArtObjectsService {
    func loadHome(completion: @escaping ArtObjectsCompletion) {
        network.fetchHome { result in
            do {
                let objects = try result.get()

                // TODO: store in db

                completion(.success(objects))
            }
            catch SessionError.noInternetConnection {
                completion(.failure(.noInternetConnection))
            }
            catch {
                completion(.failure(.commonError))
            }
        }
    }

    func search(query: String, completion: @escaping ArtObjectsCompletion) {
        network.fetchSearch(query: query) { result in
            do {
                let objects = try result.get()

                // TODO: store in db

                completion(.success(objects))
            }
            catch SessionError.noInternetConnection {
                completion(.failure(.noInternetConnection))
            }
            catch {
                completion(.failure(.commonError))
            }
        }
    }
}
