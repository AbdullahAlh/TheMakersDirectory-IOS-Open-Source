//
//  ProjectProductCell.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/15/16.
//  Copyright © 2016 level3. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Kingfisher


class ProjectProductCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var previewImageView: UIImageView!
    
    
    var observerHandle: UInt = 0

    var productRef = FIRDatabaseReference() {
        willSet { productRef.removeObserver(withHandle: observerHandle) }
        didSet { updateContent() }
    }
    
    deinit {
        productRef.removeObserver(withHandle: observerHandle)
    }
    
    private func updateContent() {

        observerHandle = productRef.observe(.value) { [weak self] (snapshot: FIRDataSnapshot) in
         
            if let sself = self, let dict = snapshot.value as? [String:Any] {
                
                let product: Product
                switch sself.productRef.parent?.key ?? "x" {
                case "Tool":
                    product = Tool(dict: dict)
                case "Material":
                    product = Material(dict: dict)
                case let x:
                    NSLog("[ERR]: Oops .. badass - \(x)")
                    return
                }
                
                sself.nameLabel.text = product.name.value
                sself.previewImageView.kf.setImage(with: product.imageURL)
            }
        }
    }
}
