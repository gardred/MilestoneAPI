//
//  DetailsVC.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 27.06.2022.
//

import UIKit

enum CellType {
    case poster
    case details
    case description
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
    private var selectedMovie: Movie?
    
    private var id = 0
    private var genre: String?
    // MARK: - Lifecycle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
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
        configCollection()
        getSingleMovie()

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
        
        detailsCollectionView.register(UINib(nibName: "PosterCVC", bundle: nil), forCellWithReuseIdentifier: PosterCVC.identifier)
        detailsCollectionView.register(UINib(nibName: "DetailsCVC", bundle: nil), forCellWithReuseIdentifier: DetailsCVC.identifier)
        detailsCollectionView.register(UINib(nibName: "DescriptionCVC", bundle: nil), forCellWithReuseIdentifier: DescriptionCVC.identifier)
        
        detailsCollectionView.dataSource = self
        detailsCollectionView.delegate = self
        
        detailsCollectionView.backgroundColor = .black
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
            
            if let selectedMovie = selectedMovie, let genre = genre {
                cell.configure(model: selectedMovie, genre: genre)
            } else {
                presentAlert(title: "Error", body: "Failed to get data from server")
            }
            
            cell.changeCollectionCellToDescription = { [weak self] in
                guard let self = self else { return }
                self.detailsCollectionView.reloadData()
            }
            
            cell.changeCollectionCellToReview = { [weak self] in
                guard let self = self else { return }
                self.detailsCollectionView.reloadData()
                cell.id = self.id
            }
            
            return cell
            
        case .description:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DescriptionCVC.identifier, for: indexPath) as? DescriptionCVC else { return UICollectionViewCell() }
            
            if let selectedMovie = selectedMovie {
                cell.configure(model: selectedMovie)
            }
            cell.id = self.id
            
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
            return CGSize(width: collectionView.bounds.width, height: 270.0)
        }
    }
}
