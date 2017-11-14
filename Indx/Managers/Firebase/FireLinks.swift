//
//  FireLinks.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/28/16.
//  Copyright © 2016 level3. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDynamicLinks


final class FireLinks {
    
    func handle(url: URL) -> Bool {
        if let link = FIRDynamicLinks.dynamicLinks()?.dynamicLink(fromCustomSchemeURL: url) {
            handle(link: link)
            return true
        }
        return false
    }
    
    func handle(userActivity: NSUserActivity) -> Bool {
        
        guard let incomingURL = userActivity.webpageURL else {
            return false
        }
        
        return FIRDynamicLinks.dynamicLinks()?.handleUniversalLink(incomingURL) { (opLink, opError) in
            
            switch (opLink, opError) {
            case (.some(let link), _):
                self.handle(link: link)
            case (_, .some(let error)):
                NSLog("[ERR]: dynamic link error - \(error.localizedDescription)")
            default:
                NSLog("[ERR]: unexpected result combination")
            }
        } ?? false
    }
    
    private func handle(link: FIRDynamicLink) {
        
        guard let url = link.url, url.pathComponents.count == 3 else {
            NSLog("[ERR]: unable to handle link: \(link.url?.absoluteString ?? "(null)")")
            return
        }
        
        let path = url.pathComponents
        
        let itemController: UIViewController
        switch path[1] {
        case "project":
            let controller = ProjectCollectionViewController.instantiate()
            controller.projectRef = App.fire.data.projects.child(path[2])
            itemController = controller
            
        case "place":
            let controller = LocationCollectionViewController.instantiate()
            controller.locationRef = App.fire.data.locations.child(path[2])
            itemController = controller
            
        case "material":
            let controller = ProductCollectionViewController.instantiate()
            controller.productRef = App.fire.data.materials.child(path[2])
            itemController = controller
            
        case "tool":
            let controller = ProductCollectionViewController.instantiate()
            controller.productRef = App.fire.data.tools.child(path[2])
            itemController = controller
            
        default:
            NSLog("[ERR]: unexpected path \(path)")
            return
        }
        
        itemController.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: itemController,
            action: #selector(UIViewController.dismissPresentedViewController)
        )
        
        let controller = UINavigationController(rootViewController: itemController)
        App.window.rootViewController!.present(controller, animated: true, completion: nil)
    }
}
