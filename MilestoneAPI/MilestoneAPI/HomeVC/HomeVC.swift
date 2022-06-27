//
//  ViewController.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 27.06.2022.
//

import UIKit

class HomeVC: UIViewController {

    // MARK: - UI Elements
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
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
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCVC.identifier, for: indexPath) as! HomeCVC
        
        return cell
    }
}

// MARK: - CollectionView Delegate

extension HomeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

// MARK: - CollectionView Flow Layout

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 358.0, height: 116.0)
    }
}

