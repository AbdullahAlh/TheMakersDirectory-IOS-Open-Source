//
//  SettingsViewController.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/14/16.
//  Copyright © 2016 level3. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet var authLabel: UILabel?
    @IBOutlet weak var languageToggle: UISegmentedControl!
    
    
    private var authObserver: NSObjectProtocol?
    
    
    deinit {
        if let authObserver = self.authObserver {
            NotificationCenter.default.removeObserver(authObserver)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        languageToggle.selectedSegmentIndex = Locality.appLocality == .english ? 0 : 1
        
        authObserver = NotificationCenter.default.addObserver(forName: .userAuthChanged, object: nil, queue: OperationQueue.main) { [unowned self] _ in
            self.updateAuthLabel()
        }
        
        updateAuthLabel()
    }
    
    // MARK: - private methods
    
    private func updateAuthLabel() {
        authLabel?.text = (App.fire.auth.currentUser == nil
            ? NSLocalizedString("BTN_SIGN_IN", comment: "")
            : NSLocalizedString("BTN_SIGN_OUT", comment: ""))
    }
    
    private func loginRequest() {
        present(AuthViewController.instantiate(), animated: true, completion: nil)
    }
    
    private func logoutRequest() {
        
        let alert = UIAlertController(
            title: NSLocalizedString("ALERT_TITLE_LOGOUT", comment: ""),
            message: NSLocalizedString("ALERT_MSG_LOGOUT", comment: ""),
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("ALERT_BTN_CANCEL", comment: ""), style: .cancel))
        
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("ALERT_BTN_LOGOUT", comment: ""),
            style: .destructive,
            handler: { _ in App.fire.auth.signOut() }
        ))
        
        present(alert, animated: true, completion: nil)
    }
    

    // MARK: - actions
    
    @IBAction func languageToggleChange(_ sender: AnyObject) {
        
        switch languageToggle.selectedSegmentIndex {
        case 0: Locality.appLocality = .english
        case 1: Locality.appLocality = .arabic
        default: fatalError("unexpected lang segment")
        }
    }
    
    @IBAction func authButtonPressed() {
        
        if App.fire.auth.currentUser == nil {
            loginRequest()
        } else {
            logoutRequest()
        }
    }
}
