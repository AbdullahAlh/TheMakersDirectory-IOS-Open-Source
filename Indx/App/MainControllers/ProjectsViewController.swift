//
//  ProjectsViewController.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/18/16.
//  Copyright © 2016 level3. All rights reserved.
//

import UIKit
import FirebaseDatabase


class ProjectsViewController: GalleryViewController {

    override var fireReference: FIRDatabaseReference {
        return App.fire.data.projects
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionViewController.selectionHandler = { item in
            
            let controller = ProjectCollectionViewController.instantiate()
            controller.projectRef = App.fire.data.projects.child(item.key)
            return controller
        }

        let observer = fireReference.observe(.value) { [unowned self] (snapshot: FIRDataSnapshot) in
            
            if let data = snapshot.value as? [String:[String:Any]] {
                self.collectionViewController.galleryItems = Project.parse(dict: data)
            }
        }
        
        fireObservers.append(observer)
    }
}
