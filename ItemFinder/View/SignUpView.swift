//
//  SignUpView.swift
//  ItemFinder
//
//  Created by Mattias Törnqvist on 2020-06-04.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit

class SignUpView: UIView {
    
//    MARK: - Properties
    private lazy var emailContainerView: UIView = {
        let view = UIView.inputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x").withTintColor(.black), textField: emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var fullnameContainerView: UIView = {
        let view = UIView.inputContainerView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x").withTintColor(.black), textField: fullnameTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view = UIView.inputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x").withTintColor(.black), textField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField.textField(withPlaceHolder: "Email",
                                              isSecureTextEntry: false)
        return textField
    }()
    
    let fullnameTextField: UITextField = {
        let textField = UITextField.textField(withPlaceHolder: "Fullname",
                                              isSecureTextEntry: false)
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField.textField(withPlaceHolder: "Password",
                                                isSecureTextEntry: true)
        return textField
    }()
    
    private let administrativeAreaLabel: UILabel = {
        let label = UILabel.textLabel(titleLabel: "", ofFontSize: 12)
        label.alpha = 0
        return label
    }()
    
    private let cityLabelLabel: UILabel = {
        let label = UILabel.textLabel(titleLabel: "", ofFontSize: 16)
        label.alpha = 0
        return label
    }()
    
    private let locationButton: UIButton = {
        
        let image = #imageLiteral(resourceName: "baseline_explore_black_24dp-1").withRenderingMode(.alwaysOriginal)
        let locationImage = image.scale(image: image, by: 0.65)
        
        let button = UIButton(type: .system)
        button.setImage(locationImage, for: .normal)
        button.setTitle("Get location", for: .normal)
        button.widthAnchor.constraint(equalToConstant: 160).isActive = true
        button.heightAnchor.constraint(equalToConstant: 36).isActive = true
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(handleGetLocationPressed), for: .touchUpInside)
       return button
    }()
    
    lazy var signUpButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAnAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?   ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.black])
        
        attributedTitle.append(NSAttributedString(string: "Login", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.systemBlue]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        
        return button
    }()
    
    var delegate: SignUpDelegate?
    
//    MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Helpers functions
    func configureUI() {
        backgroundColor = .backgroundYellow
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, fullnameContainerView, passwordContainerView])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 24
        
        addSubviews(stack, locationButton, administrativeAreaLabel, cityLabelLabel, signUpButton, alreadyHaveAnAccountButton)
        
        stack.anchor(top: safeAreaLayoutGuide.topAnchor, left: safeAreaLayoutGuide.leftAnchor, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        locationButton.centerX(inView: self)
        locationButton.anchor(top: stack.bottomAnchor, paddingTop: 25)
        
        cityLabelLabel.centerX(inView: self)
        cityLabelLabel.anchor(top: locationButton.bottomAnchor, paddingTop: 8)
        
        administrativeAreaLabel.centerX(inView: self)
        administrativeAreaLabel.anchor(top: cityLabelLabel.bottomAnchor, paddingTop: 4)
        
        signUpButton.centerX(inView: self)
        signUpButton.anchor(top: administrativeAreaLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 25, paddingLeft: 16, paddingRight: 16)
        
        alreadyHaveAnAccountButton.centerX(inView: self)
        alreadyHaveAnAccountButton.anchor(bottom: safeAreaLayoutGuide.bottomAnchor, height: 32)
    }
    
    func showLocationLabelsAndAnimateLocationButton(_ city: String, _ administrativeArea: String) {
        
        animateLocationButton()
        
        cityLabelLabel.text = city
        cityLabelLabel.alpha = 1
        administrativeAreaLabel.text = administrativeArea
        administrativeAreaLabel.alpha = 1

    }
    
//    animate location button to show green tint
    func animateLocationButton() {
        self.locationButton.alpha = 0
        self.locationButton.tintColor = .systemGreen
        self.locationButton.setTitle("✓", for: .normal)
        self.locationButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        UIView.animate(withDuration: 1) {
            self.locationButton.alpha = 1
        }
    }
    
//    MARK: Handlers
    @objc func handleGetLocationPressed() {
        delegate?.handleGetLocationPressed(locationButton)
    }
    
    @objc func handleSignUp() {

        delegate?.handleSignUpPressed(for: self)
    }
    
    @objc func handleShowLogin() {
        delegate?.alreadyHaveAnAccountButton(alreadyHaveAnAccountButton)
    }
        
}

extension UIImage {
func inverseImage(cgResult: Bool) -> UIImage? {
    let coreImage = self.ciImage
    guard let filter = CIFilter(name: "CIColorInvert") else { return nil }
    filter.setValue(coreImage, forKey: kCIInputImageKey)
    guard let result = filter.value(forKey: kCIOutputImageKey) as? UIKit.CIImage else { return nil }
    if cgResult { // I've found that UIImage's that are based on CIImages don't work with a lot of calls properly
        return UIImage(cgImage: CIContext(options: nil).createCGImage(result, from: result.extent)!)
    }
    return UIImage(ciImage: result)
}
}
