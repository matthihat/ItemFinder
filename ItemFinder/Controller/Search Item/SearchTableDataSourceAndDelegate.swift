//
//  SearchTableDataSourceAndDelegate.swift
//  ItemFinderTests
//
//  Created by Mattias Törnqvist on 2020-06-11.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit

class SearchTableDataSourceAndDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegate: SearchTableDelegate?
    var tableView: UITableView!
    var model = [Item]()
    var filteredModel: [Item]?
    var inSearchMode = false {
        didSet {
            tableView.reloadData()
        }
    }
    
//    var includeItemDescriptionInSearch = false
    
    init(delegate: SearchTableDelegate, tableView: UITableView) {
        self.delegate = delegate
        self.tableView = tableView
        super.init()

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredModel?.count ?? 0 : model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchItemTableViewCell.reuseIdentifier) as! SearchItemTableViewCell
        
        cell.item = inSearchMode ? filteredModel?[indexPath.row] : model[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        delegate?.didSelectRow(tableView, indexPath: indexPath)
    }
    
    func provideItemDataAndReloadTableView(_ tableView: UITableView, _ item: Item) {
        
        let itemAlreadyExistsInModel = model.contains { (existingItem) -> Bool in
            existingItem.itemId == item.itemId
        }
        
        if itemAlreadyExistsInModel == false {
            model.append(item)
            tableView.reloadData()
        }
    }
    
    func removeAllItemsFromTableView(_ tableView: UITableView) {
        model.removeAll()
        tableView.reloadData()
    }
    
    func searchItems(_ tableView: UITableView, searchText: String, includeItemDescriptionInSearch: Bool) {
        print("DEBUG ", includeItemDescriptionInSearch)
        
//        MARK: TODO - fix below search
        if includeItemDescriptionInSearch {
            filteredModel = model.filter({ (item) -> Bool in
                return item.description?.lowercased().contains(searchText) ?? false
//                item.title?.lowercased().contains(searchText) ?? false &&
            })
        } else {
            filteredModel = model.filter({ (item) -> Bool in
                return (item.title?.lowercased().contains(searchText))!
            })
        }
        
        tableView.reloadData()
    }
    
    
}
