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



class SignUpVC: UIViewController {
    
//    MARK: - Properties
    let signUpView = SignUpView()
    private let locationManager = LocationManager()
    private var latitude: Double?
    private var longitude: Double?

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

//Sign up view delegate methods
extension SignUpVC: SignUpDelegate {
    
    func handleGetLocationPressed(_ button: UIButton) {
        
        guard let exposedLocation = locationManager.exposedLocation else {
            print("DEBUG Error in \(#function): exposedLocation is nil")
            return
        }

        self.locationManager.getPlace(for: exposedLocation) { (placemark) in
            guard let placemark = placemark else { return }
            
            let latitude: Double = exposedLocation.coordinate.latitude
            let longitude: Double = exposedLocation.coordinate.longitude
            
            self.latitude = latitude
            self.longitude = longitude
            
            if let administrativeArea = placemark.administrativeArea,
                let city = placemark.locality {
                self.signUpView.showLocationLabels(city, administrativeArea)
            }
        }

        
    }
    
    func handleSignUpPressed(for view: SignUpView) {
        
//        MARK: TODO better error handling, throw error before contacting API
//
        guard let email = view.emailTextField.text?.lowercased(),
            let fullname = view.fullnameTextField.text,
            let password = view.passwordTextField.text?.lowercased()
            else { return }

        SVProgressHUD.show()

        let group = DispatchGroup()
        group.enter()

        DispatchQueue.main.async {
            
            Service.shared.createUserWithEmail(email: email, fullname: fullname, password: password, latitude: self.latitude, longitude: self.longitude) { (result) in

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
        navigationController?.popViewController(animated: true)
        
    }
    
}
