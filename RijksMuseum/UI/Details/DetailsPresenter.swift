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
        updateDescription()
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

    func updateDescription() {
        var components = [String]()

        let title = details?.title ?? artObject.title
        if !title.isEmpty {
            components.append(title)
        }

        let author = details?.authorYearMaterial ?? artObject.author
        if !author.isEmpty {
            components.append(author)
        }

        if let size = details?.size, !size.isEmpty {
            components.append(size)
        }

        if let copyright = details?.copyright, !copyright.isEmpty {
            components.append(copyright)
        }

        if let credit = details?.credit, !credit.isEmpty {
            components.append(credit)
        }

        view?.showDescription(text: components.joined(separator: "\n"))
    }

    func loadDetails() {
        artObjectsService.details(objectNumber: artObject.objectNumber) { result in
            do {
                self.details = try result.get()
                self.updateTitle()
                self.updateDescription()
            }
            catch {
                self.view?.presentMessage(title: "Failed to load data",
                                          message: error.localizedDescription)
            }
        }
    }
}
