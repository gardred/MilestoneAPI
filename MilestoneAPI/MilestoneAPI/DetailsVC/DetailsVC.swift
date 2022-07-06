//
//  DetailsVC.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 27.06.2022.
//

import UIKit

enum CellType {
    case details
    case description
    case review(Review)
}

class DetailsVC: UIViewController {
    
    class func fromStoryboard<T: DetailsVC>(_ storyboardName: String) -> T {
        let identifier = "DetailsVC"
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: identifier) as! T
    }
    
    // MARK: - UI Elements
    
    @IBOutlet private weak var detailsCollectionView: UICollectionView!
    @IBOutlet private weak var writeReviewButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    // MARK: - Variables
    
    private var cellType: [CellType] = []
    private var selectedMovie: SingleMovie?
    private var genre: String?
    private var reviews: [Review] = []
    
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
        print(genre)
        configureUI()
        configCollection()
        
        getSingleMovie()
        getReview()
    }
    
    // MARK: - Functions
    
    static func construct(id: Int, genre: String, cellType: [CellType]) -> DetailsVC {
        
        let controller: DetailsVC = .fromStoryboard("Main")
        controller.id = id
        controller.genre = genre
        controller.cellType = cellType
        
        return controller
    }
    
    private func configureUI() {
        view.backgroundColor = .black
        bottomView.backgroundColor = .black
        writeReviewButton.layer.cornerRadius = 8
    }
    
    private func configCollection() {
        
        detailsCollectionView.contentInsetAdjustmentBehavior = .never
        detailsCollectionView.register(UINib(nibName: "DetailsCVC", bundle: nil), forCellWithReuseIdentifier: DetailsCVC.identifier)
        detailsCollectionView.register(UINib(nibName: "DescriptionCVC", bundle: nil), forCellWithReuseIdentifier: DescriptionCVC.identifier)
        detailsCollectionView.register(UINib(nibName: "ReviewsCVC", bundle: nil), forCellWithReuseIdentifier: ReviewsCVC.identifier)
        detailsCollectionView.register(UINib(nibName: "HeaderViewCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderViewCollectionReusableView.identifier)
        detailsCollectionView.dataSource = self
        detailsCollectionView.delegate = self
        
        detailsCollectionView.backgroundColor = .black
    }
    
    private func showDescriptionSection() {
        cellType = [
            .details,
            .description
        ]
        
        detailsCollectionView.reloadData()
    }
    
    private func showReviewSection() {
        cellType = [ .details ]
        cellType.append(contentsOf: reviews.map({ .review($0) }))
        detailsCollectionView.reloadData()
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
                print(self.selectedMovie)
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
            case .failure(_):
                print("error")
            }
        }
    }
    
    // MARK: - IB Actions
    
    @IBAction func writeReviewAction(_ sender: Any) {
        guard let selectedMovie = selectedMovie else { return }
        
        let controller = ReviewViewController.construct(cellType: [.details, .review], movie: selectedMovie)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionView Data Source

extension DetailsVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch cellType[indexPath.row] {
   
            
        case .details:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsCVC.identifier, for: indexPath) as? DetailsCVC else { return UICollectionViewCell() }
            
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
                self.showReviewSection()
                cell.reviewsCount.text = "(\(self.reviews.count))"
            }
            
            return cell
            
        case .description:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DescriptionCVC.identifier, for: indexPath) as? DescriptionCVC else { return UICollectionViewCell() }
            
            if let selectedMovie = selectedMovie {
                cell.configure(model: selectedMovie)
            }
            
            return cell
            
        case .review(let review):
            
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewsCVC.identifier, for: indexPath) as? ReviewsCVC else { return UICollectionViewCell() }
            
            cell.configure(model: review)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderViewCollectionReusableView.identifier, for: indexPath) as! HeaderViewCollectionReusableView
        
        if let selectedMovie = selectedMovie {
            header.configure(model: selectedMovie)
        }
        return header
    }
}

extension DetailsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let width = collectionView.bounds.width
        
        return CGSize(width: width, height: 550)
    }
}

// MARK: - UICollectionView Flow Layout

extension DetailsVC: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewsCVC.identifier, for: indexPath) as! ReviewsCVC
        let cellHeight = ((cell.date.frame.height + cell.reviewTitle.frame.height + cell.rating.frame.height) + (cell.body.frame.height * 35))
       
        switch cellType[indexPath.row] {
            
        case .details:
            return CGSize(width: collectionView.bounds.width, height: 200.0)
        case .description:
            return CGSize(width: collectionView.bounds.width, height: 270.0)
        case .review:
            return CGSize(width: collectionView.bounds.width, height: cellHeight)
        }
    }
}
