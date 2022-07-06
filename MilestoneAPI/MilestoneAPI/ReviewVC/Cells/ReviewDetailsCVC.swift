//
//  ReviewDetailsCVC.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 06.07.2022.
//

import UIKit

class ReviewDetailsCVC: UICollectionViewCell {

    static let identifier = "ReviewDetailsCVC"
    
    @IBOutlet private weak var movieTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func configure(model: SingleMovie) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.movieTitle.text = model.title
        }
    }
}
