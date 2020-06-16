//
//  SearchOptionsMenuView.swift
//  ItemFinder
//
//  Created by Mattias Törnqvist on 2020-06-07.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit

class SearchOptionsMenuView: UIView {
    
    weak var delegate: SearchViewDelegate?
    
    let menuLabel: UILabel = {
        let label = UILabel.textLabel(titleLabel: "Search options", ofFontSize: 32)
        return label
    }()
    
    let cityLabel: UILabel = {
        let label = UILabel.textRegularLabel(titleLabel: "Search items in: ", ofFontSize: 18)
        return label
    }()
    
    let administrativeAreaLabel: UILabel = {
        let label = UILabel.textRegularLabel(titleLabel: "Extend search to: ", ofFontSize: 18)
        return label
    }()
    
    lazy var extendSearchSwitch: UISwitch = {
        let sender = UISwitch()
        sender.isOn = false
        sender.tag = 0
        sender.addTarget(self, action: #selector(handleExtendSearch(_:)), for: .valueChanged)
        return sender
    }()
    
    let searchInDescriptionLabel: UILabel = {
        let label = UILabel.textRegularLabel(titleLabel: "Include item description in search", ofFontSize: 18)
        return label
    }()
    
    lazy var includeItemDescriptionSearchSwitch: UISwitch = {
        let sender = UISwitch()
        sender.isOn = false
        sender.tag = 1
        sender.addTarget(self, action: #selector(handleExtendSearch(_:)), for: .valueChanged)
        return sender
    }()
    
    lazy var confirmButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Apply", for: .normal)
        button.addTarget(self, action: #selector(handleApplyButtonPressed), for: .touchUpInside)
        return button
    }()
    
    var extendSearchToAdminArea = false
    var includeItemDescriptionInSearch = false
    var searchInAllCategories = true
    var searchInCategory: SportCategories?
    var searchItemsForGiveAway = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Helper functions
    private func configureUI() {
        
        backgroundColor = .systemYellow
        
        addSubviews(menuLabel, cityLabel, administrativeAreaLabel, extendSearchSwitch, searchInDescriptionLabel, includeItemDescriptionSearchSwitch, confirmButton)
        
        menuLabel.centerX(inView: self)
        menuLabel.anchor(top: safeAreaLayoutGuide.topAnchor, paddingTop: 16)
        
        cityLabel.anchor(top: menuLabel.bottomAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        administrativeAreaLabel.anchor(top: cityLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 16)
        
        extendSearchSwitch.anchor(top: nil, left: administrativeAreaLabel.rightAnchor, paddingLeft: 24)
        extendSearchSwitch.centerYAnchor.constraint(equalTo: administrativeAreaLabel.centerYAnchor).isActive = true
        
        searchInDescriptionLabel.anchor(top: administrativeAreaLabel.bottomAnchor, left: administrativeAreaLabel.leftAnchor, paddingTop: 8)
        
        includeItemDescriptionSearchSwitch.anchor(top: nil, left: searchInDescriptionLabel.rightAnchor, paddingLeft: 24)
        includeItemDescriptionSearchSwitch.centerYAnchor.constraint(equalTo: searchInDescriptionLabel.centerYAnchor).isActive = true
        
        confirmButton.centerX(inView: self)
        confirmButton.anchor(left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
    }
    
    func displayCityLocation(_ city: String) {
        cityLabel.text?.append(city)
    }
    
    func displayAdminAreaLocation(_ administrativeArea: String) {
        administrativeAreaLabel.text?.append(administrativeArea)
    }
    
//    MARK: - Handlers
//    MARK: - TODO fix switch is not working, does not, create separate function
    @objc func handleExtendSearch(_ sender: UISwitch) {

//        extend search to admin area switch
        if sender.tag == 0 {
            switch sender.isOn {
            case true:
                extendSearchToAdminArea = true
            case false:
                extendSearchToAdminArea = false
            }
            
//            search in description switch
        } else if sender.tag == 1 {
            switch sender.isOn {
            case true:
                includeItemDescriptionInSearch = true
            case false:
                includeItemDescriptionInSearch = false
                        }
        }
    }
    
    @objc func handleApplyButtonPressed() {
        delegate?.didSelectSearchOptions(self, extendSearchToAdminArea, includeItemDescriptionInSearch, searchInAllCategories, searchInCategory, searchItemsForGiveAway)
    }
    
}
