//
//  Downloaded Item Tests.swift
//  ItemFinderTests
//
//  Created by Mattias Törnqvist on 2020-06-12.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import XCTest
@testable import ItemFinder

class Downloaded_Item_Tests: XCTestCase {

    var sut: DownloadedItem!
    var id: Int!
    var ownerId: Int!
    var userInfo: [String:AnyObject]!
    var expectedItemIdResult: String!
    
    override func setUp() {
        id = 123
        ownerId = 456
        
        userInfo = [
                    "id":id,
                    "owner_uid":ownerId
                    ] as [String:AnyObject]
        
        sut = DownloadedItem(userInfo)
        expectedItemIdResult = sut.itemId
        
        XCTAssertEqual(expectedItemIdResult, sut.itemId)
    
    }
    
    override func tearDown() {
        sut = nil
        id = nil
        ownerId = nil
        userInfo = nil
        expectedItemIdResult = nil
    }

}
