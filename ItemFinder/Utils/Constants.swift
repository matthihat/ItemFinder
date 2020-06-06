//
//  Constants.swift
//  ItemFinder
//
//  Created by Mattias Törnqvist on 2020-05-18.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import Foundation
import Firebase

let REF = Database.database().reference()
let USER_REF = REF.child("user")
let REF_ITEMS = REF.child("items")
let STORAGE = Storage.storage().reference()
let STORAGE_IMAGE = STORAGE.child("image")
let REF_KEYWORD = REF.child("keyword_item_id")
let REF_ITEM_FOR_SALE = REF.child("item_for_sale")
let REF_CATEGORY = REF.child("category")
let REF_CATEGORY_SPORT = REF_CATEGORY.child("sport")
let REF_BIKING = REF_CATEGORY_SPORT.child(SportCategories.biking.dbRef)
let REF_RUNNING = REF_CATEGORY_SPORT.child(SportCategories.running.dbRef)
let REF_SKIING = REF_CATEGORY_SPORT.child(SportCategories.skiing.dbRef)
let REF_GEO = REF.child("locations")
let REF_LOCATIONS_ADMINISTRATIVE_AREA = REF_GEO.child("administrative_area")
let REF_LOCATIONS_LOCALITY = REF_GEO.child("locality")

enum CustomError: Error {
    case foundNil
    case invalidData
}

enum SportCategories: String {
    case biking = "Biking"
    case running = "Running"
    case skiing = "Skiing"
    
    var dbRef: String {
        return self.rawValue.lowercased()
    }
}



