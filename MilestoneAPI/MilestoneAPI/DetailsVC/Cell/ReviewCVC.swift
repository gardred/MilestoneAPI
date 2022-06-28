//
//  ReviewCVC.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 27.06.2022.
//

import UIKit

class ReviewCVC: UICollectionViewCell {
    
    static let identifier = "ReviewCVC"
    
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var reviewTitle: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var review: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
