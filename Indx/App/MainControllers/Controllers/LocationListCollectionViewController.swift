//
//  LocationListCollectionViewController.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/17/16.
//  Copyright © 2016 level3. All rights reserved.
//

import UIKit
import FirebaseDatabase
import DZNEmptyDataSet


class LocationListCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    // MARK: properties
    
    var searchState = SearchState.idle {
        didSet { collectionView?.reloadEmptyDataSet() }
    }
    
    var locationIds: [String] = [] {
        didSet {
            locationRefs = locationIds.map(App.fire.data.locations.child(_:))
        }
    }
    
    private var locationRefs: [FIRDatabaseReference] = [] {
        didSet { collectionView?.reloadData() }
    }
    
    // MARK: view lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.emptyDataSetSource = self
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 90)
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locationRefs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationCell", for: indexPath) as! LocationCell
        cell.locationRef = locationRefs[indexPath.item]
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let controller = LocationCollectionViewController.instantiate()
        controller.locationRef = locationRefs[indexPath.item]
        
        navigationController!.pushViewController(controller, animated: true)
    }
}

extension LocationListCollectionViewController: DZNEmptyDataSetSource {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        switch searchState {
        case .idle:
            return NSAttributedString(
                string: NSLocalizedString("EMPTY_FEED_MSG", comment: ""),
                attributes: [:]
            )
            
        default:
            return nil
        }
    }
    
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        
        switch searchState {
        case .loading:
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            spinner.startAnimating()
        
            return spinner
            
        default:
            return nil
        }
    }
}

