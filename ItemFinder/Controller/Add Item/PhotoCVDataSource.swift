//
//  PhotoCVDataSource.swift
//  ItemFinder
//
//  Created by Mattias Törnqvist on 2020-05-28.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit

class PhotoCVDataSource: NSObject, UICollectionViewDataSource {
    
    var reuseIdentifier: String
    
    init(reuseIdentifier: String) {
        self.reuseIdentifier = reuseIdentifier
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ItemPhotoCVCell
        
        return cell
    }
    
//    called from vc, update image with selected image
    func updateCellAtIndexPathWithImage(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, cellWithItemImage image: UIImage) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? ItemPhotoCVCell else { return }
        cell.itemImageView.image = image
        
//        animate image being added
        UIView.animate(withDuration: 0.3) {
            cell.itemImageView.alpha = 1
        }
        
    }
    
//    called from vc, deletes image at cell with index selected indexpath
    func removeItemImageFromCellAtIndexPath(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? ItemPhotoCVCell else { return }
        
//        animate image being deleted
        UIView.animate(withDuration: 0.3, animations: {
            cell.itemImageView.alpha = 0
        }) { (_) in
            cell.itemImageView.image = nil
        }
    }
    
//    remove all item images from all item cells. Typically when view is dismissed
    func removeAllImages(_ collectionView: UICollectionView) {
        
        guard let allCells = collectionView.visibleCells as? [ItemPhotoCVCell] else { return }
        
        allCells.forEach { (cell) in
            cell.itemImageView.image = nil
        }
    }
    
}
