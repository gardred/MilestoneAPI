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
        imageView.sd_setImage(with: URL(string: "\(Constants.imageURL)\(model.backdropPath)"))
        imageView.contentMode = .scaleAspectFill
    }
}
