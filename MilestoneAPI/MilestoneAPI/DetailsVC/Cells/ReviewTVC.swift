//
//  TestTVC.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 11.07.2022.
//

import UIKit

class ReviewTVC: UITableViewCell {
    
    static let identifier = "ReviewTVC"
    
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var body: UILabel!
    @IBOutlet  weak var reviewTitle:  UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .black
    }
    
//    func stringFrom(date: Date, with format: String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = format
//        return dateFormatter.string(from: date)
//    }
    
    public func configure(model: Review) {
        self.rating.text = String(model.authorDetails.rating)
        self.reviewTitle.text = model.author
        self.author.text = model.author
//        self.date.text = stringFrom(date: model.createdAt, with: "MM")
        self.body.text = model.content
    }
    
    class func instanceFromNib() -> UIView {
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
