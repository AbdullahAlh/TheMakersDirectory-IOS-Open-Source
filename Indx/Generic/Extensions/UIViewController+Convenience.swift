//
//  UIViewController+Convenience.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/17/16.
//  Copyright © 2016 level3. All rights reserved.
//

import UIKit


extension UIViewController {
    
    @IBAction func dismissPresentedViewController() {
        dismiss(animated: true, completion: nil)
    }
}
