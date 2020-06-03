//
//  SignUpVC.swift
//  ItemFinder
//
//  Created by Mattias Törnqvist on 2020-05-17.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import CoreLocation

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
    
    private lazy var locationInputView: UIView = {
        let view = UIView.inputContainerView(button: locationButton, label: locationLabel)
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
    
    let locationLabel: UILabel = {
        let label = UILabel.textLabel(titleLabel: "Location", ofFontSize: 16)
        return label
    }()
    
    let locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_explore_black_24dp-1"), for: .normal)
        button.tintColor = .systemBlue
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
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, fullnameContainerView, passwordContainerView, locationInputView, signUpButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 24
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: safeAreaLayoutGuide.topAnchor, left: safeAreaLayoutGuide.leftAnchor, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        addSubview(alreadyHaveAnAccountButton)
        alreadyHaveAnAccountButton.centerX(inView: self)
        alreadyHaveAnAccountButton.anchor(bottom: safeAreaLayoutGuide.bottomAnchor, height: 32)
    }
    
//    MARK: Handlers
    @objc func handleSignUp() {

        delegate?.handleSignUpPressed(for: self)
        
    }
    
    @objc func handleShowLogin() {
        delegate?.alreadyHaveAnAccountButton(alreadyHaveAnAccountButton)
    }
        
}

class SignUpVC: UIViewController {
    
//    MARK: - Properties
    let signUpView = SignUpView()
    

//    MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerView()
        
        setDelegates()

    }
    
    func registerView() {
        view = signUpView
    }
    
    func setDelegates() {
        signUpView.delegate = self
        signUpView.emailTextField.delegate = self
        signUpView.fullnameTextField.delegate = self
        signUpView.passwordTextField.delegate = self
    }
}

extension SignUpVC: SignUpDelegate {
    func handleSignUpPressed(for view: SignUpView) {
        
//        MARK: TODO better error handling
//
        guard let email = view.emailTextField.text?.lowercased(),
            let fullname = view.fullnameTextField.text,
            let password = view.passwordTextField.text?.lowercased()
            else { return }

        SVProgressHUD.show()

        let group = DispatchGroup()
        group.enter()

        DispatchQueue.main.async {
//            SVProgressHUD.show()
            Service.shared.createUserWithEmail(email: email, fullname: fullname, password: password) { (result) in

                switch result {
                case .success(_):
                    SVProgressHUD.dismiss()
                    group.leave()

                case .failure(let error):
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                }
            }
        }

        group.notify(queue: .main) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func alreadyHaveAnAccountButton(_ button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
