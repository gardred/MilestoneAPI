//
//  ReviewCRV.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 06.07.2022.
//

import UIKit

class ReviewCRV: UICollectionReusableView {

    static let identifier = "ReviewCRV"
    
    @IBOutlet private weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func configure(model: Movie) {
        guard let image = model.backdropPath else { return }
        imageView.sd_setImage(with: URL(string: "\(Constants.imageURL)\(image)"))
        imageView.contentMode = .scaleAspectFill
    }
}
