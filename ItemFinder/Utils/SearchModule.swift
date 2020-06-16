//
//  SearchModule.swift
//  ItemFinderTests
//
//  Created by Mattias Törnqvist on 2020-06-11.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit

class SearchModule: NSObject {
    
    private var currentCountry: String?
    private var currentAdminArea: String?
    private var currentCity: String?
    private var extendSearch = false
    private var searchInAllCategories = true
    private var searchItemsForGiveAway = true
    private var searchInCategory: SportCategories?
    private let locationManager = LocationManager.shared
    private let service = Service.shared
    
    override init() {
        super.init()
        
        getLocations()
        
    }
    
//    get uses location placemarks
    func getLocations() {
        locationManager.getCountry { (result) in
            switch result {
            case .success(let country):
                self.currentCountry = country
            case .failure(_):
                self.currentCountry = nil
            }
        }
        
        locationManager.getAdministrativeArea { (result) in
            switch result {
            case .success(let adminArea):
                self.currentAdminArea = adminArea
            case .failure(_):
                self.currentAdminArea = nil
            }
        }
        
        locationManager.getCity { (result) in
            switch result {
            case .success(let city):
                self.currentCity = city
            case .failure(_):
                self.currentCity = nil
            }
        }
    }
    
//    update search criteria if new criteria was entered
    func updateSearchCriteria(_ extendSearch: Bool, _ searchInAllCategories: Bool, _ searchItemsForGiveAway: Bool, _ searchInCategory: SportCategories?) {
        
        self.extendSearch = extendSearch
        self.searchInAllCategories = searchInAllCategories
        self.searchItemsForGiveAway = searchItemsForGiveAway
        self.searchInCategory = searchInCategory
        
    }
    
//    perform search
//    MARK: TODO change return value so that it returns i dict with item info
    func performSearchAndFetchItemInfoDict(completion: @escaping(Result<Dictionary<String,Any>, SearchItemError>) -> Void) {
        
        
        guard let country = currentCountry,
            let adminArea = currentAdminArea,
            let city = currentCity
            else {
                completion(.failure(.couldNotSearchInArea))
                return
        }
        
//        perform search in all categories in current city. - Default search
        if searchInAllCategories == true && extendSearch == false && searchItemsForGiveAway == true {
            
            service.searchItemsForSaleAndGiveAwayInAllCategoriesInCurrentCity(country, city) { (result) in
                switch result {
                case .success(let dict):
                    completion(.success(dict))
                    Void()
                case .failure(_):
                    completion(.failure(.failedToFetchItems))
                }
            }
        }
        
//        perform search in all categories in current admin area. - widest search
        if searchInAllCategories == true && extendSearch == true && searchItemsForGiveAway == true {
            service.searchItemsForSaleInAllCategoriesInCurrentAdminArea(country, adminArea) { (result) in
                
                switch result {
                case .success(let dict):
                        completion(.success(dict))
                    case .failure(_):
                        completion(.failure(.failedToFetchItems))
                }
            }
        }
    }
}

