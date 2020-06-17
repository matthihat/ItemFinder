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
    var searchModule: SearchModule
    lazy var validationService = ValidationService()
    var inSearchMode = false {
        didSet {
            tableView.reloadData()
        }
    }
    
//    var includeItemDescriptionInSearch = false
    
    init(delegate: SearchTableDelegate, tableView: UITableView, searchModule: SearchModule) {
        self.delegate = delegate
        self.tableView = tableView
        self.searchModule = searchModule
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
        delegate?.didSelectItem(self.tableView, inSearchMode ? filteredModel?[indexPath.row] : model[indexPath.row])
        
    }
    
    
    func provideItemDataAndReloadTableView(_ item: Item) {
        
        let itemAlreadyExistsInModel = model.contains { (existingItem) -> Bool in
            existingItem.itemId == item.itemId
        }
        
        if itemAlreadyExistsInModel == false {
            model.append(item)
            tableView.reloadData()
        }
    }
    
//    func removeAllItemsFromTableView(_ tableView: UITableView) {
//        model.removeAll()
//        tableView.reloadData()
//    }
    
    func searchInFetchedItems(_ tableView: UITableView, searchText: String, includeItemDescriptionInSearch: Bool) {
        print("DEBUG ", includeItemDescriptionInSearch)
        
//        searches item description in already fetched items
        if includeItemDescriptionInSearch {
            filteredModel = model.filter({ (item) -> Bool in
                return item.description?.lowercased().contains(searchText) ?? false ||
                item.title?.lowercased().contains(searchText) ?? false
            })
        } else {
//            searches item title in already fetched items
            filteredModel = model.filter({ (item) -> Bool in
                return item.title?.lowercased().contains(searchText) ?? false
            })
        }
        
        tableView.reloadData()
    }

    func fetchItemsBasedOnSelectedCriteria() {
        
//        clear items in table view
        model.removeAll()
        tableView.reloadData()
        
//        perform search and fetch items based on criteria
        searchModule.performSearchAndFetchItemInfoDict(completion: { (result) in
            
            switch result {
            case .success(let dict):
                do {
                    
                    guard let validInfo = try self.validationService.validateItemInfoDict(validateDict: dict) else { return }
                    
                    let item = Item(validInfo.itemId, validInfo.ownerUid, validInfo.isForSale, validInfo.isForGiveAway, dict)
                    
//                call methods for inserting item in rows
                    self.provideItemDataAndReloadTableView(item)
                    
                } catch {
//                    if error validating dict from database, print error to console
                    print("DEBUG error", error.localizedDescription)
                }
 
            case .failure(let error):
                self.delegate?.errorFetchingItemsFromDataBase(error)
            }
        })

        tableView.refreshControl?.endRefreshing()
    }
    
}
