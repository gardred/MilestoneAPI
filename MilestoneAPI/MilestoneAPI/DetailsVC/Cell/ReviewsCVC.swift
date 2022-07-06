//
//  ReviewsCVC.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 05.07.2022.
//

import UIKit

class ReviewsCVC: UICollectionViewCell {

    static let identifier = "ReviewsCVC"

    @IBOutlet weak var rating: UILabel!
    @IBOutlet  weak var author: UILabel!
    @IBOutlet  weak var date: UILabel!
    @IBOutlet  weak var body: UILabel!
    @IBOutlet  weak var reviewTitle: UILabel!
    
    @IBOutlet weak var reviewStackView: UIStackView!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var authorStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       configureCellUI()
    }
    
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
        print(body.frame.height)
    }
    
}
