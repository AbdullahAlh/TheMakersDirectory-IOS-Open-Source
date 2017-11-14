//
//  LocationCell.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/15/16.
//  Copyright © 2016 level3. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Kingfisher


class LocationCell: UICollectionViewCell {
 
    @IBOutlet weak var previewImageView: UIImageView!
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    var location = Location() {
        didSet { updateContent() }
    }
    
    var observerHandle: UInt = 0
    
    var locationRef = FIRDatabaseReference() {
        willSet { locationRef.removeObserver(withHandle: observerHandle) }
        didSet { observeFireData() }
    }
    
    
    deinit {
        locationRef.removeObserver(withHandle: observerHandle)
    }
    
    private func observeFireData() {
        
        observerHandle = locationRef.observe(.value) { [weak self] (snapshot: FIRDataSnapshot) in
            
            if let sself = self, let dict = snapshot.value as? [String:Any] {
                sself.location = Location(dict: dict)
            }
        }
    }
    
    private func updateContent() {
        
        callButton.isEnabled = !location.phoneNumbers.isEmpty
        locationButton.isEnabled = location.coordinates != nil
        
        nameLabel.text = location.name.value
        typeLabel.text = location.type.value
        previewImageView.kf.setImage(with: location.imageURL)
    }
    
    
    @IBAction func callPressed(_ sender: AnyObject) {
        App.call(location.phoneNumbers)
    }
    
    @IBAction func locationPressed(_ sender: AnyObject) {
        App.showMap(location.coordinates!)
    }
}
