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
    @IBOutlet private var detailsView: UITextView!

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

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator)
    {
        coordinator.animate { _ in
        } completion: { _ in
            self.updateZoomScale()
            self.centerImage()
        }
    }
}

extension DetailsViewController: DetailsView {
    func show(image: URL?) {
        imageView.sd_setImage(with: image) { _, _, _, _ in
            self.updateZoomScale()
            self.zoomToFullImage()

            DispatchQueue.main.async {
                // need a layout pass to update scrollview's contentSize with new zoom
                self.centerImage()
            }
        }
    }

    func showDescription(text: String?) {
        detailsView.text = text
    }
}

extension DetailsViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        centerImage()
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
}

private extension DetailsViewController {
    func updateZoomScale() {
        guard let imageSize = imageView.image?.size else {
            return
        }

        let scrollSize = scrollView.frame.inset(by: scrollView.safeAreaInsets).size
        let minScale = min(scrollSize.width / imageSize.width, scrollSize.height / imageSize.height)

        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = max(2, minScale)

        if scrollView.zoomScale < scrollView.minimumZoomScale {
            scrollView.zoomScale = scrollView.minimumZoomScale
        }

        if scrollView.zoomScale > scrollView.maximumZoomScale {
            scrollView.zoomScale = scrollView.maximumZoomScale
        }
    }

    func zoomToFullImage() {
        scrollView.zoomScale = scrollView.minimumZoomScale
    }

    /// update contentInset so that image is vertically centered in scrollView
    func centerImage() {
        let imageSize = scrollView.contentSize
        let scrollSize = scrollView.frame.inset(by: scrollView.safeAreaInsets).size

        let x = max(0, (scrollSize.width - imageSize.width) / 2)
        let y = max(0, (scrollSize.height - imageSize.height) / 2)

        scrollView.contentInset = UIEdgeInsets(top: y, left: x, bottom: 0, right: 0)
    }
}
