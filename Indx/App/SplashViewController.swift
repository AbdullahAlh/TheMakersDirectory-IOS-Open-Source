//
//  SplashViewController.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/28/16.
//  Copyright © 2016 level3. All rights reserved.
//

import UIKit

// very first view controller where we decide whether to 
// show the onboarding, or dive straight into the app
class SplashViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "did-show-onboarding") {
            performSegue(withIdentifier: "splash-main", sender: self)
        } else {
            UserDefaults.standard.set(true, forKey: "did-show-onboarding")
            performSegue(withIdentifier: "splash-onboarding", sender: self)
        }
    }
}
