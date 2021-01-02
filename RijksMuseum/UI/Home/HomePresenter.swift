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
    private weak var delegate: HomePresenterDelegate?

    private var displayedObjects: [ArtObject] = []
    private var lastQuery: String?
    private var queryTimer: Timer?

    init(artObjectsService: ArtObjectsService, delegate: HomePresenterDelegate) {
        self.artObjectsService = artObjectsService
        self.delegate = delegate
    }

    func viewDidAttach() {
        view?.set(title: "Home")

        updateObjects()
    }
}

extension HomePresenterImpl: HomePresenter {
    func search(query: String?) {
        lastQuery = query
        queryTimer?.invalidate()
        queryTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            if let query = self?.lastQuery {
                self?.updateSearch(query: query)
            }
        }
    }

    func cancelSearch() {
        updateObjects()
    }

    func showDetails(at index: Int) {
        guard index >= 0, index < displayedObjects.count else {
            return
        }

        let obj = displayedObjects[index]
        delegate?.showDetails(artObject: obj)
    }
}

private extension HomePresenterImpl {
    func updateObjects() {
        artObjectsService.loadHome { [weak self] result in
            self?.displayArtObjectsResult(result: result)
        }
    }

    func updateSearch(query: String?) {
        guard let query = query, query.count > 1 else {
            return
        }

        artObjectsService.search(query: query) { [weak self] result in
            self?.displayArtObjectsResult(result: result)
        }
    }

    func displayArtObjectsResult(result: ArtObjectsResult) {
        do {
            displayedObjects = try result.get()
            let items = displayedObjects.map {
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
