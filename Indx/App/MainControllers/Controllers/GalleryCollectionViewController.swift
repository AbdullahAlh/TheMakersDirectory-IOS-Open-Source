//
//  GalleryCollectionViewController.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/14/16.
//  Copyright © 2016 level3. All rights reserved.
//

import UIKit
import DZNEmptyDataSet


class GalleryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    // MARK: nested types
    
    typealias SelectionHandler = (GalleryItem) -> (UIViewController?)
    
    // MARK: properties
    
    var searchState = SearchState.idle {
        didSet { collectionView?.reloadEmptyDataSet() }
    }
    
    var galleryItems: [GalleryItem] = [] {
        didSet { collectionView?.reloadData() }
    }
    
    var selectionHandler: SelectionHandler = { _ in return nil }
    
    // MARK: view lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.emptyDataSetSource = self
    }
    
    // MARK: - UICollectionViewFlowLayout delegate methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 2, height: 184)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryItems.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as! GalleryCell
        cell.galleryItem = galleryItems[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = galleryItems[indexPath.item]
        if let controller = selectionHandler(item) {
            navigationController!.pushViewController(controller, animated: true)
        }
    }
}


extension GalleryCollectionViewController: DZNEmptyDataSetSource {
    
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


