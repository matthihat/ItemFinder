//
//  MainItemCVDataSource.swift
//  ItemFinder
//
//  Created by Mattias Törnqvist on 2020-05-31.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class MainItemCVDataSource: NSObject, UICollectionViewDataSource {

//    MARK: - Properties
    var collectionView: UICollectionView
    
    var model = [Item]()
    
    private let database: ItemDatabase
    
    private let validationService = ValidationService()
    
    init(_ collectionView: UICollectionView, _ database: ItemDatabase) {
        self.collectionView = collectionView
        self.database = database
        
        super.init()
        
        fetchUserItems()
        
    }
    
//    MARK: - API
    func fetchUserItems() {
        
//        clear items in model when reloading all items
        model.removeAll()
        collectionView.reloadData()
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        database.fetchCurrentUserItemsInfo(uid) { (result) in
            
            var itemCounter = -1
            
            switch result {
            case .success(let itemInfo):
            
                do {
                    if let validatedInfo = try self.validationService.validateItemInfoDict(validateDict: itemInfo) {
                        
                        let item = Item(validatedInfo.itemId, validatedInfo.ownerUid, validatedInfo.isForSale, validatedInfo.isForGiveAway, itemInfo)
                        
                        self.model.append(item)
                    }
                    
                } catch {
                    print(error)
                }
                
//                append item to model
//                self.model.append(item)

                itemCounter += 1
                let indexPath: IndexPath = .init(row: itemCounter, section: 0)
                
//                perform animations
                self.collectionView.performBatchUpdates({

                    self.collectionView.insertItems(at: [indexPath])
                    
                }, completion: { (_) in
//                    reload collection view
                    self.collectionView.reloadData()
                })
                
                
            case .failure(let error):
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }
        }
    }
    
//    MARK: - Delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.identifier, for: indexPath) as! ItemCell
        
        cell.item = model[indexPath.row]
        
        return cell
    }
    
    
}
