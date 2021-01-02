//
//  DetailsViewController.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 1/2/21.
//

import UIKit

final class DetailsViewController: UIViewController {
    private let presenter: DetailsPresenter

    init(presenter: DetailsPresenter) {
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
    }
}
