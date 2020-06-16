//
//  Item Service Tests.swift
//  ItemFinderTests
//
//  Created by Mattias Törnqvist on 2020-06-14.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import XCTest
@testable import ItemFinder

class Item_Service_Tests: XCTestCase {
    
    var sut: MockItemService!
    var expectedResponse: Dictionary<String, Any>!
    enum MockServiceError: Error {
        case invalidData
    }
    var expectedError: MockServiceError!
    var err = MockServiceError.invalidData

    override func setUp() {
        sut = MockItemService()
        expectedResponse = ["id":999,
         "owner_uid": 12345,
         "is_for_sale": true,
         "is_for_give_away": false
        ]

    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testItemInfoResponse() {
        
        let expectation = self.expectation(description: "Fetch item info response expectation")
        sut.shouldReturnError = true
        
        sut.fetchCurrentUserItemsInfo("uid") { (result) in
            
            switch result {
            case .success(let dict):
                let firstKey = dict.keys.first
                XCTAssertEqual(self.expectedResponse.keys.first, firstKey)
            case .failure(let error):
                
                XCTAssertEqual(self.expectedError, error as? Item_Service_Tests.MockServiceError)
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 3, handler: nil)
        
    }

}
