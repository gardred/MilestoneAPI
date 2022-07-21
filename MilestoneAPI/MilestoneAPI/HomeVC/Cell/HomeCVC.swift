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
    
    private var genreNames: String?
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    // MARK: - Functions
    
    public func configure(model: Movie) {
        
        guard let image = model.posterPath else { return }
        
        imageView.sd_setImage(with: URL(string: "\(Constants.imageURL)\(image)"))
        titleLabel.text = model.title
        dateLabel.text = model.releaseDate
        ratingLabel.text = String(model.voteAverage)
        
        let genreNames = model.getGeneres().map({ $0.name })
            .joined(separator: ", ")
        
        genreLabel.text = genreNames
        
        
    }
}
