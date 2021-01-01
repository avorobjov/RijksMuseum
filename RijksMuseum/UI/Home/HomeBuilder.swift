//
//  HomeBuilder.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 1/2/21.
//

import UIKit

struct HomeBuilder {
    let assembly: AppAssembly

    func build() -> UIViewController {
        let presenter = HomePresenterImpl(artObjectsService: assembly.artObjectsService)
        return HomeViewController(presenter: presenter)
    }
}
