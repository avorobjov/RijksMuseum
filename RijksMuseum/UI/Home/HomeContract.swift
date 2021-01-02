//
//  HomeContract.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 1/2/21.
//

import Foundation

protocol HomePresenter: Presenter {
    var view: HomeView? { get set }

    func search(query: String?)
    func cancelSearch()

    func showDetails(at index: Int)
}

protocol HomePresenterDelegate: AnyObject {
    func showDetails(artObject: ArtObject)
}

protocol HomeView: View, MessagePresenting, TitleSettable {
    func show(items: [ArtObjectCell.ViewModel])
}
