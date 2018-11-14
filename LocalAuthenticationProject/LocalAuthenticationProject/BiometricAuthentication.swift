//
//  BiometricAuthentication.swift
//  LocalAuthenticationProject
//
//  Created by Ashis Laha on 11/14/18.
//  Copyright © 2018 Ashis Laha. All rights reserved.
//

import Foundation
import LocalAuthentication

final class BiometricAuthentication {
    
    func authenticateUser(successBlock: (() -> ())?, failureBlock: (()->())?) {
        
        // retrieve the user name
        guard let lastAccessedUserName = UserDefaults.standard.object(forKey: "lastAccessedUserName") as? String else { return }
        
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // device can be used for biometric authentication
            // evalutate the policy
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Access requires authentication") { (success, err) in
                DispatchQueue.main.async { [weak self] in
                    if success {
                        switch context.biometryType {
                        case .faceID, .touchID:
                            print("device support faceId or touchId authentication")
                            self?.loadPasswordFromKeychainAndAuthenticateUser(lastAccessedUserName, successBlock: successBlock, failureBlock: failureBlock)
                        default: break
                        }
                    }
                }
            }
        } else { // device cannot be used for biometric authentication
            if let error = error {
                switch error.code {
                case LAError.Code.biometryNotEnrolled.rawValue: print("biometry is not enrolled")
                case LAError.Code.biometryLockout.rawValue: print("biometry is not enrolled")
                case LAError.Code.biometryNotAvailable.rawValue: print("biometry is not enrolled")
                default: break
                }
            }
        }
    }
    
    fileprivate func loadPasswordFromKeychainAndAuthenticateUser(_ user_name: String, successBlock: (() -> ())?, failureBlock: (()->())? ) {
        guard !user_name.isEmpty else { return }
        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: user_name, accessGroup: KeychainConfiguration.accessGroup)
        do {
            let storedPassword = try passwordItem.readPassword()
            LoginService.callLogInService(userName: user_name, password: storedPassword, successBlock: successBlock, failureBlock: failureBlock)
            
        } catch KeychainPasswordItem.KeychainError.noPassword {
            print("No saved password")
        } catch {
            print("Unhandled error")
        }
    }
}



