//
//  ReviewTVC.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 30.06.2022.
//

import UIKit

struct Review {
    let rating: Int
    let title: String
    let author: String
    let reviewDate: String
    let body: String
}

class ReviewTVC: UITableViewCell {
    
    static let identifier = "ReviewTVC"
    
    @IBOutlet private weak var rating: UILabel!
    @IBOutlet private weak var reviewTitle: UILabel!
    @IBOutlet private weak var reviewAuthor: UILabel!
    @IBOutlet private weak var reviewDate: UILabel!
    @IBOutlet private weak var reviewBody: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
