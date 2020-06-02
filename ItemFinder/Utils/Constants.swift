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

enum CustomError: Error {
    case foundNil
    case invalidData
}

enum SportCategories: String {
    case biking = "Biking"
    case running = "Running"
    case skiing = "Skiing"
}



