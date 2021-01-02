//
//  HomeBuilder.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 1/2/21.
//

import UIKit

struct HomeBuilder {
    let assembly: AppAssembly

    func build(delegate: HomePresenterDelegate) -> UIViewController {
        let presenter = HomePresenterImpl(artObjectsService: assembly.artObjectsService, delegate: delegate)
        return HomeViewController(presenter: presenter)
    }
}
