//
//  DownloadedItem.swift
//  ItemFinder
//
//  Created by Mattias Törnqvist on 2020-06-07.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit

struct DownloadedItem {
    
    var itemId: String
    var ownerUid: String
    var title: String?
    var keywords: String?
    var description: String?
    var imagesUrls: String?
    var isForSale: Bool
    var isForGiveAway: Bool
    var category: String?
    
    init(_ dict: Dictionary<String,AnyObject>) {
        self.itemId = dict["id"] as! String
        
        self.ownerUid = dict["ownerUid"] as! String
        
        if let title = dict["title"] as? String {
            self.title = title
        }
        
        if let keywords = dict["keywords"] as? String {
            self.keywords = keywords
        }
        
        if let description = dict["description"] as? String {
            self.description = description
        }
        
        if let imagesUrls = dict["image_url"] as? String {
            self.imagesUrls = imagesUrls
        }
        
        self.isForSale = dict["is_for_sale"] as! Bool
        
        self.isForGiveAway = dict["is_for_give_away"] as! Bool
        
        if let category = dict["category"] as? String {
            self.category = category
        }
    }
}
