//
//  PosterCVC.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 27.06.2022.
//

import UIKit
import SkeletonView

class PosterCVC: UICollectionViewCell {

    static let identifier = "PosterCVC"
    
    @IBOutlet weak var imageView: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.isSkeletonable = true
        imageView.showSkeleton(usingColor: .concrete, animated: true, delay: 0.25, transition: .crossDissolve(0.25))
    }
    
    public func configure(model: Movie) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let image = model.poster_path else { return }
            self.imageView.sd_setImage(with: URL(string: "\(Constants.imageURL)\(image)"))
            self.imageView.contentMode = .scaleToFill
            self.imageView.hideSkeleton()
        }
    }
}
