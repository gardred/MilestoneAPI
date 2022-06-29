//
//  DetailsVC.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 27.06.2022.
//

import UIKit

class DetailsVC: UIViewController {
    
    class func fromStoryboard<T: DetailsVC>(_ storyboardName: String) -> T {
        let identifier = "DetailsVC"
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: identifier) as! T
    }
    
    enum CellType {
        case poster
        case details
        case description
        case review
    }

    // MARK: - UI Elements
    
    @IBOutlet private weak var detailsCollectionView: UICollectionView!
    @IBOutlet private weak var writeReviewButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var backButton: UIButton!
    // MARK: - Variables
    
    private var cellType: [CellType] = []
    private var selectedMovie: Movie?
    private var screenState: CellType = .description
    
    public var id = 0
    
    // MARK: - Lifecycle
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        getSingleMovie()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureUI()
        configCollection()
    }
    
    // MARK: - Functions
    
    
    static func construct(id: Int, cellType: [CellType]) -> DetailsVC {
        let controller: DetailsVC = .fromStoryboard("Main")
        controller.id = id
        controller.cellType = cellType
        return controller
    }
    
    private func configureUI() {
        writeReviewButton.layer.cornerRadius = 8
    }
    
    private func configCollection() {
        
        detailsCollectionView.register(UINib(nibName: "PosterCVC", bundle: nil), forCellWithReuseIdentifier: PosterCVC.identifier)
        detailsCollectionView.register(UINib(nibName: "DetailsCVC", bundle: nil), forCellWithReuseIdentifier: DetailsCVC.identifier)
        detailsCollectionView.register(UINib(nibName: "DescriptionCVC", bundle: nil), forCellWithReuseIdentifier: DescriptionCVC.identifier)
        detailsCollectionView.register(UINib(nibName: "ReviewCVC", bundle: nil), forCellWithReuseIdentifier: ReviewCVC.identifier)
        
        detailsCollectionView.dataSource = self
        detailsCollectionView.delegate = self
        
        detailsCollectionView.backgroundColor = .black
    }
    
    private func prepareStructure() {
        cellType = [.poster, .details]
        
        switch screenState {
        case .description:
            cellType.append(.description)
        case .review:
            cellType.append(.review)
        case .poster:
            break
        case .details:
            break
        }
        
        detailsCollectionView.reloadData()
    }
    
    // MARK: - API Request
    
    private func getSingleMovie() {
        API.shared.getMovieById(id: id) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let movie):
                self.selectedMovie = movie
            case .failure(_):
                print("error")
            }
        }
    }
    
    // MARK: - IB Actions
    
    @IBAction func writeReviewAction(_ sender: Any) {
        guard let selectedMovie = selectedMovie else { return }

        let controller = ReviewVC.construct(movie: selectedMovie)
        navigationController?.pushViewController(controller, animated: true)
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
            
        case .poster:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCVC.identifier, for: indexPath) as? PosterCVC else { return UICollectionViewCell() }
            
            if let selectedMovie = selectedMovie {
                cell.configure(model: selectedMovie)
            }
            return cell
            
        case .details:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsCVC.identifier, for: indexPath) as? DetailsCVC else { return UICollectionViewCell() }
           
            if let selectedMovie = selectedMovie {
                cell.configure(model: selectedMovie)
            }
            
            cell.changeCollectionCellToDescription = { [weak self] in
                self?.screenState = .description
                self?.detailsCollectionView.reloadData()
            }
            
            cell.changeCollectionCellToReview = { [weak self] in
                self?.screenState = .review
                self?.detailsCollectionView.reloadData()
            }
            
            return cell
        
        case .description:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DescriptionCVC.identifier, for: indexPath) as? DescriptionCVC else { return UICollectionViewCell() }
            if let selectedMovie = selectedMovie {
                cell.configure(model: selectedMovie)
            }
            return cell
        
        case .review:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCVC.identifier, for: indexPath) as? ReviewCVC else { return UICollectionViewCell() }
            
            return cell
        }
        
    }
}

// MARK: - UICollectionView Flow Layout

extension DetailsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch cellType[indexPath.row] {
            
        case .poster:
            return CGSize(width: collectionView.bounds.width, height: 340.0)
        case .details:
            return CGSize(width: collectionView.bounds.width, height: 200.0)
        case .description:
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        case .review:
            return CGSize(width: collectionView.bounds.width, height: view.frame.height)
        }
    }
}
