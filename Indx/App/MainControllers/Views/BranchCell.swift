//
//  BranchCell.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/16/16.
//  Copyright © 2016 level3. All rights reserved.
//

import UIKit

class BranchCell: UICollectionViewCell {
    
    // MARK: properties
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    var branch = Branch() {
        didSet { updateContent() }
    }
    
    
    // MARK: public methods
    
    func updateContent() {
        
        nameLabel.text = branch.name.value
        callButton.isEnabled = !branch.phoneNumbers.isEmpty
        locationButton.isEnabled = branch.coordinates != nil
    }
    
    // MARK: action methods
    
    @IBAction func callButtonPressed(_ sender: AnyObject) {
        App.call(branch.phoneNumbers)
    }
    
    @IBAction func locationButtonPressed(_ sender: AnyObject) {
        App.showMap(branch.coordinates!)
    }
}
