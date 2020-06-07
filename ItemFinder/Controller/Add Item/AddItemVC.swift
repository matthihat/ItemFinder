//
//  addItemVC.swift
//  ItemFinder
//
//  Created by Mattias Törnqvist on 2020-05-16.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

class AddItemVC: UIViewController, AddItemVCDelegate, AddItemViewDelegate, ImageProvidedDelegate {

//    MARK: - Properties
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 120)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .blue
        cv.heightAnchor.constraint(equalToConstant: 120).isActive = true
        return cv
    }()
    
    lazy var photoLibraryPicker: UIImagePickerController = {
        let picker = UIImagePickerController.photoLibraryPicker()
        return picker
    }()
    
    var selectedIndexPath: IndexPath?
    
    var selectedImages = [UIImage]()
    
    var itemIsForSale: Bool?
    
    var itemIsForGiveAway: Bool?
    
    let frame = CGRect.zero
    
    lazy var categoryPickerView: UIPickerView = {
       let picker = UIPickerView()
        return picker
    }()
    
    lazy var addItemView = AddItemView(frame: frame, collectionView: collectionView, delegate: self, picker: categoryPickerView)
    
    lazy var validation: ValidationService = {
        let validation = ValidationService()
        return validation
    }()
    
    var selectedCategory: String?
    
    
    let reuseIdentifier = "Cell"
    var photoCVDataSource: PhotoCVDataSource?
    var photoCVDelegate: PhotoCVDelegate?
    var imageSelectorDelegate: ImageSelectorDelegate?
//    var categoryPickerView = UIPickerView()
    var categoryPickerViewDelegateDataSource: CategoryPickerDelegateDataSource?
    
    
//    MARK: - Life cycle
    override func viewDidLoad() {
        
        configureView()
        
        setDelegates()
        
        configureCollectionView()
        
//        class for receiving selected image (camera or photo)
        configureImageSelector()
        
        configurePickerView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        cleanUpView()
    }
    
//    MARK: - Helper functions
    func configureView() {
        view = addItemView
        addItemView.collectionView = collectionView
    }
    
    func setDelegates() {
//        view class
        addItemView.keywordTextField.delegate = self
        addItemView.titleTextField.delegate = self
        addItemView.descriptionTextView.delegate = self
        
    }
    
    func configureCollectionView() {
        
        collectionView.register(ItemPhotoCVCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        photoCVDataSource = PhotoCVDataSource(reuseIdentifier: reuseIdentifier)
        photoCVDelegate = PhotoCVDelegate(withDelegate: self)
        
        collectionView.dataSource = photoCVDataSource
        collectionView.delegate = photoCVDelegate
        
    }
    
    func configurePickerView() {
        
        categoryPickerViewDelegateDataSource = CategoryPickerDelegateDataSource(categoryPickerView, self)
        categoryPickerView.dataSource = categoryPickerViewDelegateDataSource
        categoryPickerView.delegate = categoryPickerViewDelegateDataSource
        
//        categoryPickerDelegate = CategoryPickerDelegate()
//        categoryPickerView.delegate = categoryPickerDelegate
        
    }
    
    func cleanUpView() {
        selectedImages.removeAll()
        selectedIndexPath = nil
        
        addItemView.cleanFields()
        
        photoCVDataSource?.removeAllImages(collectionView)
    }
    
    func presentImageSourceAC() {
        let alert = UIAlertController(title: "Add image", message: nil, preferredStyle: .actionSheet)
        
//        MARK: - TODO create camera picker and move to top as lazy var
//        let cameraPicker = UIImagePickerController.cameraPicker()
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
//            MARK: - TODO add camera option
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo library", style: .default) { (_) in
            self.showMediaPickerAndAuthorizeIfNeeded(photoLibraryPicker: self.photoLibraryPicker, cameraPicker: nil, shouldPresentCameraPicker: nil, shouldPresentPhotoLibraryPicker: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            
        }
        
        alert.addActions(cameraAction, photoLibraryAction, cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func configureImageSelector() {
        imageSelectorDelegate = ImageSelectorDelegate(with: photoLibraryPicker, withDelegate: self)
    }
    
    
//    MARK: - Delegate methods
    func selectedCell(selectedIndexPath: IndexPath, selectedCell: ItemPhotoCVCell) {
        
        self.selectedIndexPath = selectedIndexPath
        
//        if selected cell item image view is empty, present image picker to add new image
        if selectedCell.itemImageView.image == nil {
            presentImageSourceAC()
            
//            if cell at selected indexpath, remove item image
        } else {
            
//            remove image from array of images
            selectedImages.removeAll { (image) -> Bool in
                selectedCell.itemImageView.image == image
            }
            
//            remove from cv
            photoCVDataSource?.removeItemImageFromCellAtIndexPath(collectionView, cellForItemAt: selectedIndexPath)
        }

        
    }
    
//    when image is selected from image picker
    func image(_ didSelectImageWithImage: UIImage) {
        
//        update array of selected images
        selectedImages.append(didSelectImageWithImage)
        
        guard let indexPath = selectedIndexPath else {
            print("DEBUG Error no index selected!")
            return }
        
//        update collection view cell with image selected
        self.photoCVDataSource?.updateCellAtIndexPathWithImage(collectionView, cellForItemAt: indexPath,
                                                               cellWithItemImage: didSelectImageWithImage)
    }
    
//    handle item is for sale or not selected in view
    func itemIsForSale(_ sender: UISwitch) {
        itemIsForSale = true
    }
    
    func itemIsNotForSale(_ sender: UISwitch) {
        itemIsForSale = false
    }
    
    func itemIsForGiveAway(_ sender: UISwitch) {
        itemIsForGiveAway = true
    }
    
    func itemIsNotForGiveAway(_ sender: UISwitch) {
        itemIsForGiveAway = false
    }
    
//    when save button in view is pressed
    func saveButton(_ button: UIButton, withTitle title: String?, withKeyWords keyWords: String?, withDescription description: String?) {
        
        
        
//        create item
        let itemUnvalidated = ItemForUpload(title, keyWords, description, selectedImages, itemIsForSale ?? false, itemIsForGiveAway ?? false, selectedCategory)
        
//        validate title description
        do {
            let validatedItem = try validation.validateItem(validateItem: itemUnvalidated)
            
            guard let itemForUpload = validatedItem else { return }
            
            itemForUpload.uploadItem(itemForUpload) { (result) in
                
                switch result {
                case .success(_):
                    print("DEBUG success!")
                case .failure(let error):
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                    print("DEBUG error uploading info", error.localizedDescription)
                }
            }
            
        } catch {
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
    
    func closeButton(_ button: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.removeFromParent()
    }

}

// delegate method for getting selected category in pickerview
extension AddItemVC: CategoryPickerDelegate {
    func pickerView(_ picker: UIPickerView, _ selectedCategory: String) {
        
//        assign local variable which category was selected
        switch selectedCategory {
        case SportCategories.biking.rawValue:
            self.selectedCategory = SportCategories.biking.dbRef
        case SportCategories.running.rawValue:
            self.selectedCategory = SportCategories.running.dbRef
        case SportCategories.skiing.rawValue:
            self.selectedCategory = SportCategories.skiing.dbRef
        default:
            Void()
        }
    }
    
//    func pickerView(_ picker: UIPickerView) {
//        print("DEBUG valde", picker.selectedRow(inComponent: 0))
//    }
    
    
}
