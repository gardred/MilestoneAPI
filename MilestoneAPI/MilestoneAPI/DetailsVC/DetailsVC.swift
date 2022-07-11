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
    
    // MARK: - UIElements
    @IBOutlet private weak var tableView: DetailsTV!
    @IBOutlet private weak var headerImageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet private weak var writeReviewButton: UIButton!
    @IBOutlet weak var borderView: UIView!
    // MARK: - Variables
    private var cells: [CellType] = []
    private var reviews: [Review] = []
    private var selectedMovie: SingleMovie?
    private var genre: String?
    private var poster: String?
    private var id = 0
    
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
        writeReviewButton.layer.cornerRadius = 8
        borderView.backgroundColor  = .clear
        getSingleMovie()
        getReview()
        configureTableView()
    }
    
    // MARK: - Functions
    
    static func construct(id: Int, genre: String, poster: String, cells: [CellType]) -> DetailsVC {
        
        let controller: DetailsVC = .fromStoryboard("Main")
        controller.cells = cells
        controller.id = id
        controller.genre = genre
        controller.poster = poster
        
        return controller
    }
    
    private func configureTableView() {
        
        guard let poster = poster else { return presentAlert(title: "Error", body: "Failed to fetch data") }
        headerImageView.sd_setImage(with: URL(string: "\(Constants.imageURL)\(poster)"))
        
        tableView.register(UINib(nibName: "ReviewTVC", bundle: nil), forCellReuseIdentifier: ReviewTVC.identifier)
        tableView.register(UINib(nibName: "DetailsTVC", bundle: nil), forCellReuseIdentifier: DetailsTVC.identifier)
        tableView.register(UINib(nibName: "DescriptionTVC", bundle: nil), forCellReuseIdentifier: DescriptionTVC.identifier)
        
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
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
            
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }
            switch result {
                
            case .success(let movie):
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
                self.selectedMovie = movie
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
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
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentAlert(title: "Error", body: error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func writeReviewAction(_ sender: UIButton) {
        guard let selectedMovie = selectedMovie else { return }
        
        let controller = ReviewViewController.construct(cellType: [.details, .review], movie: selectedMovie)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Extension UITableViewDataSource

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

// MARK: - Extension UITableViewDelegate

extension DetailsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch cells[indexPath.row] {
            
        case .details:
            return 180
        case .description:
            guard let selectedMovie = selectedMovie else { return 0 }
            return DescriptionTVC.estimatedHeight(model: selectedMovie)
        case .review(let review):
            return ReviewTVC.estimatedHeight(model: review)
        }
    }
}
