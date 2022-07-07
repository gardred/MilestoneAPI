//
//  HeaderViewCollectionReusableView.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 06.07.2022.
//

import UIKit
import SkeletonView

class HeaderViewCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "HeaderViewCollectionReusableView"
    
    // MARK: - UI Elements
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: - Lifecycle
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: - Functions
    
    public func showSkeleton() {
        imageView.isSkeletonable = true
        imageView.showSkeleton(usingColor: .concrete, animated: true, delay: 0.25, transition: .crossDissolve(0.25))
    }
    
    public func configure(model: SingleMovie) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let image = model.poster_path  else { return }
            self.imageView.sd_setImage(with: URL(string: "\(Constants.imageURL)\(image)"))
            self.imageView.contentMode = .scaleAspectFill
            self.imageView.hideSkeleton()
        }
        
    }
}
