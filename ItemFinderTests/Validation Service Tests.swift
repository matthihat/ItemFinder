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
    
    override func setUp() {
        super.setUp()
        
        sut = ValidationService()
        
        
    }
    
    override func tearDown() {
        super.tearDown()
        
        sut = nil
    }
    
    func test_is_item_title_nil() throws {
        let item = ItemForUpload(nil, nil, nil, nil, true, nil)
        let expectedError = ValidationService.ValidationError.invalidValue
        var error: ValidationService.ValidationError?
        
        XCTAssertThrowsError(try sut.validateItem(validateItem: item)) {
            thrownError in
            error = thrownError as? ValidationService.ValidationError
        }
        
        XCTAssertEqual(expectedError, error)
    }
    
    func test_is_valid_item_title() throws {
        XCTAssertNoThrow(try sut.validateItem(validateItem: ItemForUpload("abcd", nil, nil, nil, true, nil)))
    }
    
    func test_is_item_title_too_short() throws {
        let item = ItemForUpload("aa", nil, nil, nil, true, nil)
        let expectedError = ValidationService.ValidationError.titleTooShort
        var error: ValidationService.ValidationError?
        
        XCTAssertThrowsError(try sut.validateItem(validateItem: item)) {
            thrownError in
            error = thrownError as? ValidationService.ValidationError
        }
        
        XCTAssertEqual(expectedError, error)
    }
    
    func test_is_item_title_too_long() throws {
        let item = ItemForUpload("aaaaaaaaaaaaaaaaagggggggggggggggggggbbbbbbbbbbbbbbbbbrrrrrrrrrrbrbrbrbrbrbrbrbrbrbrbrbrbrbrbrbrbrbbrbrbrbrbrbrbrbrbrbr", nil, nil, nil, true, nil)
        let expectedError = ValidationService.ValidationError.titleTooLong
        var error: ValidationService.ValidationError?
        
        XCTAssertThrowsError(try sut.validateItem(validateItem: item)) { thrownError in
            error = thrownError as? ValidationService.ValidationError
        }
        
        XCTAssertEqual(expectedError, error)
    }

}
