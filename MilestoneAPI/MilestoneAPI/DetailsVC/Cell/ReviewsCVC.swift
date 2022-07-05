//
//  ReviewsCVC.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 05.07.2022.
//

import UIKit

class ReviewsCVC: UICollectionViewCell {

    static let identifier = "ReviewsCVC"
    
    @IBOutlet private weak var tableView: UITableView!
    
    var reviews: [Reviews] = [Reviews]()
    var id = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureTableView()
        tableView.isSkeletonable = true
        tableView.showSkeleton(usingColor: .concrete, animated: true, delay: 0.25, transition: .crossDissolve(0.25))
        
    }
    
    public func setup(id: Int) {
        self.id = id
        print(self.id)
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: "ReviewTVC", bundle: nil), forCellReuseIdentifier: ReviewTVC.identifier)
        tableView.backgroundColor = .black
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    public func getReview() {
        API.shared.getReview(id: id) { [weak self] (result) in
            switch result {
    
            case .success(let review):
                self?.reviews.append(contentsOf: review)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(_):
                print("")
            }
        }
    }
}

// MARK: - UITableView Data Source

extension ReviewsCVC: UITableViewDataSource {
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

extension ReviewsCVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if reviews.count > 1 {
            return 300.0
        } else {
            return UITableView.automaticDimension
        }
    }
}
