//
//  ProductCollectionViewController.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/15/16.
//  Copyright © 2016 level3. All rights reserved.
//

import UIKit
import FirebaseDatabase


class ProductCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    // MARK: - static convenience
    
    class func instantiate() -> ProductCollectionViewController {
        
        let storyboard = UIStoryboard(name: "Gallery", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ProductCollectionViewController") as! ProductCollectionViewController
    }
    
    // MARK: - properties

    private var product: Product = Tool() {
        didSet {
            title = product.name.value
            locationRefs = product.locationKeys.map(App.fire.data.locations.child(_:))
        }
    }
    
    var productRef = FIRDatabaseReference() {
        didSet { updateContent() }
    }
    
    var locationRefs: [FIRDatabaseReference] = [] {
        didSet { collectionView?.reloadData() }
    }
    
    // MARK: view lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action, target: self, action: #selector(share))
    }
    
    // MARK: - action methods
    
    func share() {
        let controller = UIActivityViewController(activityItems: [product.shareItem], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: private methods
    
    private func updateContent() {
        
        productRef.observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            
            if var dict = snapshot.value as? [String:Any] {
                
                dict["objectID"] = snapshot.key
                switch self.productRef.parent?.key ?? "x" {
                case "Tool":
                    self.product = Tool(dict: dict)
                case "Material":
                    self.product = Material(dict: dict)
                case let x:
                    NSLog("[ERR]: Oops .. badass - \(x)")
                }
            }
        }
    }
    
    // MARK: UICollectionViewFlowLayoutDelegate methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        switch section {
        case 0:
            return CGSize(width: collectionView.bounds.width, height: 180)
        default:
            return CGSize(width: collectionView.bounds.width, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.section {
        case 0:
            let height = product.description.value.calculateHeight(
                width: collectionView.bounds.width - 16, font: UIFont.systemFont(ofSize: 15))
            return CGSize(width: collectionView.bounds.width, height: height + 20)
            
        default:
            return CGSize(width: collectionView.bounds.width, height: 100)
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0: return product.description.value.isEmpty ? 0 : 1
        case 1: return locationRefs.count
        default: fatalError("unexpected section count")
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
            view.imageView.kf.setImage(with: product.imageURL)
            
        default:
            view.imageView.isHidden = true
            view.textLabel.text = NSLocalizedString("PRODUCT_LOCATION_HEADER", comment: "")
        }
        
        return view
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCell", for: indexPath) as! DescriptionCell
            cell.descriptionLabel.text = product.description.value
            
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationCell", for: indexPath) as! LocationCell
            cell.locationRef = locationRefs[indexPath.item]
        
            return cell
            
        default:
            fatalError("unexpected section count")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let location = locationRefs[indexPath.item]
        let controller = LocationCollectionViewController.instantiate()
        controller.locationRef = location
        
        navigationController!.pushViewController(controller, animated: true)
    }
}
