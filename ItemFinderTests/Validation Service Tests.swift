//
//  Validation Service Tests.swift
//  ItemFinderTests
//
//  Created by Mattias Törnqvist on 2020-06-07.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

@testable import ItemFinder
import XCTest

class Validation_Service_Tests: XCTestCase {

    var sut: ValidationService!
    var dict: [String:Any]!
    var unvalidDict: [String:Int]!
    
    override func setUp() {
        super.setUp()
        
        sut = ValidationService()
        
        dict = ["title":"Grejen 1",
        "id": "123",
        "owner_uid":"999",
        "is_for_sale": true,
        "is_for_give_away": false] as [String:Any]
        
        unvalidDict = ["första":123]
        
        
    }
    
    override func tearDown() {
        super.tearDown()
        
        sut = nil
        dict = nil
        unvalidDict = nil

    }
    
    func test_is_item_title_nil() throws {
        let item = ItemForUpload(nil, nil, nil, nil, true, false, nil)
        let expectedError = ValidationService.ValidationError.invalidValue
        var error: ValidationService.ValidationError?
        
        XCTAssertThrowsError(try sut.validateItem(validateItem: item)) {
            thrownError in
            error = thrownError as? ValidationService.ValidationError
        }
        
        XCTAssertEqual(expectedError, error)
    }
    
    func test_is_valid_item_title() throws {
        XCTAssertNoThrow(try sut.validateItem(validateItem: ItemForUpload("abcd", nil, nil, nil, true, false, nil)))
    }
    
    func test_is_item_title_too_short() throws {
        let item = ItemForUpload("aa", nil, nil, nil, true, false, nil)
        let expectedError = ValidationService.ValidationError.titleTooShort
        var error: ValidationService.ValidationError?
        
        XCTAssertThrowsError(try sut.validateItem(validateItem: item)) {
            thrownError in
            error = thrownError as? ValidationService.ValidationError
        }
        
        XCTAssertEqual(expectedError, error)
    }
    
    func test_is_item_title_too_long() throws {
        let item = ItemForUpload("aaaaaaaaaaaaaaaaagggggggggggggggggggbbbbbbbbbbbbbbbbbrrrrrrrrrrbrbrbrbrbrbrbrbrbrbrbrbrbrbrbrbrbrbbrbrbrbrbrbrbrbrbrbr", nil, nil, nil, true, false, nil)
        let expectedError = ValidationService.ValidationError.titleTooLong
        var error: ValidationService.ValidationError?
        
        XCTAssertThrowsError(try sut.validateItem(validateItem: item)) { thrownError in
            error = thrownError as? ValidationService.ValidationError
        }
        
        XCTAssertEqual(expectedError, error)
    }
    
    func test_is_dictionary_valid() throws {
        XCTAssertNoThrow(try sut.validateItemInfoDict(validateDict: dict))
    }
    
    func test_is_dictionary_unvalid() throws {
        var error = ValidationService.ValidationError.invalidValue
        
        XCTAssertThrowsError(try sut.validateItemInfoDict(validateDict: unvalidDict)) {
            thrownError in
            error = (thrownError as? ValidationService.ValidationError)!
        }
    }

}
