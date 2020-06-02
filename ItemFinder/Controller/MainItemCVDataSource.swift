//
//  MainItemCVDataSource.swift
//  ItemFinder
//
//  Created by Mattias Törnqvist on 2020-05-31.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit

class MainItemCVDataSource: NSObject, UICollectionViewDataSource {

//    MARK: - Properties
    var collectionView: UICollectionView
    
    init(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        
        super.init()
    }
    
//    MARK: - Delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.identifier, for: indexPath) as! ItemCell
        return cell
    }
    
    
}
