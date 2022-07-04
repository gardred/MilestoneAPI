//
//  DescriptionCVC.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 27.06.2022.
//

import UIKit

class DescriptionCVC: UICollectionViewCell {
    
    static let identifier = "DescriptionCVC"
    static let shared = DescriptionCVC()
    // MARK: - UIElements
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var reviews: [Reviews] = [Reviews]()
    var id = 0
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()

        makeElementsSkeletonable()
        notifications()
        configureTableView()
    }

    // MARK: - Functions
    
    public func configure(model: Movie) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.descriptionLabel.text = model.overview
            self.descriptionLabel.hideSkeleton()
        }
    }
    
    private func makeElementsSkeletonable() {
        descriptionLabel.isSkeletonable = true
        descriptionLabel.showSkeleton(usingColor: .concrete, animated: true, delay: 0.25, transition: .crossDissolve(0.25))
        
        reviewTableView.isSkeletonable = true
        reviewTableView.showSkeleton(usingColor: .concrete, animated: true, delay: 0.25, transition: .crossDissolve(0.25))
    }
    
    private func configureTableView() {
        reviewTableView.register(UINib(nibName: "ReviewTVC", bundle: nil), forCellReuseIdentifier: ReviewTVC.identifier)
        reviewTableView.isScrollEnabled = true
//        reviewTableView.rowHeight = UITableView.automaticDimension
        reviewTableView.dataSource = self
        reviewTableView.delegate = self
    }
    
    private func notifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(presentDescription), name: NSNotification.Name("change"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideDescription), name: NSNotification.Name("hide"), object: nil)
    }
    
    // MARK: - API Request
    
    private func getReview() {
        API.shared.getReview(id: id) { [weak self] (result) in
            switch result {
                
            case .success(let review):
                self?.reviews.append(contentsOf: review)
                DispatchQueue.main.async {
                    self?.reviewTableView.reloadData()
                }
                
            case .failure(_):
                print("")
            }
        }
    }
    
    // MARK: - Objc private functions
 
    @objc private func presentDescription() {
        descriptionLabel.isHidden = false
        reviewTableView.isHidden = true
        errorLabel.isHidden = true
    }
    
    @objc private func hideDescription() {
        getReview()
        reviewTableView.isHidden = false
        errorLabel.isHidden = true
        descriptionLabel.isHidden = true
        reviewTableView.reloadData()
    }
}

// MARK: - UITableView Data Source

extension DescriptionCVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(reviews.count)
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTVC.identifier, for: indexPath) as? ReviewTVC else { return UITableViewCell() }
        cell.configure(model: reviews[indexPath.row])
        return cell
    }
}

// MARK: - UITableView Delegate

extension DescriptionCVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}
