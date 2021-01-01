//
//  HomePresenter.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 1/2/21.
//

import Foundation

final class HomePresenterImpl {
    weak var view: HomeView? {
        didSet {
            viewDidAttach()
        }
    }

    private let artObjectsService: ArtObjectsService

    init(artObjectsService: ArtObjectsService) {
        self.artObjectsService = artObjectsService
    }

    func viewDidAttach() {
    }
}

extension HomePresenterImpl: HomePresenter {
}
