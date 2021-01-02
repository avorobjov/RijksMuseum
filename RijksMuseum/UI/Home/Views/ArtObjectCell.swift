//
//  ArtObjectCell.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 1/2/21.
//

import UIKit
import SDWebImage

class ArtObjectCell: UICollectionViewCell {
    static let reuseIdentifier = "ArtObjectCell"

    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: Bundle(for: self))
    }

    struct ViewModel {
        let imageURL: URL
        let title: String?
        let author: String?
    }

    var viewModel: ViewModel? {
        didSet {
            updateUI()
        }
    }

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var authorLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        setupAccessibility()
    }

    private func updateUI() {
        titleLabel.text = viewModel?.title
        authorLabel.text = viewModel?.author

        let transformer = SDImageResizingTransformer(size: CGSize(width: 200, height: 200), scaleMode: .aspectFill)
        imageView.sd_setImage(with: viewModel?.imageURL,
                              placeholderImage: nil,
                              options: .continueInBackground,
                              context: [.imageTransformer: transformer])
    }

    private func setupAccessibility() {
        imageView.accessibilityIdentifier = "cell.image"
        titleLabel.accessibilityIdentifier = "cell.title"
        authorLabel.accessibilityIdentifier = "cell.author"
    }
}
