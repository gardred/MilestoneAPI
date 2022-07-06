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

    public func configure(model: Movie, genre: [Genre]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let image = model.poster_path else { return }
            self.imageView.sd_setImage(with: URL(string: "\(Constants.imageURL)\(image)"))
            self.titleLabel.text = model.title
            self.dateLabel.text = model.release_date
            self.ratingLabel.text = "\(model.vote_average)"
            
            let genreNames = genre
                .filter({ _genre in
                    return model.genre_ids.contains(where: { $0 == _genre.id })
                })
                .map({ $0.name })
                .joined(separator: ", ")
            
            self.genreLabel.text = genreNames
        }
    }
    
}
