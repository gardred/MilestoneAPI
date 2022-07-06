//
//  HeaderViewCollectionReusableView.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 06.07.2022.
//

import UIKit

class HeaderViewCollectionReusableView: UICollectionReusableView {
    static let identifier = "HeaderViewCollectionReusableView"
    @IBOutlet private weak var imageView: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(model: SingleMovie) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let image = model.poster_path  else { return }
            self.imageView.sd_setImage(with: URL(string: "\(Constants.imageURL)\(image)"))
            self.imageView.contentMode = .scaleAspectFill
            print(image)
        }
    }
}
