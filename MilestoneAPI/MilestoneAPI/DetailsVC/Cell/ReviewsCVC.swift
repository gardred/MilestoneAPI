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
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.rating.text = String(model.author_details.rating)
            self.author.text = model.author
            self.date.text = model.created_at
            self.body.text = model.content
            self.reviewTitle.text = model.author
        }
    }
}

//extension ReviewCVC {
//
//    static func estimatedHeight(entity: Review) -> CGFloat {
//
//        if let nibView = ReviewCVC.instantiateFromNib() as? ReviewCVC {
//            nibView.setup(entity: entity)
//            nibView.layoutIfNeeded()
//            let newFrame = nibView.sizeToFit(inViewWidth: UIScreen.main.bounds.width)
//            return newFrame.height
//        } else {
//            return 190
//        }
//    }
//
//}
