//
//  DetailsBuilder.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 1/2/21.
//

import UIKit

struct DetailsBuilder {
    let assembly: AppAssembly

    func build(artObject: ArtObject) -> UIViewController {
        let presenter = DetailsPresenterImpl(artObjectsService: assembly.artObjectsService, artObject: artObject)
        return DetailsViewController(presenter: presenter)
    }
}
