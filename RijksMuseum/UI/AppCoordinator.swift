//
//  AppCoordinator.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 1/2/21.
//

import UIKit

class AppCoordinator {
    private let assembly: AppAssembly
    private var navigation: UINavigationController?

    init(assembly: AppAssembly) {
        self.assembly = assembly
    }

    func start(in window: UIWindow) {
        let builder = HomeBuilder(assembly: assembly)
        let home = builder.build(delegate: self)
        let nc = UINavigationController(rootViewController: home)
        window.rootViewController = nc
        navigation = nc
    }
}

extension AppCoordinator: HomePresenterDelegate {
    func showDetails(artObject: ArtObject) {
        let builder = DetailsBuilder(assembly: assembly)
        let details = builder.build(artObject: artObject)
        navigation?.show(details, sender: nil)
    }
}
