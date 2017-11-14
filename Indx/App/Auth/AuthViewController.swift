//
//  AuthViewController.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/15/16.
//  Copyright © 2016 level3. All rights reserved.
//

import UIKit
import JGProgressHUD


class AuthViewController: UIViewController {

    // MARK: static convenience
    
    class func instantiate() -> AuthViewController {
        
        let storyboard = UIStoryboard(name: "Gallery", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AuthViewController")
        
        return controller as! AuthViewController
    }
    
    // MARK: - properties
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    
    private var credentials: Credentials {
        return Credentials(
            email: emailField.text ?? "",
            password: passwordField.text ?? ""
        )
    }
    
    // MARK: view lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInButton.backgroundColor = App.tint
    }
    
    // MARK: - private methods
    
    private func attemptSignIn() {
        
        let credentials = self.credentials
        if let error = credentials.validateForSignIn() {
            
            let alert = UIAlertController.errorAlert(message: error)
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        let hud = JGProgressHUD(style: .dark)!
        hud.show(in: view)
        
        App.fire.auth.signIn(credentials: credentials) { opError in
            hud.dismiss()
            
            if let error = opError {
                let alert = UIAlertController.errorAlert(message: error.localizedDescription)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func attemptResetPassword() {
        
        let alert: UIAlertController
        if credentials.email.isEmpty {
            alert = UIAlertController.errorAlert(
                message: NSLocalizedString("LOGIN_VALIDATION_EMAIL_FORMAT", comment: ""))
        } else {
            App.fire.auth.resetPassword(email: credentials.email)
            alert = UIAlertController.infoAlert(
                title: nil,
                message: NSLocalizedString("ALERT_MSG_PASSWORD_RESET", comment: "")
            )
        }
        
        present(alert, animated: true, completion: nil)
    }

    // MARK: - actions
    
    @IBAction func signInPressed(_ sender: AnyObject) {
        attemptSignIn()
    }
    
    @IBAction func forgotPasswordPressed(_ sender: AnyObject) {
        attemptResetPassword()
    }
}
