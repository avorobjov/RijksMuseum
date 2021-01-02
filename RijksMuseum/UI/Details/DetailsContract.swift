//
//  DetailsContract.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 1/2/21.
//

import Foundation

protocol DetailsPresenter: Presenter {
    var view: DetailsView? { get set }
}

protocol DetailsView: View, MessagePresenting {
}
