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
    case error
}

class DetailsVC: UIViewController {
    
    static func fromStoryboard<T: DetailsVC>(_ storyboardName: String) -> T {
        let identifier = "TestViewController"
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: identifier) as! T
    }
    
    // MARK: - UIElements
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerImageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var writeReviewButton: UIButton!
    @IBOutlet private weak var borderView: UIView!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    // MARK: - Variables
    private var cells: [CellType] = []
    public var reviews: [Review] = []
    private var selectedMovie: Movie?
    
    private var genre: [Genre] = []
    private var genreIds: String?
    
    private var poster: String?
    
    private var id = 0
    private var currentPage = 1
    private var isFetchingData = false
    private let headerHeight: CGFloat = 200
    // MARK: - Lifecycle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        getSingleMovie()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showDescriptionSection()
        getReview()
        getGenre()
        configureTableView()
        print("Genre id: \(genreIds)")
    }
    
    // MARK: - Functions
    
    static func construct(id: Int, genreIds: String?, poster: String?) -> DetailsVC {
        
        let controller: DetailsVC = .fromStoryboard("Main")

        controller.id = id
        controller.genreIds = genreIds
        controller.poster = poster
        
        return controller
    }
    
    private func configureTableView() {
        
        guard let poster = poster else { return presentAlert(title: "Error", body: "Failed to fetch data") }
        headerImageView.sd_setImage(with: URL(string: "\(Constants.imageURL)\(poster)"))
        
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        
        tableView.register(UINib(nibName: "ReviewTVC", bundle: nil), forCellReuseIdentifier: ReviewTVC.identifier)
        tableView.register(UINib(nibName: "DetailsTVC", bundle: nil), forCellReuseIdentifier: DetailsTVC.identifier)
        tableView.register(UINib(nibName: "DescriptionTVC", bundle: nil), forCellReuseIdentifier: DescriptionTVC.identifier)
        tableView.register(UINib(nibName: "NoReviewsTVC", bundle: nil), forCellReuseIdentifier: NoReviewsTVC.identifier)
        
        tableView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -headerHeight)
        updateHeader()
        
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func hideButtons(_ state: Bool) {
        writeReviewButton.isHidden = state
        writeReviewButton.layer.cornerRadius = 8
        borderView.isHidden = state
        tableView.reloadData()
    }
    
    private func updateHeader() {
        
        if tableView.contentOffset.y < headerHeight {
            headerView.frame.origin.y = tableView.contentOffset.y
            headerView.frame.size.height = -tableView.contentOffset.y
        }
    }
    
    private func showDescriptionSection() {
        
        cells = [
            .details,
            .description
        ]
        
        hideButtons(true)
    }
    
    private func showReviewSection() {
        
        if reviews.count > 0 {
            cells = [ .details ]
            cells.append(contentsOf: reviews.map({ .review($0) }))
            
        } else {
            
            cells = [
                .details,
                .error
            ]
        }
        
        hideButtons(false)
    }
    
    // MARK: - API Request
    
    private func getSingleMovie() {
        
        activityIndicator.startAnimating()
        
        API.shared.getMovieById(id: id) { [weak self] (result) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
            
            switch result {
                
            case .success(let movie):
                self.selectedMovie = movie
                print("Selected movie: \(self.selectedMovie)")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    self.presentAlert(title: "Error", body: error.localizedDescription)
                }
            }
        }
    }
    
    private func getReview() {
        activityIndicator.startAnimating()
        API.shared.getReview(id: id, atPage: currentPage) { [weak self] (reviewsResult) in
            
            guard let self = self else { return }
           
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
            
            switch reviewsResult {
                
            case .success(let review):
                self.reviews = review
                self.currentPage += 1
                self.isFetchingData = false
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    self.presentAlert(title: "Error", body: error.localizedDescription)
                }
            }
        }
    }
    
    private func getGenre() {

        API.shared.getGenre { [weak self] (result) in
            guard let self = self else { return }

            switch result {

            case .success(let getGenre):
                self.genre.append(contentsOf: getGenre)
                
            case .failure(let error):

                DispatchQueue.main.async {
                    self.presentAlert(title: "Error", body: error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func writeReviewAction(_ sender: UIButton) {
        guard let selectedMovie = selectedMovie else { return }
        
        let controller = ReviewViewController.construct(movie: selectedMovie)
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
            
            if let selectedMovie = selectedMovie {
                cell.configure(model: selectedMovie, genre: self.genre, reviewCount: reviews.count)
            }
            
            cell.changeCollectionCellToDescription = { [weak self] in
                guard let self = self else { return }
                self.showDescriptionSection()
            }
            
            cell.changeCollectionCellToReview = { [weak self] in
                guard let self = self else { return }
                self.showReviewSection()
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
        case .error:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoReviewsTVC.identifier, for: indexPath) as? NoReviewsTVC else { return UITableViewCell() }
            
            return cell
        }
    }
}

// MARK: - Extension UITableViewDelegate

extension DetailsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch cells[indexPath.row] {
            
        case .details:
            return 195
        case .description:
            guard let selectedMovie = selectedMovie else { return 0 }
            return DescriptionTVC.estimatedHeight(model: selectedMovie)
        case .review(let review):
            return ReviewTVC.estimatedHeight(model: review)
        case .error:
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if reviews.count > 1 {
            
            let lastReview = reviews.count
            if indexPath.row == lastReview && !isFetchingData {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    self.isFetchingData = true
                    self.getReview()
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeader()
    }
}

