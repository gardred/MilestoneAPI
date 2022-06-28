//
//  ReviewVC.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 27.06.2022.
//

import UIKit
import Cosmos

class ReviewVC: UIViewController {
    
    class func fromStoryboard<T: ReviewVC>(_ storyboardName: String) -> T {
        let identifier = "ReviewVC"
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: identifier) as! T
    }

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var movieTitle: UILabel!
    @IBOutlet private weak var reviewTitle: UITextField!
    @IBOutlet private weak var reviewBody: UITextView!
    @IBOutlet private weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureSubmitButton()
    }
    
    static func construct() -> ReviewVC {
        let controller: ReviewVC = .fromStoryboard("Main")
        return controller
    }
    
    private func configureUI() {
        reviewBody.layer.cornerRadius = 8
        submitButton.layer.cornerRadius = 8
        
    }
    
    private func configureSubmitButton() {
        if reviewTitle.text == "" || reviewBody.text == "" {
            submitButton.isUserInteractionEnabled = false
            submitButton.backgroundColor = hexStringToUIColor(hex: "#707070").withAlphaComponent(0.5)
        } else {
            submitButton.isUserInteractionEnabled = true
            submitButton.backgroundColor = hexStringToUIColor(hex: "#FFFFFF")
        }
    }
}
