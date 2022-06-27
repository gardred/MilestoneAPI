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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func configure(model: Movie) {
        
    }

}
