//
//  Search Options Menu View Tests.swift
//  ItemFinderTests
//
//  Created by Mattias Törnqvist on 2020-06-09.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import XCTest
@testable import ItemFinder

class Search_Options_Menu_View_Tests: XCTestCase {

    var sut: SearchOptionsMenuView!
    var currentCity: String!
    var currentAdminArea: String!
    var expectedResultCity: String!
    var expectedRAdminArea: String!
    
//    given
    override func setUp() {
        super.setUp()
        
        sut = SearchOptionsMenuView()
        currentCity = "Söderhamn"
        currentAdminArea = "Gävleborg"
        expectedResultCity = "Search items in: Söderhamn"
        expectedRAdminArea = "Extend search to: Gävleborg"
        
    }
    
    override func tearDown() {
        super.tearDown()
        
        sut = nil
        currentCity = nil
        currentAdminArea = nil
        expectedResultCity = nil
        expectedRAdminArea = nil
    }
    
//    when
    func test_citylabel_displays_current_city() {
        sut.displayCityLocation(currentCity)
        guard let text = sut.cityLabel.text else { return }
        
//        then
        XCTAssertEqual(expectedResultCity, text)
    }
    
    func test_administrative_area_label_displays_current_area() {
        sut.displayAdminAreaLocation(currentAdminArea)
        guard let text = sut.administrativeAreaLabel.text else { return }
        
        XCTAssertEqual(expectedRAdminArea, text)
    }
    

}
