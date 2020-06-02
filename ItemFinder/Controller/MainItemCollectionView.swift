//
//  MainItemCollectionView.swift
//  ItemFinder
//
//  Created by Mattias Törnqvist on 2020-05-15.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit
import Firebase

class MainItemCollectionView: UICollectionViewController {
    
//    MARK: - Properties
    lazy var addItemVC: AddItemVC = {
        let vc = AddItemVC()
        return vc
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(handleReloadData), for: .valueChanged)
        return refresh
    }()
    
    var mainItemCVDataSource: MainItemCVDataSource?
    
    var uid: String?


//  MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        
        configureNavBar()
        
        configureCollectionViewDataSource()

        configureCollectionView()
        
        
        
        configureRefreshControl()
    }
    
    
//    MARK: - Helper functions
    
    func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddPressed))
        
        self.prefersLargeNCTitles()
    }
    
    func configureCollectionViewDataSource() {
        mainItemCVDataSource = MainItemCVDataSource(self.collectionView)
    }
    
    func configureCollectionView() {
        collectionView.backgroundColor = .mainYellow
        
        collectionView.frame = view.safeAreaLayoutGuide.layoutFrame
        
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.identifier)
        
        collectionView.dataSource = mainItemCVDataSource
        collectionView.delegate = self
        
        collectionView.alwaysBounceVertical = true
    }
    
    func configureRefreshControl() {
        collectionView.refreshControl = refreshControl
    }
    
//    delegate methods
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("DEBUG selected", indexPath.row)
        
    }
    
    
//    MARK: - Handlers
    @objc func handleAddPressed() {
        present(addItemVC, animated: true, completion: nil)
    }
    
    @objc func handleReloadData() {
        
        Service.shared.fetchItem()
        
        self.refreshControl.endRefreshing()
            
    }
    



    
//    check if user is logged in and if not set LoginVC as root VC
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            
            DispatchQueue.main.async {
            let nav = UINavigationController(rootViewController: LoginVC())
            if #available(iOS 13.0, *) {
                nav.isModalInPresentation = true
            }
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: false, completion: nil)
            }
            
        }
    }
}

extension MainItemCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 100)
    }

}
