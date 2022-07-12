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
    
    static func fromStoryboard<T: ReviewViewController>(_ storyboardName: String) -> T {
        let identifier = "ReviewViewController"
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: identifier) as! T
    }
    
    // MARK: - UIElements
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var footerView: UIView!
    
    // MARK: - Variables
    private var movie: SingleMovie?
    private var cells: [DetailsCellType] = []
    
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
        
        configureUI()
        configureCollectionView()
    }
    
    // MARK: - Functions
    
    private func configureUI() {
        
        submitButton.layer.cornerRadius = 8
        submitButton.backgroundColor = hexStringToUIColor(hex: "#606DDE").withAlphaComponent(0.5)
        submitButton.isUserInteractionEnabled = false
        
        footerView.backgroundColor = .black
    }
    
    private func configureCollectionView() {
        
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(UINib(nibName: "ReviewCVC", bundle: nil), forCellWithReuseIdentifier: ReviewCVC.identifier)
        collectionView.register(UINib(nibName: "ReviewDetailsCVC", bundle: nil), forCellWithReuseIdentifier: ReviewDetailsCVC.identifier)
        collectionView.register(UINib(nibName: "ReviewCRV", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReviewCRV.identifier)
        collectionView.collectionViewLayout = HeaderViewLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .black
    }
    
    static func construct(cellType: [DetailsCellType], movie: SingleMovie) -> ReviewViewController {
        let controller: ReviewViewController = .fromStoryboard("Main")
        controller.cells = cellType
        controller.movie = movie
        return controller
    }

    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

    // MARK: - UICollectionView Data Source

extension ReviewViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch cells[indexPath.row] {
            
        case .details:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewDetailsCVC.identifier, for: indexPath) as? ReviewDetailsCVC else { return UICollectionViewCell() }
           
            
            
            if let movie = movie {
                cell.configure(model: movie)
            }
            
            return cell
       
        case .review:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCVC.identifier, for: indexPath) as? ReviewCVC else { return UICollectionViewCell() }
            
            cell.disableButtonInteraction = { [weak self] in
                guard let self = self else { return }
                self.submitButton.isUserInteractionEnabled = true
                self.submitButton.backgroundColor = hexStringToUIColor(hex: "#606DDE").withAlphaComponent(1.0)
            }
            
            cell.enableButtonInteraction = { [weak self] in
                guard let self = self else { return }
                self.submitButton.isUserInteractionEnabled = false
                self.submitButton.backgroundColor = hexStringToUIColor(hex: "#606DDE").withAlphaComponent(0.5)
            }
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

    // MARK: - UICollectionView Delegate

extension ReviewViewController: UICollectionViewDelegate {
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 200)
    }
}

    // MARK: - UICollectionView Flow Layout
extension ReviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch cells[indexPath.row] {
            
        case .details:
            return CGSize(width: collectionView.bounds.width, height: 190)
        case .review:
            return CGSize(width: collectionView.bounds.width, height: 350)
        }
    }
}
