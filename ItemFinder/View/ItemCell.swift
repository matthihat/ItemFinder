//
//  ItemCell.swift
//  ItemFinder
//
//  Created by Mattias Törnqvist on 2020-05-15.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    
    static var identifier = "Cell"
    
    var item: Item? {
        didSet {
            titleLabel.text = item?.title
            categoryLabel.text = item?.category
            descriptionLabel.text = item?.description
            keywordsLabel.text = item?.keywords
            isForSaleLabel.text = item?.isForSale == true ? "For sale" : "Not for sale"
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading"
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading"
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading"
        return label
    }()
    
    let isForSaleLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading"
        return label
    }()
    
    let keywordsLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading"
        return label
    }()
    
//    MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Helper functions
    func configureUI() {
        backgroundColor = .white
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, categoryLabel,descriptionLabel,isForSaleLabel,keywordsLabel])
        
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.anchor(top: self.safeAreaLayoutGuide.topAnchor, left: leftAnchor)
        
        
    }
}
