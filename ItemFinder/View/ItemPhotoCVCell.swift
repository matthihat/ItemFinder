//
//  ItemPhotoCVCell.swift
//  ItemFinder
//
//  Created by Mattias Törnqvist on 2020-05-21.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit

class ItemPhotoCVCell: UICollectionViewCell {
    
    lazy var plusPhotoButtonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "plus_photo")
        return imageView
    }()
    
    lazy var itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0
        return imageView
    }()
    
//    MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        backgroundColor = .red
        
        addSubviews(plusPhotoButtonImageView, itemImageView)
        plusPhotoButtonImageView.frame = contentView.frame
        
        itemImageView.frame = contentView.frame
    }
}
