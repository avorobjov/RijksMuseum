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
    private var details: ArtObjectDetails?

    init(artObjectsService: ArtObjectsService, artObject: ArtObject) {
        self.artObjectsService = artObjectsService
        self.artObject = artObject
    }

    func viewDidAttach() {
        updateTitle()
        updateImage()

        loadDetails()
    }
}

extension DetailsPresenterImpl: DetailsPresenter {
}

private extension DetailsPresenterImpl {
    func updateTitle() {
        view?.set(title: details?.title ?? artObject.title)
    }

    func updateImage() {
        view?.show(image: artObject.imageURL)
    }

    func loadDetails() {
        artObjectsService.details(objectNumber: artObject.objectNumber) { result in
            do {
                self.details = try result.get()
                self.updateTitle()
            }
            catch {
                self.view?.presentMessage(title: "Failed to load data",
                                          message: error.localizedDescription)
            }
        }
    }
}
