//
//  Extensions.swift
//  ItemFinder
//
//  Created by Mattias Törnqvist on 2020-05-15.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import SVProgressHUD

//extension UICollectionView {
//    static func itemCollectionView() -> UICollectionView {
//
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.minimumLineSpacing = 10
//        layout.itemSize = CGSize(width: 120, height: 120)
//
//        let frame = CGRect(x: 0, y: 0, width: 0, height: 220)
//        
//        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
//        collectionView.alwaysBounceVertical = true
//        collectionView.backgroundColor = .backgroundBlack
//        return collectionView
//    }
//}

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach{addSubview($0)}
    }
    
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func centerX(inView: UIView) {
        centerXAnchor.constraint(equalTo: inView.centerXAnchor).isActive = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func centerY(inView: UIView) {
        centerYAnchor.constraint(equalTo: inView.centerYAnchor).isActive = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func pinEdgesToSuperView() {
        guard let superView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
    }
    
    func blurEffect() -> UIView {
        let visualEffect: UIVisualEffectView = {
            let visualEffect = UIBlurEffect(style: .dark)
            let view = UIVisualEffectView(effect: visualEffect)
            return view
        }()
        return visualEffect
    }

static func inputContainerView(image: UIImage, textField: UITextField) -> UIView {
    let view = UIView()
    
    let imageView = UIImageView()
    imageView.image = image
    imageView.alpha = 0.87
    view.addSubview(imageView)
    imageView.centerY(inView: view)
    imageView.anchor(left: view.leftAnchor, paddingLeft: 8, width: 24, height: 24)
    
    view.addSubview(textField)
    textField.centerY(inView: view)
    textField.anchor(left: imageView.rightAnchor, bottom: view.bottomAnchor,
                     right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8)
    
    let separatorView = UIView()
    separatorView.backgroundColor = .darkText
    view.addSubview(separatorView)
    separatorView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,
                         right: view.rightAnchor, paddingLeft: 8, height: 0.75)
    
    return view
    }
    
    static func inputContainerView(button: UIButton, label: UILabel) -> UIView {
    let view = UIView()
        
    view.addSubview(button)
    button.alpha = 0.87
    button.centerY(inView: view)
    button.anchor(left: view.leftAnchor, paddingLeft: 8, width: 24, height: 24)
    
    view.addSubview(label)
    label.centerY(inView: view)
    label.anchor(left: button.rightAnchor, bottom: view.bottomAnchor,
                     right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8)
    
    let separatorView = UIView()
    separatorView.backgroundColor = .darkText
    view.addSubview(separatorView)
    separatorView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,
                         right: view.rightAnchor, paddingLeft: 8, height: 0.75)

    return view
    }

    static func inputContainerView(titleText: String, textView: UITextView) -> UIView {
        let view = UIView()

        let titleLabel = UILabel.textLabel(titleLabel: titleText, ofFontSize: 16)

        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.topAnchor, left: view.leftAnchor)

        view.addSubview(textView)
        textView.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor,
                        bottom: view.bottomAnchor, right: view.rightAnchor,
                        paddingTop: 0, paddingLeft: 0)

        return view
    }
    
    static func inputContainerView(textField: UITextField) -> UIView {
        let view = UIView()

        view.addSubview(textField)
        textField.anchor(top: view.topAnchor, left: view.leftAnchor,
                         bottom: view.bottomAnchor,
                         right: view.rightAnchor)

        let separatorView = UIView()
        separatorView.backgroundColor = .darkText
        view.addSubview(separatorView)
        separatorView.anchor(left: view.leftAnchor, bottom: textField.bottomAnchor,
                             right: view.rightAnchor, paddingLeft: 0, height: 0.75)

        return view
    }
}

extension UIStackView {
    func addMultipleSubviews(_ views: UIView...) {
        views.forEach{addSubview($0)}
    }
}

extension UIViewController {
    func prefersLargeNCTitles() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func showCameraAndAuthorizeIfNeeded(picker: UIImagePickerController) {
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
            dispatchGroup.leave()
            present(picker, animated: true, completion: nil)
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    //access allowed
                    dispatchGroup.leave()
                    
                    dispatchGroup.notify(queue: .main) {
                        self.present(picker, animated: true, completion: nil)
                    }
                } else {
                    //access denied
                    dispatchGroup.leave()
                    dispatchGroup.notify(queue: .main) {
                        SVProgressHUD.showError(withStatus: "Need Camera Access - To enable, go to Settings > Privacy > Camera and turn on Camera access for this app.")
                    }
                }
            })
        }
    }
    
    func showMediaPickerAndAuthorizeIfNeeded(photoLibraryPicker: UIImagePickerController?, cameraPicker: UIImagePickerController?, shouldPresentCameraPicker: Bool?, shouldPresentPhotoLibraryPicker: Bool?) -> Void {

        let photos = PHPhotoLibrary.authorizationStatus()
        let dispatchGroup = DispatchGroup()
        
        if let _ = shouldPresentPhotoLibraryPicker,
            let picker = photoLibraryPicker {
            dispatchGroup.enter()
           
            switch photos {
                
//              already authorized
            case .authorized:
                dispatchGroup.leave()
                dispatchGroup.notify(queue: .main) {
                    self.present(picker, animated: true, completion: nil)
                }
                
//              denied
            case .denied:
                dispatchGroup.leave()
                dispatchGroup.notify(queue: .main) {
                    SVProgressHUD.showError(withStatus: "Need Camera Access - To enable, go to Settings > Privacy > Camera and turn on Camera access for this app.")
                }

//              not determined, show pop up to enable access to photo library once again
            case .notDetermined:
                requestCameraRollAuthorizationAndPresentCameraRoll(picker: picker, dispatchGroup: dispatchGroup)

            default:
                print("DEBUG error - Edge cases for media capture options")
                break
            }
        }
        
        if let _ = shouldPresentCameraPicker,
            let picker = cameraPicker {
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    dispatchGroup.enter()
                    if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                        //already authorized
                        dispatchGroup.leave()
                        present(picker, animated: true, completion: nil)
                    } else {
                        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                            if granted {
                                //access allowed
                                dispatchGroup.leave()
                                
                                dispatchGroup.notify(queue: .main) {
                                    self.present(picker, animated: true, completion: nil)
                                }
                            } else {
                                //access denied
                                dispatchGroup.leave()
                                dispatchGroup.notify(queue: .main) {
                                    SVProgressHUD.showError(withStatus: "Need Camera Access - To enable, go to Settings > Privacy > Camera and turn on Camera access for this app.")
                                }
                            }
                        })
                    }
                }
            }


    }
    
    func requestCameraRollAuthorizationAndPresentCameraRoll(picker: UIImagePickerController, dispatchGroup: DispatchGroup) {
        PHPhotoLibrary.requestAuthorization { (granted: PHAuthorizationStatus) in
            switch granted {
            case .authorized:
                dispatchGroup.leave()
                dispatchGroup.notify(queue: .main) {
                    self.present(picker, animated: true, completion: nil)
                }
            default:
                print("DEBUG user did not grant access to photo library")
            }
        }
    }
}

extension UIViewController: UITextFieldDelegate, UITextViewDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    public func textViewShouldReturn(_ textView: UITextView) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
    static let mainBlue = rgb(red: 30, green: 178, blue: 166)
    static let subBlue = rgb(red: 212, green: 248, blue: 232)
    static let mainYellow = rgb(red: 255, green: 204, blue: 0)
    static let backgroundYellow = rgb(red: 253, green: 219, blue: 58)
    static let backgroundBlack = rgb(red: 25, green: 25, blue: 25)
}

extension UILabel {
    static func textLabel(titleLabel: String, ofFontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Light", size: ofFontSize)
        label.textColor = UIColor.black
        label.text = titleLabel
        return label
    }
}

extension UITextField {
    static func textField(withPlaceHolder placeholder: String, isSecureTextEntry: Bool) -> UITextField {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.textColor = .darkText
        tf.keyboardAppearance = .dark
        tf.isSecureTextEntry = isSecureTextEntry
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        return tf
    }
    
    static func textField(withPlaceHolder placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.textColor = .darkText
        tf.keyboardAppearance = .dark
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        return tf
    }
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .foundNil:
            return NSLocalizedString("Description of found nil", comment: "DEBUG: Error found nil while unwrapping a value")
        case .invalidData:
            return NSLocalizedString("Error invalid data", comment: "DEBUG invalid data")
        }
    }
}



extension UIImagePickerController {
    
    static func photoLibraryPicker() -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        return imagePickerController
    }
    
    static func cameraPicker() -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        return picker
    }
}


extension UIAlertController {
    func addActions(_ actions: UIAlertAction...) {
        actions.forEach{addAction($0)}
    }
}
