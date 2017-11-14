//
//  FireAuth.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/14/16.
//  Copyright © 2016 level3. All rights reserved.
//

import Foundation
import FirebaseAuth


extension Notification.Name {
    static let userAuthChanged = Notification.Name("io.level3.user-auth-changed")
}

final class FireAuth {

    // MARK: - properties
    
    var currentUser: FIRUser? {
        return FIRAuth.auth()?.currentUser
    }
    
    // MARK: - public methods
    
    func setup() {
        FIRAuth.auth()?.addStateDidChangeListener { (auth, optionalUser) in
            NotificationCenter.default.post(name: .userAuthChanged, object: nil)
        }
    }
    
    func signUp(credentials: Credentials, callback: @escaping (Error?) -> ()) {
        
        FIRAuth.auth()?.createUser(withEmail: credentials.email, password: credentials.password) { (opUser, opError) in
            
            var error: Error? = nil
            switch (opUser, opError) {
            case (_, .some(let err)):
                error = err
                NSLog("[ERR]: Failed to login. \(err.localizedDescription)")
                
            case (.some(let user), _):
                NSLog("[INFO]: Logged in anonymously. \(user.uid)")
                
            default:
                error = NSError(domain: "indx", code: 121, userInfo: [NSLocalizedDescriptionKey: "Fatal error occurred"])
                NSLog("[FATAL]: unexpected application state")
            }
            
            callback(error)
        }
    }
    
    
    func signInAnonymously() {
        
        FIRAuth.auth()?.signInAnonymously { opUser, opError in
            
            switch (opUser, opError) {
            case (_, .some(let error)):
                NSLog("[ERR]: Failed to login anonymously. \(error.localizedDescription)")
                
            case (.some(let user), _):
                NSLog("[INFO]: Logged in anonymously. \(user.uid)")
                
            default:
                NSLog("[FATAL]: unexpected application state")
            }
        }
    }
    
    func signIn(credentials: Credentials, callback: @escaping (Error?) -> ()) {
        
        FIRAuth.auth()?.signIn(withEmail: credentials.email, password: credentials.password) { (opUser, opError) in
            
            // SPECIAL: if login fails, just create a user instead
            if let error = opError as? NSError, error.code == 17011 {
                self.signUp(credentials: credentials, callback: callback)
                return
            }
            
            var error: Error? = nil
            switch (opUser, opError) {
            case (_, .some(let err)):
                error = err
                NSLog("[ERR]: Failed to login. \(err.localizedDescription)")
                
            case (.some(let user), _):
                NSLog("[INFO]: Logged in anonymously. \(user.uid)")
                
            default:
                error = NSError(domain: "indx", code: 121, userInfo: [NSLocalizedDescriptionKey: "Fatal error occurred"])
                NSLog("[FATAL]: unexpected application state")
            }
            
            callback(error)
        }
    }
    
    func signOut() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let e as NSError {
            NSLog("[ERR]: Failed to sign out. \(e.localizedDescription) - \(e.localizedFailureReason ?? "")")
        }
    }
    
    func resetPassword(email: String) {
        
        FIRAuth.auth()?.sendPasswordReset(withEmail: email) { (opError) in
            
            if let error = opError {
                // GTH: broadcast/return error
                NSLog("[ERR]: password reset failed - \(error.localizedDescription)")
            }
        }
    }
    
    func linkAccount(credentials: Credentials) {
        
        guard let user = currentUser else {
            // GTH: log?
            return
        }
        
        let emailAuth = FIREmailPasswordAuthProvider.credential(withEmail: credentials.email, password: credentials.password)
        user.link(with: emailAuth) { (opUser, opError) in
            
            switch (opUser, opError) {
            case (_, .some(let error)):
                // GTH: broadcast/return an error
                NSLog("[ERR]: Failed to link account. \(error.localizedDescription)")
                
            case (.some(let user), _):
                NSLog("[INFO]: email credentials linked. \(user.uid)")
                
            default:
                NSLog("[FATAL]: unexpected application state")
            }
        }
        
    }
}
