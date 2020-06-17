//
//  Search Item Table View Tests.swift
//  ItemFinderTests
//
//  Created by Mattias Törnqvist on 2020-06-17.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import XCTest
@testable import ItemFinder

class Search_Item_Table_View_Tests: XCTestCase {

    var sut1: SearchTableVC!
    var sut2: SearchTableDataSourceAndDelegate!
    var tableView: UITableView!
    var searchModule: SearchModule!
    var item: Item!
    var indexPath: IndexPath!
    var delegate: SearchTableDelegate!
    var inSearchMode: Bool!
    var filteredModel: [Item]!
    
    override func setUp() {
        sut1 = SearchTableVC()
        tableView = UITableView()
        searchModule = SearchModule()
        delegate = sut1
        inSearchMode = false
        item = Item("123", "Mattias", true, false, ["title": "titel" as Any])
        sut2 = SearchTableDataSourceAndDelegate(delegate: sut1, tableView: tableView, searchModule: searchModule)
        sut2.model.append(item)

        indexPath = IndexPath(row: 0, section: 0)
        
        
    }
    
    func test_item_is_sent_to_delegate_when_row_highlighted() {
        sut2.tableView(tableView, didHighlightRowAt: indexPath)

//        check that the item set in sut 1 is the same as the one passed back by sut 2
        XCTAssertEqual(sut1.selectedItem?.itemId, item.itemId)

    }

}
