//
//  ReviewTVC.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 30.06.2022.
//

import UIKit

class ReviewTVC: UITableViewCell {
    
    static let identifier = "ReviewTVC"
    
    @IBOutlet private weak var rating: UILabel!
    @IBOutlet private weak var reviewTitle: UILabel!
    @IBOutlet private weak var reviewAuthor: UILabel!
    @IBOutlet private weak var reviewDate: UILabel!
    @IBOutlet private weak var reviewBody: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    public func configure(model: Reviews) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.rating.text = "\(model.authorDetails.rating)"
            self.reviewTitle.text = model.authorDetails.name
            self.reviewAuthor.text = model.authorDetails.username
            self.reviewDate.text = model.createdAt
            self.reviewBody.text = model.content
        }
    }
}
