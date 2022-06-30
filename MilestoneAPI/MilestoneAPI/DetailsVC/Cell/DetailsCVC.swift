//
//  DetailsCVC.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 27.06.2022.
//

import UIKit

class DetailsCVC: UICollectionViewCell {
    
    static let identifier = "DetailsCVC"
    
    // MARK: - UI Elements
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var descriptionButton: UIButton!
    @IBOutlet weak var reviewBackgroundView: UIView!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var reviewsCount: UILabel!
    
    // MARK: - Variables
    
    var changeCollectionCellToDescription: (() -> Void)?
    var changeCollectionCellToReview: (() -> Void)?

    // MARK: - Lifecycle
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//
//        resetViews()
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reviewBackgroundView.backgroundColor = .black
        descriptionButton.isSelected = true
        reviewButton.isSelected = false
        configureButtons()
    }
    
    // MARK: - Functions
    
    public func configure(model: Movie, genre: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.titleLabel.text = model.title
            self.rateLabel.text = "\(model.rate)"
            self.dateLabel.text = model.year
            self.genreLabel.text = genre
        }
    }
    
    private func configureButtons() {
        descriptionButton.layer.cornerRadius = 8
        descriptionButton.layer.masksToBounds = true
        descriptionButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        reviewButton.layer.cornerRadius = 8
        reviewButton.layer.masksToBounds = true
        reviewButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func resetViews() {
        descriptionButton.isSelected = true
        reviewButton.isSelected = false

    }
    
    // MARK: - IB Action
    
    @IBAction func descriptionAction(_ sender: Any) {
        if descriptionButton.isSelected == false {
           
            descriptionButton.isSelected = true
            descriptionButton.setTitleColor(UIColor.white, for: .normal)
            descriptionButton.backgroundColor = .systemGray
            NotificationCenter.default.post(name: NSNotification.Name("change"), object: nil)
            changeCollectionCellToDescription?()
            
            reviewButton.isSelected = false
            reviewButton.backgroundColor = .black
            reviewButton.setTitleColor(UIColor.white, for: .normal)
            
        } else {
            descriptionButton.isSelected = false
            descriptionButton.backgroundColor = .black
            descriptionButton.setTitleColor(UIColor.white, for: .normal)
        }
        
    }
    
    @IBAction func reviewAction(_ sender: Any) {
        if reviewButton.isSelected == false {
            
            reviewButton.isSelected = true
            reviewButton.backgroundColor = .systemGray
            NotificationCenter.default.post(name: NSNotification.Name("hide"), object: nil)
            changeCollectionCellToReview?()
            
            descriptionButton.isSelected = false
            descriptionButton.backgroundColor = .black
            descriptionButton.setTitleColor(UIColor.white, for: .normal)
        
        } else {
            reviewButton.isSelected = false
            reviewButton.backgroundColor = .black
            reviewButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
}
