//
//  HomeViewController.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 1/2/21.
//

import UIKit

final class HomeViewController: UIViewController {
    static let margin: CGFloat = 10

    private let presenter: HomePresenter

    @IBOutlet private var collectionView: UICollectionView!

    private var items: [ArtObjectCell.ViewModel] = []

    init(presenter: HomePresenter) {
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Home"
        view.backgroundColor = .systemBackground

        collectionView.register(ArtObjectCell.nib(),
                                forCellWithReuseIdentifier: ArtObjectCell.reuseIdentifier)

        if let flow = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.minimumInteritemSpacing = Self.margin
            flow.sectionInset = UIEdgeInsets(top: 0, left: Self.margin, bottom: 0, right: Self.margin)
        }

        presenter.view = self
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate { _ in
            let c = UICollectionViewFlowLayoutInvalidationContext()
            c.invalidateFlowLayoutDelegateMetrics = true
            self.collectionView.collectionViewLayout.invalidateLayout(with: c)
        }
    }
}

extension HomeViewController: HomeView {
    func show(items: [ArtObjectCell.ViewModel]) {
        self.items = items

        collectionView.reloadData()
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtObjectCell.reuseIdentifier, for: indexPath) as! ArtObjectCell

        cell.viewModel = items[indexPath.row]

        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = (collectionView.frame.width - 2 * Self.margin)
        let columns: Int = max(2, Int(width) / 200)
        let itemWidth = (width - (CGFloat(columns) - 1) * Self.margin) / CGFloat(columns)

        return CGSize(width: itemWidth, height: itemWidth + 30)
    }
}
