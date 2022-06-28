//
//  ViewController.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 27.06.2022.
//

import UIKit

class HomeVC: UIViewController {

    // MARK: - UI Elements
    
    @IBOutlet private weak var moviesCollectionView: UICollectionView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    // MARK: - Variables
    
    private var movies: [Movie] = [Movie]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configCollection()
        getMovies()
    }
    
    // MARK: - Functions
    
    private func configCollection() {
        
        moviesCollectionView.register(UINib(nibName: "HomeCVC", bundle: nil), forCellWithReuseIdentifier: HomeCVC.identifier)
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
    }
    
    // MARK: - API Request
    
    private func getMovies() {
        API.shared.getMovies { _ in
            
        }
    }
}

// MARK: - CollectionView Data Source

extension HomeVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return movies.count
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCVC.identifier, for: indexPath) as? HomeCVC else { return UICollectionViewCell() }
        
//        cell.configure(model: movies[indexPath.row])
        
        return cell
    }
}

// MARK: - CollectionView Delegate

extension HomeVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = DetailsVC.construct(id: 8, cellType: [.poster, .details, .description])
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - CollectionView Flow Layout

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: 116.0)
    }
}

