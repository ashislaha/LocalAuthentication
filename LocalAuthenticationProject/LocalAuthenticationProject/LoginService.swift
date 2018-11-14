//
//  LoginService.swift
//  LocalAuthenticationProject
//
//  Created by Ashis Laha on 11/14/18.
//  Copyright © 2018 Ashis Laha. All rights reserved.
//

import Foundation

class LoginService {
    
    static func callLogInService(userName: String, password: String, successBlock: (() -> ())?, failureBlock: (()->())? ) {
        // call the HTTP post call here
        // execute success or failure based on response
        let success = true
        success ?  successBlock?(): failureBlock?()
    }
}
