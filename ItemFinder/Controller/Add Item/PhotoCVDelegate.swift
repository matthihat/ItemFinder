//
//  PhotoCVDelegate.swift
//  ItemFinder
//
//  Created by Mattias Törnqvist on 2020-05-28.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit

final class PhotoCVDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: AddItemVCDelegate?
    
    init(withDelegate delegate: AddItemVCDelegate) {
        self.delegate = delegate
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? ItemPhotoCVCell else { return }
        
//        cell.plusPhotoButtonImageView.image = nil
        delegate?.selectedCell(selectedIndexPath: indexPath, selectedCell: cell)
    }
}
