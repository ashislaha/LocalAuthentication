//
//  ViewController.swift
//  LocalAuthenticationProject
//
//  Created by Ashis Laha on 11/14/18.
//  Copyright © 2018 Ashis Laha. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    let biometricAuthentication = BiometricAuthentication()
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        biometricAuthentication.authenticateUser(successBlock: { [weak self] in
            self?.saveAccountDetailsToKeychain(userName: self?.userName.text ?? "", password: self?.password.text ?? "")
            self?.performSegue(withIdentifier: "home", sender: nil)
        }) {
            // failure case
        }
    }
    
    private func saveAccountDetailsToKeychain(userName: String, password: String) {
        guard !userName.isEmpty, !password.isEmpty else { return }
        UserDefaults.standard.set(userName, forKey: "lastAccessedUserName")
        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: userName, accessGroup: KeychainConfiguration.accessGroup)
        do {
            try passwordItem.savePassword(password)
        } catch {
            print("Error saving password")
        }
    }
    
    private func callLoggedIn(userName: String, password: String) {
        
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let userNameString = userName.text, let passwordString = password.text, !userNameString.isEmpty, !passwordString.isEmpty else { return }
        
        LoginService.callLogInService(userName: userNameString, password: passwordString, successBlock: { [weak self] in
            self?.saveAccountDetailsToKeychain(userName: userNameString, password: passwordString)
        }) {
            // handle failure case
        }
    }
}

