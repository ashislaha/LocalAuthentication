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
    
    func authenticateUser(userName: String, password: String, successBlock: (() -> ())?, failureBlock: (()->())?) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // device can be used for biometric authentication
            // evalutate the policy
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Access requires authentication") { (success, err) in
                DispatchQueue.main.async {
                    if success {
                        switch context.biometryType {
                        case .faceID, .touchID:
                            print("device support faceId or touchId authentication")
                            // retrieve the data from key-chain and call the login service
                            
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
    
    private func callLogInService(userName: String, password: String, successBlock: (() -> ())?, failureBlock: (()->())? ) {
        // call the HTTP post call here
    }
}



