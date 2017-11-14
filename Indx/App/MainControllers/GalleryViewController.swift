//
//  GalleryViewController.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/14/16.
//  Copyright © 2016 level3. All rights reserved.
//

import UIKit
import PureLayout
import FirebaseDatabase


class GalleryViewController: UIViewController {
    
    // MARK: - properties
    
    var fireObservers: [UInt] = []
    var fireReference: FIRDatabaseReference {
        fatalError("override me")
    }
    
    lazy var collectionViewController: GalleryCollectionViewController = {
        
        let storyboard = UIStoryboard(name: "Gallery", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "GalleryCollectionViewController") as! GalleryCollectionViewController
        
        self.addChildViewController(controller)
        controller.didMove(toParentViewController: self)
        
        return controller
    }()
    
    
    deinit {
        fireObservers.forEach(fireReference.removeObserver(withHandle:))
    }
    
    // MARK: - view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collectionView = collectionViewController.view!
        
        view.addSubview(collectionView)
        collectionView.autoPinEdgesToSuperviewEdges()
    }
}
