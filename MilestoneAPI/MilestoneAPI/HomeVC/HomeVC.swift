//
//  ViewController.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 27.06.2022.
//

import UIKit

class HomeVC: UIViewController {
    
    static func fromStoryboard<T: HomeVC>(_ storyboardName: String) -> T {
        let identifier = "HomeVC"
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: identifier) as! T
    }
    
    
    // MARK: - UI Elements
    @IBOutlet private weak var moviesCollectionView: UICollectionView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var searchBackground: UIView!
    private var searchController: UISearchController!
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Variables
    private var movies: [Movie] = []
    private var genre: [Genre] = []
    private var isFetchingData = false
    private var currentPage = 1
    private var query: String?
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
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        
        configureSearchBar()
        getMovies()
        GenreManager.shared.getGenre()
        configCollection()
        
    }
    
    // MARK: - Functions
    
    static func construct() -> HomeVC {
        let controller: HomeVC = .fromStoryboard("Main")
        return controller
    }
    
    private func configCollection() {
        
        moviesCollectionView.register(UINib(nibName: "HomeCVC", bundle: nil), forCellWithReuseIdentifier: HomeCVC.identifier)
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        moviesCollectionView.refreshControl = refreshControl
    }
    
    private func configureSearchBar() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.tintColor = .white
        searchController.searchBar.searchTextField.textColor = .white
        searchController.searchBar.delegate = self
        searchBackground.backgroundColor = .black
        searchBackground.addSubview(searchController.searchBar)
    }
    
    @objc private func refreshCollectionView(_ sender: UIRefreshControl) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.movies.removeAll()
            self.currentPage = 1
            self.getMovies()
            self.moviesCollectionView.reloadData()
        }
        refreshControl.endRefreshing()
    }
    
    private func searchBarCancelAction() {
        
        movies.removeAll()
        currentPage = 1
        query = ""
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.getMovies()
            self.moviesCollectionView.reloadData()
        }
    }
    
    // MARK: - API Request
    
    private func getMovies() {
        
        activityIndicator.startAnimating()
        
        API.shared.getMovies(atPage: currentPage) {  [weak self] (result) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
            switch result {
                
            case .success(let getMovies ):
                
                self.movies.append(contentsOf: getMovies)
                self.isFetchingData = false
                self.currentPage += 1
                
                DispatchQueue.main.async {
                    self.moviesCollectionView.reloadData()
                }
        
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
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
            switch result {
                
            case .success(let searchMovie):
                self.movies = searchMovie
                self.query = query
                
                DispatchQueue.main.async {
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
        
        let movies = movies[indexPath.row]
        cell.configure(model: movies)
        
        return cell
    }
}

// MARK: - CollectionView Delegate

extension HomeVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let id = movies[indexPath.row].id
        let poster = movies[indexPath.row].backdropPath
        
        let controller = DetailsVC.construct(id: id, poster: poster)
        self.searchController.isActive = false
        self.searchController.searchBar.text = query
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastMovie = movies.count - 1
        
        if indexPath.row == lastMovie && !isFetchingData {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.isFetchingData = true
                self.getMovies()
            }
        }
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
        
        self.searchRequest(with: query)
    }
}

extension HomeVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBarCancelAction()
    }
}
