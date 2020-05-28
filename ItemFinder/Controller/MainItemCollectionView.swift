//
//  MainItemCollectionView.swift
//  ItemFinder
//
//  Created by Mattias Törnqvist on 2020-05-15.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit
import Firebase

class MainItemCollectionView: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
//    MARK: - Properties
    lazy var addItemVC: AddItemVC = {
        let vc = AddItemVC()
        return vc
    }()
    
    var uid: String?


//  MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        
        collectionView.frame = view.safeAreaLayoutGuide.layoutFrame
        
//        collectionView.setCollectionViewLayout(UICollectionViewFlowLayout(), animated: true)
        
//        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.identifier)
        
        collectionView.alwaysBounceVertical = true
        
        configureNavBar()
        
        collectionView.backgroundColor = .mainYellow
    }
    
    // initialized with a non-nil layout parameter
//    init() {
//        super.init(collectionViewLayout: UICollectionViewFlowLayout())
//        collectionView.frame = view.safeAreaLayoutGuide.layoutFrame
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
//    MARK: - Helper functions
    
    func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddPressed))
        self.prefersLargeNCTitles()
//        navigationController?.navigationBar.barTintColor = .mainYellow
    }
    
    
//    MARK: - Handlers
    @objc func handleAddPressed() {
        present(addItemVC, animated: true, completion: nil)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.identifier, for: indexPath) as! ItemCell
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 100)
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
