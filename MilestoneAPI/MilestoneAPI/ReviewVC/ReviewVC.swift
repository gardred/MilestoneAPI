//
//  ReviewVC.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 27.06.2022.
//

import UIKit
import Cosmos
import SDWebImage

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
    @IBOutlet private weak var backButton: UIButton!
    
    private var movie: Movie?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureSubmitButton()
    }
    
    static func construct(movie: Movie) -> ReviewVC {
        let controller: ReviewVC = .fromStoryboard("Main")
        controller.movie = movie
        return controller
    }
    
    private func configureUI() {
        guard let movie = movie else { return }

        reviewBody.layer.cornerRadius = 8
        submitButton.layer.cornerRadius = 8
        
        movieTitle.text = movie.title
        imageView.sd_setImage(with: URL(string: "\(Constants.imageURL)\(movie.posterImage)"))
    }
    
    // MARK: - API Request
    
    private func configureSubmitButton() {
        if reviewTitle.text == "" || reviewBody.text == "" {
            submitButton.isUserInteractionEnabled = false
            submitButton.backgroundColor = hexStringToUIColor(hex: "#707070").withAlphaComponent(0.5)
        } else {
            submitButton.isUserInteractionEnabled = true
            submitButton.backgroundColor = hexStringToUIColor(hex: "#FFFFFF")
        }
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
