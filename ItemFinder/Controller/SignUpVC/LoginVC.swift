//
//  LoginVC.swift
//  ItemFinder
//
//  Created by Mattias Törnqvist on 2020-05-19.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginView: UIView {
    //    MARK: - Properties
    private lazy var emailContainerView: UIView = {
        let view = UIView.inputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x").withTintColor(.black), textField: emailTextField)
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
    
    let passwordTextField: UITextField = {
        let textField = UITextField.textField(withPlaceHolder: "Password",
                                                isSecureTextEntry: true)
        return textField
    }()
    
    lazy var loginButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    let dontHaveAnAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?   ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.black])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.systemBlue]))
        
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }()
    
    var delegate: LoginDelegate?
    
//    MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
    }
    
    //    MARK: - Helpers functions
    func configureUI() {
        backgroundColor = .backgroundYellow
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 24
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: safeAreaLayoutGuide.topAnchor, left: safeAreaLayoutGuide.leftAnchor, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        addSubview(dontHaveAnAccountButton)
        dontHaveAnAccountButton.centerX(inView: self)
        dontHaveAnAccountButton.anchor(bottom: safeAreaLayoutGuide.bottomAnchor, height: 32)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Handlers
    @objc func handleLogin() {
        delegate?.didPressLogin(emailTextField, passwordTextField)
    }
    
    @objc func handleShowSignUp() {
        delegate?.didPressDontHaveAccountButton(dontHaveAnAccountButton)
    }
}

class LoginVC: UIViewController {
//    MARK: - Properties
    let loginView = LoginView()

//    MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        setDelegates()
        
        navigationController?.isNavigationBarHidden = true
    }
    
    func configureView() {
        view = loginView
    }
    
    func setDelegates() {
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
        loginView.delegate = self
    }
}

extension LoginVC: LoginDelegate {
    
    func didPressLogin(_ emailTextField: UITextField, _ passwordTextField: UITextField) {
        
        SVProgressHUD.show()
            
            let group = DispatchGroup()
            group.enter()
            
            guard let email = emailTextField.text,
                let password = passwordTextField.text
                else { return }
            
            Service.shared.loginWithEmail(email: email, password: password) { (result) in
                
                switch result {
                case .success(_):
                    group.leave()
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                }
            }
            
            group.notify(queue: .main) {
                SVProgressHUD.dismiss()
                
                self.dismiss(animated: true, completion: nil)
            }
    }
    
    func didPressDontHaveAccountButton(_ button: UIButton) {
        let signUpVC = SignUpVC()
        signUpVC.modalPresentationStyle = .fullScreen
        present(signUpVC, animated: true, completion: nil)
    }
}

