//
//  ImageSelectorDelegate.swift
//  ItemFinder
//
//  Created by Mattias Törnqvist on 2020-05-28.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit

final class ImageSelectorDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    weak var delegate: ImageProvidedDelegate?
    
    var photoLibraryPicker: UIImagePickerController
    
//    MARK: - TODO add camera picker and set delegate to be able to handle images from camera
    init(with photoLibraryPicker: UIImagePickerController, withDelegate delegate: ImageProvidedDelegate) {
        self.photoLibraryPicker = photoLibraryPicker
        self.delegate = delegate
        super.init()
        
        photoLibraryPicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        
//        send image to delegate (AddItemVC)
        delegate?.image(selectedImage)
        
        photoLibraryPicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
