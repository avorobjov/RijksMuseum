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

    init() {
        self.session = SessionImpl(key: Constants.rijksMuseumApiKey)
    }
}

extension AppAssemblyImpl: AppAssembly {
    var artObjectsService: ArtObjectsService {
        let network = ArtObjectsNetworkImpl(session: session)
        return ArtObjectsServiceImpl(network: network)
    }
}
