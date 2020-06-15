//
//  DownloadedItem.swift
//  ItemFinder
//
//  Created by Mattias Törnqvist on 2020-06-07.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit
import Require



protocol ImmutableItem {
    var itemId: String { get }
    var ownerUid: String { get }
}

struct DownloadedItem {
    
    var itemId: String
    var ownerUid: String
//    var title: String?
//    var keywords: String?
//    var description: String?
//    var imagesUrls: String?
    var isForSale: Bool
    var isForGiveAway: Bool
//    var category: String?
    
    init(_ dict: Dictionary<String,Any>) {
//        self.itemId = dict["id"].require(hint: "DEBUG: No item id (String) was found in downloaded item dictionary")
        
        guard let itemId = dict["id"] as? String else {
            fatalError("DEBUG: No item id (String) was found in downloaded item dictionary")
            return
        }
        
        guard let ownerUid = dict["owner_uid"] as? String else {
            fatalError("DEBUG: No owner id (String) was found in downloaded item dictionary")
            return
        }
        
        guard let isForSale = dict["is_for_sale"] as? Bool else {
            fatalError("DEBUG: No is for sale info (Bool) was found in downloaded item dictionary")
            return
        }
        
        guard let isForGiveAway = dict["is_for_give_away"] as? Bool else {
            fatalError("DEBUG: No is for give away info (Bool) was found in downloaded item dictionary")
            return
        }
        
        self.itemId = itemId
        self.ownerUid = ownerUid
        self.isForSale = isForSale
        self.isForGiveAway = isForGiveAway
        
//        self.ownerUid = dict["owner_uid"].require(hint: "DEBUG: No item id (String) was found in downloaded item dictionary")
        
//        self.isForSale = dict["is_for_sale"] as? Bool

//        self.isForGiveAway = dict["is_for_give_away"] as! Bool
        
        //guard let id = dict["id"] as? String else {
            //MARK: - TODO throw error if not initialized correctly
          //  return
       // }
        //self.itemId = id
        
//        self.ownerUid = dict["owner_uid"] as! String
        
//        if let title = dict["title"] as? String {
//            self.title = title
//        }
//
//        if let keywords = dict["keywords"] as? String {
//            self.keywords = keywords
//        }
//
//        if let description = dict["description"] as? String {
//            self.description = description
//        }
//
//        if let imagesUrls = dict["image_url"] as? String {
//            self.imagesUrls = imagesUrls
//        }
//
//        self.isForSale = dict["is_for_sale"] as! Bool
//
//        self.isForGiveAway = dict["is_for_give_away"] as! Bool
//
//        if let category = dict["category"] as? String {
//            self.category = category
//        }
    }
}
    
extension DownloadedItem: ImmutableItem {
    
//    typealias itemInfo = (Dictionary<String,AnyObject>)
    
//    func completedItem(with itemInfo: Dictionary<String,Any>) -> Item {
//        return Item(itemId,
//                    ownerUid,
//                    isForSale,
//                    isForGiveAway,
//                    itemInfo)
//    }
    
}

struct Item: ImmutableItem {
    
    var itemId: String
    var ownerUid: String
    var title: String?
    var keywords: String?
    var description: String?
    var imagesUrls: String?
    var isForSale: Bool
    var isForGiveAway: Bool
    var category: String?

    init(_ itemId: String, _ ownerUid: String, _ isForSale: Bool, _ isForGiveAway: Bool, _ dict: Dictionary<String,Any>) {
        self.itemId = itemId
        self.ownerUid = ownerUid
        self.isForSale = isForSale
        self.isForGiveAway = isForGiveAway
               
//       self.ownerUid = dict["owner_uid"] as! String
       
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
       
//       self.isForSale = dict["is_for_sale"] as! Bool
       
//       self.isForGiveAway = dict["is_for_give_away"] as! Bool
       
       if let category = dict["category"] as? String {
           self.category = category
       }
    }
}
