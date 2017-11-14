//
//  LocationCollectionViewController.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/15/16.
//  Copyright © 2016 level3. All rights reserved.
//

import UIKit
import FirebaseDatabase


class LocationCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    // MARK: - static convenience
    
    class func instantiate() -> LocationCollectionViewController {
        
        let storyboard = UIStoryboard(name: "Gallery", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "LocationCollectionViewController") as! LocationCollectionViewController
    }
    
    // MARK: - properties
    
    var locationRef: FIRDatabaseReference = FIRDatabaseReference() {
        didSet { updateContent() }
    }
    
    private var location = Location() {
        didSet {
            title = location.name.value
            collectionView?.reloadData()
        }
    }
    
    
    private func updateContent() {
        
        locationRef.observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            if let dict = snapshot.value as? [String:Any] {
                self.location = Location(dict: dict)
            }
        }
    }
    
    // MARK: view lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action, target: self, action: #selector(share))

        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
    }
    
    // MARK: - action methods
    
    func share() {
        let controller = UIActivityViewController(activityItems: [location.shareItem], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewFlowLayout methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        switch section {
        case 0:
            return CGSize(width: collectionView.bounds.width, height: 180)
        case 1:
            return CGSize.zero
        default:
            return location.branches.isEmpty ? CGSize.zero : CGSize(width: collectionView.bounds.width, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        var rightInset: CGFloat = 0
        var leftInset: CGFloat = 0
        let inset = (collectionView.bounds.width - 60 * 3) / 2
        
        if Locality.appLocality.isRTL {
            rightInset = inset
        } else {
            leftInset = inset
        }
    
        switch section {
        case 0:     return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
        default:    return UIEdgeInsets.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.section {
        case 0:     return CGSize(width: 60, height: 60)
        case 1:     return CGSize(width: collectionView.bounds.width, height: 200)
        case 2:     return CGSize(width: collectionView.bounds.width, height: 90)
        default:    fatalError("unexpected section")
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:     return 3
        case 1:     return location.coordinates == nil ? 0 : 1
        case 2:     return location.branches.count
        default:    fatalError("unexpected section")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: "SectionHeader",
            for: indexPath
        ) as! SectionHeader
        
        switch indexPath.section {
        case 0:
            view.imageView.isHidden = false
            view.imageView.kf.setImage(with: location.imageURL)
        default:
            view.imageView.isHidden = true
            view.textLabel.text = NSLocalizedString("SECTION_HEADER_BRANCHES", comment: "")
        }
        
        return view
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
            cell.button.removeTarget(self, action: nil, for: .allEvents)
            
            switch indexPath.item {
            case 0:
                cell.button.setImage(#imageLiteral(resourceName: "website-icon"), for: .normal)
                cell.button.addTarget(self, action: #selector(openWebsite), for: .touchUpInside)
                cell.button.isEnabled = location.url != nil
                
            case 1:
                cell.button.setImage(#imageLiteral(resourceName: "phone-icon"), for: .normal)
                cell.button.addTarget(self, action: #selector(call), for: .touchUpInside)
                cell.button.isEnabled = !location.phoneNumbers.isEmpty
            
            case 2:
                cell.button.setImage(#imageLiteral(resourceName: "location-icon"), for: .normal)
                cell.button.addTarget(self, action: #selector(openMap), for: .touchUpInside)
                cell.button.isEnabled = location.coordinates != nil
            
            default: fatalError("unexpected item")
            }
            
            return cell
        
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapCell", for: indexPath) as! MapCell
            cell.coordinates = location.coordinates!
            
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BranchCell", for: indexPath) as! BranchCell
            cell.branch = location.branches[indexPath.item]
        
            return cell
            
        default:
            fatalError("unexpected section")
        }
    }
    
    // MARK: action methods
    
    func openWebsite() {
        App.openURL(location.url!)
    }
    
    func call() {
        App.call(location.phoneNumbers)
    }
    
    func openMap() {
        App.showMap(location.coordinates!)
    }
}
