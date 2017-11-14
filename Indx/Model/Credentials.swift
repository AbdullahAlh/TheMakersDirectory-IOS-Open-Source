//
//  Credentials.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/14/16.
//  Copyright © 2016 level3. All rights reserved.
//

import Foundation


struct Credentials {
    
    var email = ""
    var password = ""
}


// MARK: - validation

extension Credentials {
    
    func validateForSignIn() -> String? {
        
        guard !email.isEmpty && email.contains("@") else {
            return NSLocalizedString("LOGIN_VALIDATION_EMAIL_FORMAT", comment: "")
        }
        
        guard !password.isEmpty else {
            return NSLocalizedString("LOGIN_VALIDATION_PASSWORD_FORMAT", comment: "")
        }
        
        return nil
    }
}
