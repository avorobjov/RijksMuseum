//
//  HomeContract.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 1/2/21.
//

import Foundation

protocol HomePresenter: Presenter {
    var view: HomeView? { get set }
}

protocol HomeView: View, MessagePresenting {
    func show(items: [ArtObjectCell.ViewModel])
}
