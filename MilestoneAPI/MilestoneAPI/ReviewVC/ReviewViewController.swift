//
//  ReviewViewController.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 06.07.2022.
//

import UIKit

class ReviewViewController: UIViewController {

    enum DetailsCellType {
        case details
        case review
    }
    
    class func fromStoryboard<T: ReviewViewController>(_ storyboardName: String) -> T {
        let identifier = "ReviewViewController"
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: identifier) as! T
    }
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var movie: SingleMovie?
    private var cellType: [DetailsCellType] = []
    
    
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
        configureCollectionView()
        
    }
    
    private func configureCollectionView() {
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(UINib(nibName: "ReviewCVC", bundle: nil), forCellWithReuseIdentifier: ReviewCVC.identifier)
        collectionView.register(UINib(nibName: "ReviewDetailsCVC", bundle: nil), forCellWithReuseIdentifier: ReviewDetailsCVC.identifier)
        collectionView.register(UINib(nibName: "ReviewCRV", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReviewCRV.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .black
    }
    
    static func construct(cellType: [DetailsCellType], movie: SingleMovie) -> ReviewViewController {
        let controller: ReviewViewController = .fromStoryboard("Main")
        controller.cellType = cellType
        controller.movie = movie
        return controller
    }

}

extension ReviewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(cellType.count)
        return cellType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch cellType[indexPath.row] {
            
        case .details:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewDetailsCVC.identifier, for: indexPath) as? ReviewDetailsCVC else { return UICollectionViewCell() }
            cell.backgroundColor = .black
            if let movie = movie {
                cell.configure(model: movie)
            }
            return cell
        case .review:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCVC.identifier, for: indexPath) as? ReviewCVC else { return UICollectionViewCell() }
            cell.backgroundColor = .black
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReviewCRV.identifier, for: indexPath) as! ReviewCRV
        
        if let movie = movie {
            header.configure(model: movie)
        }
        return header
    }
}

extension ReviewViewController: UICollectionViewDelegate {
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 550)
    }
}

extension ReviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch cellType[indexPath.row] {
            
        case .details:
            return CGSize(width: collectionView.bounds.width, height: 125)
        case .review:
            return CGSize(width: collectionView.bounds.width, height: 300)
        }
    }
}
