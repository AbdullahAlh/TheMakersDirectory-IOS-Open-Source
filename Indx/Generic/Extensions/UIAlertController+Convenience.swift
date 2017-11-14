//
//  UIAlertController+Convenience.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/18/16.
//  Copyright © 2016 level3. All rights reserved.
//

import UIKit


extension UIAlertController {
    
    static func infoAlert(title: String?, message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ALERT_BTN_OK", comment: ""), style: .cancel))
        
        return alert
    }
    
    static func errorAlert(message: String) -> UIAlertController {
        
        let alert = UIAlertController(
            title: NSLocalizedString("ALERT_TITLE_ERROR", comment: ""),
            message: message,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ALERT_BTN_CANCEL", comment: ""), style: .cancel))
        return alert
    }
}
