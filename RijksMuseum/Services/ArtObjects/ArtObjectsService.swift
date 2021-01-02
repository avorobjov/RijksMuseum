//
//  ArtObjectsService.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 1/1/21.
//

import Foundation

typealias ArtObjectsResult = Result<[ArtObject], ArtObjectsServiceError>
typealias ArtObjectsCompletion = (ArtObjectsResult) -> Void

typealias ArtObjectDetailsResult = Result<ArtObjectDetails, ArtObjectsServiceError>
typealias ArtObjectDetailsCompletion = (ArtObjectDetailsResult) -> Void

enum ArtObjectsServiceError: LocalizedError {
    case noInternetConnection
    case commonError

    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "You are not connected to Internet"

        case .commonError:
            return "Server error"
        }
    }

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
    /// Load home items from database and server
    /// - parameter completion: The closure called multiple times: first if cache is available and then when server response is received
    func loadHome(completion: @escaping ArtObjectsCompletion)

    /// Search items in database and on server
    /// - parameter query: Search query, minimum length is 2 symbols
    /// - parameter completion: The closure called multiple times: first if cache is available and then when server response is received
    func search(query: String, completion: @escaping ArtObjectsCompletion)

    /// Load art object details from database or server
    /// - parameter query: Search query, minimum length is 2 symbols
    /// - parameter completion: If cached data is available, returns it. Otherwise loads data from server
    func details(objectNumber: ArtObjectNumber, completion: @escaping ArtObjectDetailsCompletion)
}

final class ArtObjectsServiceImpl {
    private let network: ArtObjectsNetwork
    private let database: ArtObjectsDatabase

    init(network: ArtObjectsNetwork, database: ArtObjectsDatabase) {
        self.network = network
        self.database = database
    }
}

extension ArtObjectsServiceImpl: ArtObjectsService {
    func loadHome(completion: @escaping ArtObjectsCompletion) {
        let items = database.readHomeItems(showOutdated: false)
        if !items.isEmpty {
            return completion(.success(items))
        }

        network.fetchHome { result in
            do {
                let objects = try result.get()
                self.database.saveHomeItems(objects)
                completion(.success(objects))
            }
            catch SessionError.noInternetConnection {
                let cached = self.database.readHomeItems(showOutdated: true)
                if !cached.isEmpty {
                    completion(.success(cached))
                }
                else {
                    completion(.failure(.noInternetConnection))
                }
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
                self.database.saveSearchItems(objects)
                completion(.success(objects))
            }
            catch SessionError.noInternetConnection {
                let cached = self.database.searchItems(query: query)
                if !cached.isEmpty {
                    completion(.success(cached))
                }
                else {
                    completion(.failure(.noInternetConnection))
                }
            }
            catch {
                completion(.failure(.commonError))
            }
        }
    }

    func details(objectNumber: ArtObjectNumber, completion: @escaping ArtObjectDetailsCompletion) {
        network.fetchDetails(objectNumber: objectNumber) { result in
            do {
                let details = try result.get()

                // TODO: store in db

                completion(.success(details))
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
