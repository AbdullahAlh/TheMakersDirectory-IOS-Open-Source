//
//  MainViewController.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/14/16.
//  Copyright © 2016 level3. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {
    
    var embeddedTabBarController: UITabBarController {
        return childViewControllers.first as! UITabBarController
    }
    
    // recreated everytime
    var itemSubmissionViewController: ItemSubmissionViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ItemSubmissionViewController")
        return controller as! ItemSubmissionViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        embeddedTabBarController.delegate = self
    }
}

extension MainViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard viewController.title == "dummy" else {
            return true
        }
        
        guard App.fire.auth.currentUser != nil else {
            
            let alert = UIAlertController(
                title: NSLocalizedString("ALERT_TITLE_LOGIN", comment: ""),
                message: NSLocalizedString("ALERT_MSG_LOGIN", comment: ""),
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("ALERT_BTN_CANCEL", comment: ""), style: .cancel))
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("BTN_SIGN_IN", comment: ""), style: .default) { _ in
                self.present(AuthViewController.instantiate(), animated: true, completion: nil)
            })
            
            present(alert, animated: true, completion: nil)
            
            return false
        }

        present(itemSubmissionViewController, animated: true, completion: nil)
        return false
    }
}
