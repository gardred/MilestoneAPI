//
//  DescriptionCVC.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 27.06.2022.
//

import UIKit
import SkeletonView
class DescriptionCVC: UICollectionViewCell {
    
    static let identifier = "DescriptionCVC"
    
    // MARK: - UIElements
    @IBOutlet weak var descriptionLabel: UILabel!
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        makeElementsSkeletonable()
    }
    
    // MARK: - Functions
    
    public func configure(model: SingleMovie) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.descriptionLabel.text = model.overview
            self.descriptionLabel.hideSkeleton()
        }
    }
    
    private func makeElementsSkeletonable() {
        descriptionLabel.isSkeletonable = true
        descriptionLabel.showSkeleton(usingColor: .concrete, animated: true, delay: 0.25, transition: .crossDissolve(0.25))
    }
}

