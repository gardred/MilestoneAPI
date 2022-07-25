//
//  ReviewCVC.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 06.07.2022.
//

import UIKit

class ReviewCVC: UICollectionViewCell {
    // cell identifier
    static let identifier = "ReviewCVC"
    
    // MARK: - UI Elements
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var textView: UITextView!
    
    // MARK: - Variables
    var disableButtonInteraction: ( () -> Void)?
    var enableButtonInteraction: (() -> Void)?
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureCell()
    }
    
    // MARK: - Functions
    private func configureCell() {
        backgroundColor = .black
        
        textField.delegate = self
        textField.setLeftPaddingPoints(16)
        textField.setRightPaddingPoints(16)
        
        textView.delegate = self
        textView.layer.cornerRadius = 8
        textView.textColor = hexStringToUIColor(hex: "#C7C7C7")
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
    }
}

    // MARK: - UITextField Delegate

extension ReviewCVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
         if !text.isEmpty {
             self.disableButtonInteraction?()
         } else {
             self.enableButtonInteraction?()
         }
        
         return true
    }
    
}

    // MARK: - UITextView Delegate

extension ReviewCVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == hexStringToUIColor(hex: "#C7C7C7") {
            textView.text = nil
            textView.textColor = UIColor.lightGray
        }
    }
}
