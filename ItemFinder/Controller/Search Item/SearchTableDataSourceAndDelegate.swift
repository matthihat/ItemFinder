//
//  SearchTableDataSourceAndDelegate.swift
//  ItemFinderTests
//
//  Created by Mattias Törnqvist on 2020-06-11.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit

class SearchTableDataSourceAndDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var delegate: SearchTableDelegate
    var model = [DownloadedItem]()
    
    init(delegate: SearchTableDelegate) {
        self.delegate = delegate
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchItemTableViewCell.reuseIdentifier) as! SearchItemTableViewCell
        
        cell.item = model[indexPath.row]
        
        return cell
    }
    
    func provideItemDataAndReloadTableView(_ tableView: UITableView, _ item: DownloadedItem) {
        
        let itemAlreadyExistsInModel = model.contains { (existingItem) -> Bool in
            existingItem.itemId == item.itemId
        }
        
        if itemAlreadyExistsInModel == false {
            model.append(item)
            print("DEBUG reloading")
            tableView.reloadData()
        }
    }
    
    func removeAllItemsFromTableView(_ tableView: UITableView) {
        model.removeAll()
        tableView.reloadData()
    }
    
    
}
