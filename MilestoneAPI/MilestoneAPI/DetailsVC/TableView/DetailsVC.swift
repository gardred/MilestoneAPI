//
//  TestViewController.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 11.07.2022.
//

import UIKit

enum CellType {
    case details
    case description
    case review(Review)
}

class DetailsVC: UIViewController {

    static func fromStoryboard<T: DetailsVC>(_ storyboardName: String) -> T {
        let identifier = "TestViewController"
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: identifier) as! T
    }
    
    @IBOutlet private weak var tableView: UITableView!

    
    private var cells: [CellType] = []
    private var reviews: [Review] = []
    private var selectedMovie: SingleMovie?
    private var genre: String?
    private var id = 0
    
    
    
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
        getSingleMovie()
        getReview()
        configureTableView()
//        updateHeader()
    }
    
    static func construct(id: Int, genre: String, cells: [CellType]) -> DetailsVC {
        
        let controller: DetailsVC = .fromStoryboard("Main")
        controller.cells = cells
        controller.id = id
        controller.genre = genre
        
        return controller
    }
    
    private func configureTableView() {
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ReviewTVC", bundle: nil), forCellReuseIdentifier: ReviewTVC.identifier)
        tableView.register(UINib(nibName: "DetailsTVC", bundle: nil), forCellReuseIdentifier: DetailsTVC.identifier)
        tableView.register(UINib(nibName: "DescriptionTVC", bundle: nil), forCellReuseIdentifier: DescriptionTVC.identifier)
    }
    
    private func showDescriptionSection() {
        
        cells = [
            .details,
            .description
        ]
        
        tableView.reloadData()
    }
    
    private func showReviewSection() {
        
        cells = [ .details ]
        cells.append(contentsOf: reviews.map({ .review($0) }))
        tableView.reloadData()
        
    }
    
    // MARK: - API Request
    
    private func getSingleMovie() {
        
        API.shared.getMovieById(id: id) { [weak self] (result) in
            guard let self = self else { return }
            
//            DispatchQueue.main.async {
//                self.activityIndicator.startAnimating()
//            }
            switch result {
                
            case .success(let movie):
                
//                DispatchQueue.main.async {
//                    self.activityIndicator.stopAnimating()
//                    self.activityIndicator.isHidden = true
//                }
                self.selectedMovie = movie
            
            case .failure(let error):
                
                DispatchQueue.main.async {
//                    self.activityIndicator.stopAnimating()
//                    self.activityIndicator.isHidden = true
                    self.presentAlert(title: "Error", body: error.localizedDescription)
                }
            }
        }
    }
    
    private func getReview() {
        API.shared.getReview(id: id) { [weak self] (reviewsResult) in
            guard let self = self else { return }
            switch reviewsResult {
                
            case .success(let review):
                self.reviews = review
            case .failure(_):
                print("error")
            }
        }
    }
}

extension DetailsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cells[indexPath.row] {
            
        case .details:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailsTVC.identifier, for: indexPath) as? DetailsTVC else { return UITableViewCell() }
            
            cell.reviewsCount.text = "(\(self.reviews.count))"
           
            if let selectedMovie = selectedMovie, let genre = genre {
                
                cell.configure(model: selectedMovie, genre: genre)
            
            } else {
                presentAlert(title: "Error", body: "Failed to get data from server")
            }
            
            cell.changeCollectionCellToDescription = { [weak self] in
                guard let self = self else { return }
                self.showDescriptionSection()
            }
            
            cell.changeCollectionCellToReview = { [weak self] in
                guard let self = self else { return }
                
                if self.reviews.count > 0 {
                    self.showReviewSection()
                } else {
                    self.presentAlert(title: "", body: "No reviews")
                }
                
            }
            
            return cell
        
        case .description:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionTVC.identifier, for: indexPath) as? DescriptionTVC else { return UITableViewCell() }
            
            if let selectedMovie = selectedMovie {
                cell.configure(model: selectedMovie)
            }
            
            return cell
       
        case .review(let review):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTVC.identifier, for: indexPath) as? ReviewTVC else { return UITableViewCell() }
            
            cell.configure(model: review)
            
            return cell
        }
    }
    
    
}

extension DetailsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        switch cells[indexPath.row] {
            
        case .details:
            return 300
        case .description:
            return 125
        case .review(let review):
            
            let height = ReviewTVC.estimatedHeight(model: review)
            return height
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("HeaderTVC", owner: self, options: nil)?.first as! HeaderTVC
        
        if let selectedMovie = selectedMovie {
            headerView.configure(model: selectedMovie)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 550
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}


