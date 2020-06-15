//
//  Mock Item Service.swift
//  ItemFinderTests
//
//  Created by Mattias Törnqvist on 2020-06-14.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import Foundation
@testable import ItemFinder

struct MockItemService {
    
    var shouldReturnError = false
    
    enum MockServiceError: Error {
        case invalidData
    }
    
    let mockResponse: [String:Any] = {
        ["id":999,
         "owner_uid": 12345,
         "is_for_sale": true,
         "is_for_give_away": false
        ]
    }()
    
    init(_ shouldReturnError: Bool) {
        self.shouldReturnError = shouldReturnError
    }
    
    init() {
        self.init(false)
    }
}

extension MockItemService: ItemDatabase {
    func fetchCurrentUserItemsInfo(_ uid: String, completion: @escaping (Result<Dictionary<String, Any>, Error>) -> Void) {
                
        if shouldReturnError {
            completion(.failure(MockServiceError.invalidData))
        } else {
            completion(.success(mockResponse))
        }
    }
}
