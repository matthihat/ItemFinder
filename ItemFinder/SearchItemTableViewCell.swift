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
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .green
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
