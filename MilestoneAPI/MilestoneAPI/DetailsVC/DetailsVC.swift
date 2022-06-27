//
//  DetailsVC.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 27.06.2022.
//

import UIKit

class DetailsVC: UIViewController {
    
    enum CellType {
        case poster
        case details
        case buttons
    }

    // MARK: - UI Elements
    
@IBOutlet weak var detailsCollectionView: UICollectionView!
    
    // MARK: - Variables
    private var cellType: [CellType] = [.poster, .details, .buttons]
    private var singleMove: Movie?
    
    public var id: Int = 0
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        getSingleMovie()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configCollection()
    }
    
    // MARK: - Functions
    
    private func configCollection() {
        
        detailsCollectionView.register(UINib(nibName: "PosterCVC", bundle: nil), forCellWithReuseIdentifier: PosterCVC.identifier)
        detailsCollectionView.register(UINib(nibName: "DetailsCVC", bundle: nil), forCellWithReuseIdentifier: DetailsCVC.identifier)
        detailsCollectionView.register(UINib(nibName: "ButtonsCVC", bundle: nil), forCellWithReuseIdentifier: ButtonsCVC.identifier)
        detailsCollectionView.register(UINib(nibName: "ReviewCVC", bundle: nil), forCellWithReuseIdentifier: ReviewCVC.identifier)
        
        detailsCollectionView.dataSource = self
        detailsCollectionView.delegate = self
        
        detailsCollectionView.backgroundColor = .black
    }
    
    // MARK: - API Request
    
    private func getSingleMovie() {
        API.shared.getMovieById(id: id) { _ in
            
        }
    }
}

// MARK: - UICollectionView Data Source

extension DetailsVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(cellType.count)
        return cellType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch cellType[indexPath.row] {
            
        case .poster:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCVC.identifier, for: indexPath) as! PosterCVC
            
            if let singleMovie = singleMove {
                cell.configure(model: singleMovie)
            }
            return cell
            
        case .details:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsCVC.identifier, for: indexPath) as! DetailsCVC
            if let singleMovie = singleMove {
                cell.configure(model: singleMovie)
            }
            return cell
            
        case .buttons:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonsCVC.identifier, for: indexPath) as! ButtonsCVC
            
            cell.presentReviewCell = {
                print("Change cell")
            }
            return cell
        }
    }
}

// MARK: - UICollectionView Flow Layout

extension DetailsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch cellType[indexPath.row] {
            
        case .poster:
            return CGSize(width: 390.0, height: 340.0)
        case .details:
            return CGSize(width: 390.0, height: 112.0)
        case .buttons:
            return CGSize(width: 390.0, height: 70.0)
        }
    }
}
