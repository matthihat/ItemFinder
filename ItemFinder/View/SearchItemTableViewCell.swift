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
//            textLabel?.text = item?.title
//            detailTextLabel?.text = item?.itemId
            titleLabel.text = item?.title
            itemIdLabel.text = item?.itemId
            
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
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading"
        return label
    }()
    
    let itemIdLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading"
        return label
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
        let imageDiameter = contentView.frame.height - 8
        
        contentView.addSubview(itemImageView)
        itemImageView.centerY(inView: self.contentView)
        itemImageView.anchor(top: nil, left: contentView.leftAnchor, bottom: nil, paddingLeft: 4, width: imageDiameter, height: imageDiameter)
        itemImageView.layer.cornerRadius = imageDiameter / 2

        contentView.addSubview(titleLabel)
        titleLabel.anchor(top: itemImageView.topAnchor, left: itemImageView.rightAnchor, paddingLeft: 8)
        
        contentView.addSubview(itemIdLabel)
        itemIdLabel.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, paddingTop: 8)
    }

}
