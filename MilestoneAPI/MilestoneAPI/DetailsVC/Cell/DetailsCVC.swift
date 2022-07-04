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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeElementsSkeletonable()
        reviewBackgroundView.backgroundColor = .black
        descriptionButton.isSelected = true
        reviewButton.isSelected = false
        configureButtons()
    }
    
    // MARK: - Functions
    
    private func makeElementsSkeletonable() {
        titleLabel.isSkeletonable = true
        titleLabel.showSkeleton(usingColor: .concrete, animated: true, delay: 0.25, transition: .crossDissolve(0.25))
        
        rateLabel.isSkeletonable = true
        rateLabel.showSkeleton(usingColor: .concrete, animated: true, delay: 0.25, transition: .crossDissolve(0.25))
        
        dateLabel.isSkeletonable = true
        dateLabel.showSkeleton(usingColor: .concrete, animated: true, delay: 0.25, transition: .crossDissolve(0.25))
        
        genreLabel.isSkeletonable = true
        genreLabel.showSkeleton(usingColor: .concrete, animated: true, delay: 0.25, transition: .crossDissolve(0.25))
    }
    
    public func configure(model: Movie, genre: String) {
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            self.titleLabel.text = model.title
            self.titleLabel.hideSkeleton()
            
            self.rateLabel.text = "\(model.rate)"
            self.rateLabel.hideSkeleton()
            
            self.dateLabel.text = model.year
            self.dateLabel.hideSkeleton()
            
            self.genreLabel.text = genre
            self.genreLabel.hideSkeleton()
        }
    }
    
    private func configureButtons() {
        
        descriptionButton.layer.cornerRadius = 8
        descriptionButton.layer.masksToBounds = true
        descriptionButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        reviewButton.layer.cornerRadius = 8
        reviewButton.layer.masksToBounds = true
        reviewButton.backgroundColor = .black
        reviewButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func resetViews() {
        descriptionButton.isSelected = true
        reviewButton.isSelected = false

    }
    
    // MARK: - IB Action
    
    @IBAction func descriptionAction(_ sender: Any) {
        if descriptionButton.isSelected == false {
            
            NotificationCenter.default.post(name: NSNotification.Name("change"), object: nil)
            
            descriptionButton.isSelected = true
            descriptionButton.backgroundColor = hexStringToUIColor(hex: "#252A34")
            
            changeCollectionCellToDescription?()
            
            reviewButton.isSelected = false
            reviewButton.backgroundColor = .black
            reviewButton.setTitleColor(UIColor.darkGray, for: .normal)
            reviewsCount.textColor = .darkGray
            
        } else {
            descriptionButton.isSelected = false
            descriptionButton.backgroundColor = .black
            descriptionButton.setTitleColor(UIColor.white, for: .normal)
        }
        
    }
    
    @IBAction func reviewAction(_ sender: Any) {
        if reviewButton.isSelected == false {
            
            NotificationCenter.default.post(name: NSNotification.Name("hide"), object: nil)
            
            reviewButton.isSelected = true
            reviewButton.backgroundColor = hexStringToUIColor(hex: "#252A34")
            reviewsCount.textColor = .white
            
            changeCollectionCellToReview?()
            
            descriptionButton.isSelected = false
            descriptionButton.backgroundColor = .black
            descriptionButton.setTitleColor(UIColor.darkGray, for: .normal)
        
        } else {
            reviewButton.isSelected = false
            reviewButton.backgroundColor = .black
            reviewButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
}
