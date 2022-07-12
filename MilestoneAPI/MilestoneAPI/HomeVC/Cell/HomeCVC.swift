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
    // MARK: - UI Elements
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  ""
    }
    // MARK: - Functions
    
    public func configure(model: Movie, genre: [Genre]) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let image = model.posterPath else { return }
            self.imageView.sd_setImage(with: URL(string: "\(Constants.imageURL)\(image)"))
            self.titleLabel.text = model.title
            self.dateLabel.text = model.releaseDate
            self.ratingLabel.text = String(model.voteAverage)
            
            let genreNames = genre
                .filter({ _genre in
                    return model.genreIds.contains(where: { $0 == _genre.id })
                })
                .map({ $0.name })
                .joined(separator: ", ")
            
            self.genreLabel.text = genreNames
        }
    }
}
