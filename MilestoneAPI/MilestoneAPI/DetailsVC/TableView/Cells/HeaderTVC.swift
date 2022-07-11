//
//  HeaderTVC.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 11.07.2022.
//

import UIKit

class HeaderTVC: UITableViewCell {

    static let identifier = "HeaderTVC"
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func showSkeleton() {
        posterImageView.isSkeletonable = true
        posterImageView.showSkeleton(usingColor: .concrete, animated: true, delay: 0.25, transition: .crossDissolve(0.25))
    }
    
    public func configure(model: SingleMovie) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let image = model.poster_path  else { return }
            self.posterImageView.sd_setImage(with: URL(string: "\(Constants.imageURL)\(image)"))
            self.posterImageView.contentMode = .scaleAspectFill
            self.posterImageView.hideSkeleton()
        }
        
    }
    
}
