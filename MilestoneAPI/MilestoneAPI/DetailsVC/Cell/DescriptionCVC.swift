//
//  DescriptionCVC.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 27.06.2022.
//

import UIKit
import SkeletonView
class DescriptionCVC: UICollectionViewCell {
    
    static let identifier = "DescriptionCVC"
    static let shared = DescriptionCVC()
    // MARK: - UIElements
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        makeElementsSkeletonable()
        notifications()
        
    }
    
    // MARK: - Functions
    
    public func configure(model: SingleMovie) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.descriptionLabel.text = model.overview
            self.descriptionLabel.hideSkeleton()
        }
    }
    
    private func makeElementsSkeletonable() {
        descriptionLabel.isSkeletonable = true
        descriptionLabel.showSkeleton(usingColor: .concrete, animated: true, delay: 0.25, transition: .crossDissolve(0.25))
    }
    
    private func notifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(presentDescription), name: NSNotification.Name("change"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideDescription), name: NSNotification.Name("hide"), object: nil)
    }
    
    // MARK: - Objc private functions
    
    @objc private func presentDescription() {
        descriptionLabel.isHidden = false
        reviewTableView.isHidden = true
        errorLabel.isHidden = true
    }
    
    @objc private func hideDescription() {
        reviewTableView.isHidden = false
        errorLabel.isHidden = true
        descriptionLabel.isHidden = true
        reviewTableView.reloadData()
    }
}

