//
//  DetailsTVC.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 11.07.2022.
//

import UIKit

class DetailsTVC: UITableViewCell {
    
    static let identifier = "DetailsTVC"

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var rateLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    
    @IBOutlet private weak var descriptionButton: UIButton!
    @IBOutlet private weak var reviewBackgroundView: UIView!
    @IBOutlet private weak var reviewButton: UIButton!
    
    @IBOutlet weak var reviewsCount: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var changeCollectionCellToDescription: (() -> Void)?
    var changeCollectionCellToReview: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        backgroundColor = .black
        makeElementsSkeletonable()
        
        reviewBackgroundView.backgroundColor = .black
        descriptionButton.isSelected = true
        reviewButton.isSelected = false
        
        configureButtons()
    }
    
    
    private func makeElementsSkeletonable() {
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        titleLabel.isSkeletonable = true
        titleLabel.showSkeleton(usingColor: .concrete, animated: true, delay: 0.25, transition: .crossDissolve(0.25))
        
        rateLabel.isSkeletonable = true
        rateLabel.showSkeleton(usingColor: .concrete, animated: true, delay: 0.25, transition: .crossDissolve(0.25))
        
        dateLabel.isSkeletonable = true
        dateLabel.showSkeleton(usingColor: .concrete, animated: true, delay: 0.25, transition: .crossDissolve(0.25))
        
        genreLabel.isSkeletonable = true
        genreLabel.showSkeleton(usingColor: .concrete, animated: true, delay: 0.25, transition: .crossDissolve(0.25))
    }
    
    public func configure(model: Movie, genre: String, reviewCount: Int) {
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            
            self.titleLabel.text = model.title
            self.titleLabel.hideSkeleton()
            
            self.rateLabel.text = "\(model.voteAverage)"
            self.rateLabel.hideSkeleton()
            
            self.dateLabel.text = model.releaseDate
            self.dateLabel.hideSkeleton()
            
            self.genreLabel.text = genre
            self.genreLabel.hideSkeleton()
            
            self.reviewsCount.text = "(\(reviewCount))"
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
    
    private func describeButtonDeselectedState() {
        descriptionButton.isSelected = false
        descriptionButton.backgroundColor = .black
        descriptionButton.setTitleColor(UIColor.darkGray, for: .normal)
    }
    
    private func reviewButtonDeselectedState() {
        reviewButton.isSelected = false
        reviewButton.backgroundColor = .black
        reviewButton.setTitleColor(UIColor.darkGray, for: .normal)
        reviewsCount.textColor = .darkGray
    }
    
    @IBAction func descriptionAction(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("change"), object: nil)
        
        descriptionButton.isSelected = true
        descriptionButton.backgroundColor = hexStringToUIColor(hex: "#252A34")
        
        changeCollectionCellToDescription?()
        reviewButtonDeselectedState()
    }
    
    @IBAction func reviewAction(_ sender: Any) {
        reviewButton.isSelected = true
        reviewButton.backgroundColor = hexStringToUIColor(hex: "#252A34")
        reviewsCount.textColor = .white
        changeCollectionCellToReview?()
        describeButtonDeselectedState()
    }
}
