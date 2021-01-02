//
//  AppAssembly.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 1/2/21.
//

import Foundation

protocol AppAssembly {
    var artObjectsService: ArtObjectsService { get }
}

final class AppAssemblyImpl {
    private let session: Session
    private let database: Database

    init(database: Database) {
        self.session = SessionImpl(key: Constants.rijksMuseumApiKey)
        self.database = database
    }
}

extension AppAssemblyImpl: AppAssembly {
    var artObjectsService: ArtObjectsService {
        let network = ArtObjectsNetworkImpl(session: session)
        let db = ArtObjectsDatabaseImpl(database: database)
        return ArtObjectsServiceImpl(network: network, database: db)
    }
}
