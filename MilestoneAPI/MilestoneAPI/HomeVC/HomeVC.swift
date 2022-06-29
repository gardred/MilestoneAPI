//
//  ViewController.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 27.06.2022.
//

import UIKit

class HomeVC: UIViewController {

    class func fromStoryboard<T: HomeVC>(_ storyboardName: String) -> T {
        let identifier = "HomeVC"
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: identifier) as! T
    }
    
    
    // MARK: - UI Elements
    
    @IBOutlet private weak var moviesCollectionView: UICollectionView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Variables
    
    private var movies = [Movie]()
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovies()
        
        configCollection()
    }
    
    // MARK: - Functions
    
    private func configCollection() {
        moviesCollectionView.register(UINib(nibName: "HomeCVC", bundle: nil), forCellWithReuseIdentifier: HomeCVC.identifier)
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
    }
    
    // MARK: - API Request
    
    static func construct() -> HomeVC {
        let controller: HomeVC = .fromStoryboard("Main")
        return controller
    }
    
    private func getMovies() {
        API.shared.getMovies { [weak self] (result) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }
            
            switch result {
            case .success(let getMovies ):
                self.movies.append(contentsOf: getMovies)
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.moviesCollectionView.reloadData()
                }
                print(self.movies.count)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - CollectionView Data Source

extension HomeVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCVC.identifier, for: indexPath) as? HomeCVC else { return UICollectionViewCell() }
        cell.configure(model: movies[indexPath.row])
        return cell
    }
}

// MARK: - CollectionView Delegate

extension HomeVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = movies[indexPath.row].id
        let controller = DetailsVC.construct(id: id, cellType: [.poster, .details, .description])
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - CollectionView Flow Layout

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.bounds.width, height: 116.0)
    }
}
