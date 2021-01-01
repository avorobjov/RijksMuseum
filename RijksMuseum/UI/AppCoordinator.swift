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
        let home = builder.build()
        let nc = UINavigationController(rootViewController: home)
        window.rootViewController = nc
        navigation = nc
    }
}
