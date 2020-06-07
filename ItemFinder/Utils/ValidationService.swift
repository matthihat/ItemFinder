//
//  ValidationService.swift
//  ItemFinder
//
//  Created by Mattias Törnqvist on 2020-05-28.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import Foundation

struct ValidationService {
    
    func validateItem(validateItem item: ItemForUpload?) throws -> ItemForUpload? {
        guard let item = item else { throw ValidationError.invalidValue}
        
//        validate title
        guard let title = item.title else { throw ValidationError.invalidValue}
        guard title.count > 3 else { throw ValidationError.titleTooShort}
        guard title.count < 60 else { throw ValidationError.titleTooLong}
        guard item.isForSale && !item.isForGiveAway || item.isForGiveAway && !item.isForSale || item.isForSale == false && item.isForGiveAway == false else { throw ValidationError.itemIsForSaleAndForGiveAway}
        return item
    }
    
    
    enum ValidationError: LocalizedError {
        case invalidValue
        case titleTooShort
        case titleTooLong
        case itemIsForSaleAndForGiveAway
        
        var errorDescription: String? {
            switch self {
            case .invalidValue:
                return "No item title provided."
            case .titleTooShort:
                return "Title is too short."
            case .titleTooLong:
                return "Title is too long."
            case .itemIsForSaleAndForGiveAway:
                return "Item can not be for sale and for give away."
            }
        }
    }
}
