//
//  Item.swift
//  ItemFinder
//
//  Created by Mattias Törnqvist on 2020-05-15.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import Foundation

class Item: NSObject {
    var id: String
    var title: String?
    var itemDescription: String?
    var keywords: [String]?
    var category: String?
    var imageUrl1: String?
    var imageUrl2: String?
    var imageUrl3: String?
    var isForSale: Bool?
    
    init(id: String, dict: Dictionary<String?, String?>, isForSale: Bool?) {
        self.id = id
        
        if let title = dict["title"] {
            self.title = title
        }
        
        if let itemDescription = dict["description"] {
            self.itemDescription = itemDescription
        }
        
        if let category = dict["category"] {
            self.category = category
        }
        
        if let imageUrl1 = dict["imageUrl1"] {
            self.imageUrl1 = imageUrl1
        }
        
        if let imageUrl2 = dict["imageUrl2"] {
           self.imageUrl2 = imageUrl2
        }
        
        if let imageUrl3 = dict["imageUrl3"] {
            self.imageUrl3 = imageUrl3
        }
               
        
        self.isForSale = isForSale
    }
}
