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
    
    lazy var descriptionTitleLabel: UILabel = {
        let label = UILabel.textLabel(titleLabel: "Add item", ofFontSize: 25)
        return label
    }()
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField.textField(withPlaceHolder: "Title")
        return textField
    }()
    
    lazy var keywordTextField: UITextField = {
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
        view.heightAnchor.constraint(equalToConstant: 160).isActive = true
        return view
    }()
    
    lazy var saveButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(handleSaveButtonPressed), for: .touchUpInside)
        return button
    }()
    
    var collectionView: UICollectionView?
    
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
    
    convenience init(frame: CGRect, collectionView: UICollectionView, delegate: AddItemViewDelegate) {
        self.init(frame: frame)
        self.collectionView = collectionView
        self.delegate = delegate
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Helper functions
    func configureUI() {
        backgroundColor = .systemYellow
        
        addSubview(closeButton)
        closeButton.anchor(top: safeAreaLayoutGuide.topAnchor, right: rightAnchor, paddingTop: 8, paddingRight: 8)
        
        stack.addArrangedSubview(titleInputView)
        stack.addArrangedSubview(collectionView!)
        stack.addArrangedSubview(keywordInputView)
        stack.addArrangedSubview(descriptionInputView)
        stack.addArrangedSubview(saveButton)
        
        addSubviews(descriptionTitleLabel, stack)
        
        descriptionTitleLabel.anchor(top: safeAreaLayoutGuide.topAnchor, left: safeAreaLayoutGuide.leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        stack.anchor(top: descriptionTitleLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)

    }
    
    func cleanFields() {
        titleTextField.text = nil
        keywordTextField.text = nil
        descriptionTextView.text = nil
    }
    
//    MARK: - Handlers
    @objc func handleClosePressed() {
        delegate?.closeButton(closeButton)
    }
    
    @objc func handleSaveButtonPressed() {
        delegate?.saveButton(saveButton, withTitle: titleTextField.text, withKeyWords: keywordTextField.text, withDescription: descriptionTextView.text)
    }
}
