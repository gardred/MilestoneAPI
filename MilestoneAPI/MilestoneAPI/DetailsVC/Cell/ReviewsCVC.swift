//
//  ReviewsCVC.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 05.07.2022.
//

import UIKit

class ReviewsCVC: UICollectionViewCell {
    
    static let identifier = "ReviewsCVC"
    
    // MARK: - UI Elements
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var body: UILabel!
    @IBOutlet weak var reviewTitle: UILabel!
    
    @IBOutlet private weak var reviewStackView: UIStackView!
    @IBOutlet private weak var ratingStackView: UIStackView!
    @IBOutlet private weak var authorStackView: UIStackView!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureCellUI()
    }
    
    // MARK: - Functions
    private func configureCellUI() {
        reviewStackView.backgroundColor = .black
        ratingStackView.backgroundColor = .black
        authorStackView.backgroundColor = .black
        backgroundColor = .black
    }
    
    public func configure(model: Review) {
    
        self.rating.text = String(model.author_details.rating)
        self.author.text = model.author
        self.date.text = model.created_at
        self.body.text = model.content
        self.reviewTitle.text = model.author
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
          let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
          layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
          return layoutAttributes
      }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ReviewsCVC", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}

extension ReviewsCVC {
    
    static func estimatedHeight(model: Review) -> CGFloat {
        if let nibView = ReviewsCVC.instanceFromNib() as? ReviewsCVC {
            nibView.configure(model: model)
            nibView.layoutIfNeeded()
            let newFrame = nibView.sizeToFit(inViewWidth: UIScreen.main.bounds.width)
            return newFrame.height
        } else {
            return 300
        }
    }
}
