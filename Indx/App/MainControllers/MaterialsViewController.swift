//
//  MaterialsViewController.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/18/16.
//  Copyright © 2016 level3. All rights reserved.
//

import UIKit
import FirebaseDatabase


class MaterialsViewController: GalleryViewController {

    override var fireReference: FIRDatabaseReference {
        return App.fire.data.materials
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewController.selectionHandler = { item in
            
            let controller = ProductCollectionViewController.instantiate()
            controller.productRef = App.fire.data.materials.child(item.key)
            
            return controller
        }
        
        let observer = fireReference.observe(.value) { [unowned self] (snapshot: FIRDataSnapshot) in
            
            if let data = snapshot.value as? [String:[String:Any]] {
                self.collectionViewController.galleryItems = Material.parse(dict: data)
            }
        }
        
        fireObservers.append(observer)
    }
}
