//
//  ButtonsCVC.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 27.06.2022.
//

import UIKit

class ButtonsCVC: UICollectionViewCell {
    
    static let identifier = "ButtonsCVC"
    
    @IBOutlet weak var descriptionButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    
    var presentDescriptionCell: (() -> Void) = {}
    var presentReviewCell: (() -> Void) = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    @IBAction func descriptionButtonAction(_ sender: Any) {
        presentDescriptionCell()
    }
    
    @IBAction func reviewButtonAction(_ sender: Any) {
        presentReviewCell()
    }
}
