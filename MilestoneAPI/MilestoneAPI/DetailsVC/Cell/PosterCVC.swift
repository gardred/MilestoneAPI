//
//  PosterCVC.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 27.06.2022.
//

import UIKit

class PosterCVC: UICollectionViewCell {

    static let identifier = "PosterCVC"
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resetView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func configure(model: Movie) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let image = model.posterImage else { return }
            self.imageView.sd_setImage(with: URL(string: "\(Constants.imageURL)\(image)"))
        }
    }
    
    private func resetView() {
        imageView.image = nil
    }
}
