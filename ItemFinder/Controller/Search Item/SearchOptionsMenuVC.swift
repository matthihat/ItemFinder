//
//  SearchOptionsMenuVC.swift
//  ItemFinder
//
//  Created by Mattias Törnqvist on 2020-06-07.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit
import SVProgressHUD

class SearchOptionsMenuVC: UIViewController {
    
    weak var delegate: SearchOptionsMenuDelegate?
    let searchView = SearchOptionsMenuView()
    let locationManager = LocationManager()
    var currentCity: String?
    var currentAdministrativeArea: String?
    var currentCountry: String?
    var searchItemsForGiveAway = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        getUsersCurrentLocation()
        
    }
    
    func configureView() {
        view = searchView
        searchView.delegate = self
    }
    
    func getUsersCurrentLocation() {
        locationManager.getCity { (result) in
            
            switch result {
            case .success(let currentCity):
                self.currentCity = currentCity
               
//                display current city in view
                self.searchView.displayCityLocation(currentCity)
            case .failure(let error):
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }
        }
        
        locationManager.getAdministrativeArea { (result) in
            
            switch result {
            case .success(let administrativeArea):
                
//                display current admin area in view
                self.currentAdministrativeArea = administrativeArea
                self.searchView.displayAdminAreaLocation(administrativeArea)
            case .failure(let error):
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }
        }
        
        locationManager.getCountry { (result) in
            
            switch result {
            case .success(let country):
                self.currentCountry = country
            case .failure(let error):
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }
        }
    }
}

extension SearchOptionsMenuVC: SearchViewDelegate {
    func didSelectSearchOptions(_ view: UIView, _ extendSearch: Bool, _ searchInAllCategories: Bool, _ searchInCategory: SportCategories?, _ searchItemsForGiveAway: Bool) {
        
        //        send selected search options to table view controller
        delegate?.didSelectSearchOptions(self, extendSearch, searchInAllCategories, searchInCategory, searchItemsForGiveAway)
        
        //        dismiss search options vc
        self.dismiss(animated: true, completion: nil)
    }
    
//    func selectedSearchOptions(_ view: UIView, _ extendSearch: Bool, _ searchInAllCategories: Bool, _ searchInCategory: SportCategories?) {
//
//        guard let city = currentCity, let country = currentCountry, let administrativeArea = currentAdministrativeArea else { return }
//
////        send selected search options to table view controller
//        delegate?.didSelectSearchOptions(self, country, administrativeArea, city, extendSearch, searchInAllCategories, searchInCategory, searchItemsForGiveAway)
//
//
//
//    }
//    func selectedSearchOptions(_ view: UIView, _ extendSearch: Bool) {
        
//
//
//        Service.shared.searchItemsForSaleInCurrentCity(country, city) { (result) in
//            switch result {
//
//            case .success(let item):
////                pass data to search table view
//                self.delegate?.didStartItemSearch(self, item)
//
//            case .failure(let error):
//                SVProgressHUD.showError(withStatus: error.errorDescription)
//            }
//        }
//
//        self.dismiss(animated: true, completion: nil)
//    }
}
