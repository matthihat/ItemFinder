//
//  SearchItemTableViewCell.swift
//  ItemFinder
//
//  Created by Mattias Törnqvist on 2020-06-07.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit

class SearchItemTableViewCell: UITableViewCell {
    
    static var reuseIdentifier = "reuseIdentifier"
    
    var item: DownloadedItem? {
        didSet {
            textLabel?.text = item?.title
            detailTextLabel?.text = item?.category
            
            if let itemImageUrl = item?.imagesUrls?.components(separatedBy: " ").first {
                itemImageView.loadImage(with: itemImageUrl)
            }
        }
    }
    
    let itemImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Helper functions
    
    func configureUI() {
        backgroundColor = .white
        
        addSubview(itemImageView)
        itemImageView.centerY(inView: self)
        itemImageView.anchor(top: nil, left: contentView.leftAnchor, bottom: nil, paddingLeft: 4, width: contentView.frame.height, height: contentView.frame.height)
        itemImageView.layer.cornerRadius = (contentView.frame.height) / 2

    }

}
