//
//  DescriptionTVC.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 11.07.2022.
//

import UIKit
import SkeletonView
class DescriptionTVC: UITableViewCell {
    
    static let identifier = "DescriptionTVC"

    // MARK: - UIElements
    @IBOutlet weak var descriptionLabel: UILabel!
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
       
        makeElementsSkeletonable()
        backgroundColor = .black
    }
    
    public func configure(model: SingleMovie) {
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
            self.descriptionLabel.text = model.overview
            self.descriptionLabel.hideSkeleton()
//        }
    }
    
    private func makeElementsSkeletonable() {
        descriptionLabel.isSkeletonable = true
        descriptionLabel.showSkeleton(usingColor: .concrete, animated: true, delay: 0.25, transition: .crossDissolve(0.25))
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "DescriptionTVC", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}

extension DescriptionTVC {
    
    static func estimatedHeight(model: SingleMovie) -> CGFloat {
        if let nibView = DescriptionTVC.instanceFromNib() as? DescriptionTVC {
            nibView.configure(model: model)
            nibView.layoutIfNeeded()
            let newFrame = nibView.sizeToFit(inViewWidth: UIScreen.main.bounds.width)
            return newFrame.height
        } else {
            return 190
        }
    }
}
