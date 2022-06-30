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
    @IBOutlet private weak var searchBackground: UIView!
    
    // MARK: - Variables
    
    private var movies = [Movie]()
    private var genre = [Genre]()
    private var searchController: UISearchController!
    // MARK: - Lifecycle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
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
       
        view.backgroundColor = .black
        configureSearchBar()
        
        getMovies()
        getGenre()
        
        configCollection()
    }
    
    // MARK: - Functions
    
    private func configCollection() {
        moviesCollectionView.register(UINib(nibName: "HomeCVC", bundle: nil), forCellWithReuseIdentifier: HomeCVC.identifier)
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
    }
    
    private func configureSearchBar() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchBackground.backgroundColor = .black
        searchBackground.addSubview(searchController.searchBar)
    }
    
    static func construct() -> HomeVC {
        let controller: HomeVC = .fromStoryboard("Main")
        return controller
    }
    
    // MARK: - API Request
    
    private func getMovies() {
        
        activityIndicator.startAnimating()
        
        API.shared.getMovies { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
                
            case .success(let getMovies ):
                self.movies.append(contentsOf: getMovies)
                
                DispatchQueue.main.async {
                    
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.moviesCollectionView.reloadData()
                    
                    if self.movies.count >= 19 {
                        self.getGenre()
                    }
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
    
    private func searchRequest(with query: String) {
        
        activityIndicator.startAnimating()
        API.shared.search(with: query) { [weak self] (result) in
            
            guard let self = self else { return}
            
            switch result {
                
            case .success(let searchMovie):
                self.movies = searchMovie
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.moviesCollectionView.reloadData()
                }
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    self.presentAlert(title: "Error", body: error.localizedDescription)
                }
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
        
        cell.configure(model: movies[indexPath.row], genre: genre[indexPath.row])
        
        return cell
    }
}

// MARK: - CollectionView Delegate

extension HomeVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let id = movies[indexPath.row].id
        let genre = genre[indexPath.row].name
        let controller = DetailsVC.construct(id: id, genre: genre, cellType: [.poster, .details, .description])
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - CollectionView Flow Layout

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: 116.0)
    }
}

// MARK: - UI SearchBar delegate

extension HomeVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty, query.trimmingCharacters(in: .whitespaces).count >= 3 else { return }
        
        searchRequest(with: query)
    }
}
