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
    
    // MARK: - UI Elements
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var movieTitle: UILabel!
    @IBOutlet private weak var reviewTitle: UITextField!
    @IBOutlet private weak var reviewBody: UITextView!
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    
    //MARK: - Variables
    private var movie: Movie?
    
    // MARK: - Lifecycle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
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
    }
    
    // MARK: - Functions
    
    static func construct(movie: Movie) -> ReviewVC {
        let controller: ReviewVC = .fromStoryboard("Main")
        controller.movie = movie
        return controller
    }
    
    private func configureUI() {
        guard let movie = movie else { return }
        
        reviewBody.layer.cornerRadius = 8
        submitButton.layer.cornerRadius = 8
        
        reviewTitle.delegate = self
        submitButton.backgroundColor = hexStringToUIColor(hex: "#606DDE").withAlphaComponent(0.5)
        submitButton.isUserInteractionEnabled = false
        
        movieTitle.text = movie.title
        imageView.sd_setImage(with: URL(string: "\(Constants.imageURL)\(movie.posterImage)"))
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UI Textfield delegate

extension ReviewVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (reviewTitle.text! as NSString).replacingCharacters(in: range, with: string)

         if !text.isEmpty{
             submitButton.isUserInteractionEnabled = true
             submitButton.backgroundColor = hexStringToUIColor(hex: "#606DDE").withAlphaComponent(1.0)
         } else {
             submitButton.isUserInteractionEnabled = false
             submitButton.backgroundColor = hexStringToUIColor(hex: "#606DDE").withAlphaComponent(0.5)
         }
         return true
    }
}
