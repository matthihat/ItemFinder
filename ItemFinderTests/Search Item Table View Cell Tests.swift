//
//  Search Item Table View Cell Tests.swift
//  ItemFinderTests
//
//  Created by Mattias Törnqvist on 2020-06-11.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import XCTest
@testable import ItemFinder

class Search_Item_Table_View_Cell_Tests: XCTestCase {

    var sut: SearchItemTableViewCell!
    var dict: [String:Any]!
    var item: Item!
    var expectedResult: String!
    var text: String!
    var validationService: ValidationService!
    
    override func setUp() {
        sut = SearchItemTableViewCell()
        
        dict = ["title":"Grejen 1",
                "id": "123",
                "owner_uid":"999",
                "is_for_sale": true,
                "is_for_give_away": false] as [String:Any]
        
//        unvalidDict = ["första":123]
        
        validationService = ValidationService()
        
        
        sut.item = item
        expectedResult = "Grejen 1"
    }
    
    override func tearDown() {
        sut = nil
        item = nil
        expectedResult = nil
        validationService = nil
        text = nil
    }
    
    func test_titlelabel_displays_item_title_Grejen1() {
        
        do {
            
            guard let validDict = try validationService.validateItemInfoDict(validateDict: dict) else {
                XCTFail()
                return
            }
            
            let item = Item(validDict.itemId, validDict.ownerUid,
                            validDict.isForSale, validDict.isForGiveAway,
                            dict)
            
            sut.item = item
            text = sut.titleLabel.text
            XCTAssertEqual(expectedResult, text)
            
            
        } catch {}
    }

}
