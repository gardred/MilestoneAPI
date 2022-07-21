//
//  TestTVC.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 11.07.2022.
//

import UIKit

class ReviewTVC: UITableViewCell {
    
    static let identifier = "ReviewTVC"
    
    @IBOutlet private weak var rating: UILabel!
    @IBOutlet private weak var author: UILabel!
    @IBOutlet private weak var date: UILabel!
    @IBOutlet private weak var body: UILabel!
    @IBOutlet private weak var reviewTitle:  UILabel!
    @IBOutlet private weak var errorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .black
    }
    
    func stringFrom(date: Date, with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    
    public func configure(model: Review) {
        
        rating.text = String(model.authorDetails.rating)
        reviewTitle.text = model.author
        author.text = model.author
        body.text = model.content
        date.text = convertDateFormatter(date: model.createdAt)
        
        errorLabel.isHidden = true
    }
    
    static func instanceFromNib() -> UIView {
        return UINib(nibName: "ReviewTVC", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}

extension ReviewTVC {
    
    static func estimatedHeight(model: Review) -> CGFloat {
        if let nibView = ReviewTVC.instanceFromNib() as? ReviewTVC {
            nibView.configure(model: model)
            nibView.layoutIfNeeded()
            let newFrame = nibView.sizeToFit(inViewWidth: UIScreen.main.bounds.width)
            return newFrame.height
        } else {
            return 190
        }
    }
}
