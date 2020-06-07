//
//  AddItemView.swift
//  ItemFinder
//
//  Created by Mattias Törnqvist on 2020-05-28.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit

class AddItemView: UIView {
    
//    MARK: - Properties
    let closeButton: UIButton = {
        let button = UIButton(type: .close)
        button.addTarget(self, action: #selector(handleClosePressed), for: .touchUpInside)
        return button
    }()
    
    let descriptionTitleLabel: UILabel = {
        let label = UILabel.textLabel(titleLabel: "Add item", ofFontSize: 25)
        return label
    }()
    
    let isForSaleLabel: UILabel = {
        let label = UILabel.textLabel(titleLabel: "Is for sale", ofFontSize: 18)
        return label
    }()
    
    let isForSaleSwitch: UISwitch = {
        let selector = UISwitch()
        selector.isOn = false
        selector.addTarget(self, action: #selector(handleItemIsForSale(_:)), for: .valueChanged)
        return selector
    }()
    
    let isForGiveAwayLabel: UILabel = {
        let label = UILabel.textLabel(titleLabel: "Is for give away", ofFontSize: 18)
        return label
    }()
    
    let isForGiveAwaySwitch: UISwitch = {
        let selector = UISwitch()
        selector.isOn = false
        selector.addTarget(self, action: #selector(handleItemIsForGiveAway(_:)), for: .valueChanged)
        return selector
    }()
    
    let titleTextField: UITextField = {
        let textField = UITextField.textField(withPlaceHolder: "Title")
        return textField
    }()
    
    let keywordTextField: UITextField = {
        let textField = UITextField.textField(withPlaceHolder: "Keywords")
        return textField
    }()
    
    lazy var titleInputView: UIView = {
        let view = UIView.inputContainerView(textField: titleTextField)
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return view
    }()
    
    lazy var keywordInputView: UIView = {
        let view = UIView.inputContainerView(textField: keywordTextField)
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return view
    }()
    
    lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        return textView
    }()
    
    lazy var descriptionInputView: UIView = {
        let view = UIView.inputContainerView(titleText: "Description", textView: descriptionTextView)
        view.heightAnchor.constraint(equalToConstant: 120).isActive = true
        return view
    }()
    
    lazy var saveButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(handleSaveButtonPressed), for: .touchUpInside)
        return button
    }()
    
    var collectionView: UICollectionView?
    var picker: UIPickerView?
    
    lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 32
        return stack
    }()
    
    weak var delegate: AddItemViewDelegate?
    
    
//    MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

//        configureUI()
    }
    
    convenience init(frame: CGRect, collectionView: UICollectionView, delegate: AddItemViewDelegate, picker: UIPickerView) {
        self.init(frame: frame)
        self.collectionView = collectionView
        self.delegate = delegate
        self.picker = picker
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Helper functions
    func configureUI() {
        backgroundColor = .systemYellow
        
        picker?.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        stack.addArrangedSubview(titleInputView)
        stack.addArrangedSubview(collectionView!)
        stack.addArrangedSubview(picker!)
        stack.addArrangedSubview(keywordInputView)
        stack.addArrangedSubview(descriptionInputView)
        stack.addArrangedSubview(saveButton)
        
        addSubviews(descriptionTitleLabel, closeButton, isForSaleLabel, isForSaleSwitch, isForGiveAwayLabel, isForGiveAwaySwitch, stack)
        
        closeButton.anchor(top: safeAreaLayoutGuide.topAnchor, right: rightAnchor, paddingTop: 8, paddingRight: 8)
        
        descriptionTitleLabel.anchor(top: safeAreaLayoutGuide.topAnchor, left: safeAreaLayoutGuide.leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        isForSaleLabel.anchor(top: descriptionTitleLabel.bottomAnchor, right: rightAnchor, paddingTop: 8, paddingRight: 16)
        
        isForSaleSwitch.anchor(top: isForSaleLabel.bottomAnchor, right: rightAnchor, paddingTop: 4, paddingRight: 16)
        
        isForGiveAwayLabel.anchor(top: isForSaleSwitch.bottomAnchor, right: rightAnchor, paddingTop: 8, paddingRight: 16)
        
        isForGiveAwaySwitch.anchor(top: isForGiveAwayLabel.bottomAnchor, right: rightAnchor, paddingTop: 4, paddingRight: 16)
        
        stack.anchor(top: isForGiveAwaySwitch.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 16, paddingRight: 16)
        
        

    }
    
    func cleanFields() {
        titleTextField.text = nil
        keywordTextField.text = nil
        descriptionTextView.text = nil
    }
    
//    MARK: - Handlers
    @objc func handleClosePressed() {
        delegate?.closeButton(closeButton)
        self.removeFromSuperview()
    }
    
    @objc func handleItemIsForSale(_ sender: UISwitch) {
        
        if sender == isForSaleSwitch{
            if sender.isOn {
                delegate?.itemIsForSale(sender)
            } else {
                delegate?.itemIsNotForSale(sender)
            }
        }
    }
    
    @objc func handleItemIsForGiveAway(_ sender: UISwitch) {
        if sender == isForGiveAwaySwitch {
            if sender.isOn {
                delegate?.itemIsForGiveAway(sender)
            } else {
                delegate?.itemIsNotForGiveAway(sender)
            }
        }
    }
    
    @objc func handleSaveButtonPressed() {
        delegate?.saveButton(saveButton, withTitle: titleTextField.text, withKeyWords: keywordTextField.text, withDescription: descriptionTextView.text)
    }
}

//class categoryPickerViewDataSource: NSObject, UIPickerViewDataSource {
//
//}
