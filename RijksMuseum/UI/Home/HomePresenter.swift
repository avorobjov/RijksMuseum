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
        updateObjects()
    }
}

extension HomePresenterImpl: HomePresenter {
}

private extension HomePresenterImpl {
    func updateObjects() {
        artObjectsService.loadHome { result in
            do {
                let items = try result.get().map {
                    ArtObjectCell.ViewModel(
                        imageURL: $0.imageURL,
                        title: $0.title,
                        author: $0.author)
                }

                self.view?.show(items: items)
            }
            catch {
                self.view?.presentMessage(title: "Failed to load data",
                                          message: error.localizedDescription)
            }
        }
    }
}
