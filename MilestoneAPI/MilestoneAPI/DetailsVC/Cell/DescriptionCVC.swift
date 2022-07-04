//
//  DescriptionCVC.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 27.06.2022.
//

import UIKit

class DescriptionCVC: UICollectionViewCell {
    
    static let identifier = "DescriptionCVC"
    
    // MARK: - UIElements
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    
    private var reviews: [Review] = [Review]()
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeElementsSkeletonable()
        configureTableView()
        notifications()
        configureTableView()
    }

    // MARK: - Functions
    
    private func makeElementsSkeletonable() {
        descriptionLabel.isSkeletonable = true
        descriptionLabel.showSkeleton(usingColor: .concrete, animated: true, delay: 0.25, transition: .crossDissolve(0.25))
        
        reviewTableView.isSkeletonable = true
        reviewTableView.showSkeleton(usingColor: .concrete, animated: true, delay: 0.25, transition: .crossDissolve(0.25))
    }
    
    public func configure(model: Movie) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.descriptionLabel.text = model.overview
            self.descriptionLabel.hideSkeleton()
        }
    }
    
    private func showError() {
        if reviews.count == 0 {
            reviewTableView.isHidden = true
            errorLabel.isHidden = false
        } else {
            reviewTableView.isHidden = false
            errorLabel.isHidden = true
        }
    }
    
    private func notifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(presentDescription), name: NSNotification.Name("change"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideDescription), name: NSNotification.Name("hide"), object: nil)
    }
    
    private func configureTableView() {
        reviewTableView.register(UINib(nibName: "ReviewTVC", bundle: nil), forCellReuseIdentifier: ReviewTVC.identifier)
        reviewTableView.dataSource = self
        reviewTableView.delegate = self
    }
    
    @objc func presentDescription() {
        descriptionLabel.isHidden = false
        reviewTableView.isHidden = true
        errorLabel.isHidden = true
    }
    
    @objc func hideDescription() {
        if reviews.count == 0 {
            reviewTableView.isHidden = true
            errorLabel.isHidden = false
            descriptionLabel.isHidden = true
        } else {
            reviewTableView.isHidden = false
            errorLabel.isHidden = true
            descriptionLabel.isHidden = true
        }
    }
}

// MARK: - UITableView Data Source

extension DescriptionCVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTVC.identifier, for: indexPath) as? ReviewTVC else { return UITableViewCell() }
        cell.backgroundColor = .systemGreen
        return cell
    }
}

// MARK: - UITableView Delegate

extension DescriptionCVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
