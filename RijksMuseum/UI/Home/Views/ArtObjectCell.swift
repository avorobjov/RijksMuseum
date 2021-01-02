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
            updateUI(oldValue: oldValue)
        }
    }

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var authorLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
    }

    private func updateUI(oldValue: ViewModel?) {
        titleLabel.text = viewModel?.title
        authorLabel.text = viewModel?.author

        var imageChanged = true
        if
            let oldImageURL = oldValue?.imageURL,
            let newImageURL = viewModel?.imageURL
        {
            imageChanged = !(oldImageURL.absoluteString == newImageURL.absoluteString)
        }

        if imageChanged {
            let transformer = SDImageResizingTransformer(size: CGSize(width: 300, height: 300), scaleMode: .aspectFill)
            imageView.sd_setImage(with: viewModel?.imageURL,
                                  placeholderImage: nil,
                                  context: [.imageTransformer: transformer])
        }
    }
}
