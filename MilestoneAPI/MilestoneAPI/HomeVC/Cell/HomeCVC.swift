//
//  HomeCVC.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 27.06.2022.
//

import UIKit
import SDWebImage
class HomeCVC: UICollectionViewCell {

    static let identifier = "HomeCVC"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    public func configure(model: Movie, genre: Genre) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.imageView.sd_setImage(with: URL(string: "\(Constants.imageURL)\(model.posterImage)"))
            self.titleLabel.text = model.title
            self.dateLabel.text = model.year
            self.ratingLabel.text = "\(model.rate)"
            self.genreLabel.text = "\(genre.name)"
        }
    }
    
}
