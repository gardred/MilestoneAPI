//
//  DescriptionCVC.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 27.06.2022.
//

import UIKit

class DescriptionCVC: UICollectionViewCell {
    static let identifier = "DescriptionCVC"
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    public func configure(model: Movie) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.descriptionLabel.text = model.overview
        }
    }
    
}
