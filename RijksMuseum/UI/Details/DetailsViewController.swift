//
//  DetailsViewController.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 1/2/21.
//

import SDWebImage
import UIKit

final class DetailsViewController: UIViewController {
    private let presenter: DetailsPresenter

    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!

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

        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray

        presenter.view = self
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        updateZoomScale()
    }
}

extension DetailsViewController: DetailsView {
    func show(image: URL?) {
        imageView.sd_setImage(with: image) { _, _, _, _ in
            self.updateZoomScale()
            self.zoomToFullImage()
        }
    }
}

extension DetailsViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

private extension DetailsViewController {
    func updateZoomScale() {
        guard let image = imageView.image else {
            return
        }

        let size = scrollView.frame.inset(by: scrollView.adjustedContentInset).size
        let minScale = min(size.width / image.size.width, size.height / image.size.height)

        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = max(2, minScale)
    }

    func zoomToFullImage() {
        scrollView.zoomScale = scrollView.minimumZoomScale
    }
}
