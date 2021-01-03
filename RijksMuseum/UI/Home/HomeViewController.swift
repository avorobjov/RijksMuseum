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

        view.backgroundColor = .systemBackground

        // Search controller
        setupSearchController()
        setupCollectionView()
        setupAccessibility()

        presenter.view = self
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
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
        let insets = collectionView.adjustedContentInset
        let width = (collectionView.frame.width - 2 * Self.margin - insets.left - insets.right)
        let columns: Int = max(2, Int(width) / 200)
        let itemWidth = (width - (CGFloat(columns) - 1) * Self.margin) / CGFloat(columns)

        return CGSize(width: itemWidth, height: itemWidth + 30)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.showDetails(at: indexPath.item)
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        presenter.search(query: searchController.searchBar.text)
    }
}

extension HomeViewController: UISearchControllerDelegate {
    func willDismissSearchController(_ searchController: UISearchController) {
        presenter.cancelSearch()
    }
}

private extension HomeViewController {
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }

    func setupCollectionView() {
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.register(ArtObjectCell.nib(),
                                forCellWithReuseIdentifier: ArtObjectCell.reuseIdentifier)

        if let flow = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.minimumInteritemSpacing = Self.margin
            flow.sectionInset = UIEdgeInsets(top: 0, left: Self.margin, bottom: 0, right: Self.margin)
        }
    }

    func setupAccessibility() {
        collectionView.accessibilityIdentifier = "home.collection"
        navigationItem.searchController?.searchBar.searchTextField.accessibilityIdentifier = "home.searchbar"
    }
}
