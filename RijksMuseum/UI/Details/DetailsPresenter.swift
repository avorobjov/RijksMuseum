//
//  DetailsPresenter.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 1/2/21.
//

import Foundation

final class DetailsPresenterImpl {
    weak var view: DetailsView? {
        didSet {
            viewDidAttach()
        }
    }

    private let artObjectsService: ArtObjectsService
    private let artObject: ArtObject

    init(artObjectsService: ArtObjectsService, artObject: ArtObject) {
        self.artObjectsService = artObjectsService
        self.artObject = artObject
    }

    func viewDidAttach() {
        loadDetails()
    }
}

extension DetailsPresenterImpl: DetailsPresenter {
}

private extension DetailsPresenterImpl {
    func loadDetails() {
    }
}
