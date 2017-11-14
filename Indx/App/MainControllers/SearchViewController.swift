//
//  SearchViewController.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/17/16.
//  Copyright © 2016 level3. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    fileprivate lazy var productsSearchController: SearchController = {
        
        weak var wself = self
        return SearchController(index: .directory) { (opResult: [[String:Any]]?, _: Error?) in
            
            if let sself = wself, let result = opResult {
                
                let products: [GalleryItem] = result.flatMap { dict in
                    
                    switch (dict["type"] as? String) ?? "x" {
                    case "Material":    return Material(dict: dict)
                    case "Tool":        return Tool(dict: dict)
                    case let x:
                        NSLog("[ERR]: unexpected product type - \(x)")
                        return nil
                    }
                }
                
                sself.productsViewController.searchState = .idle
                sself.productsViewController.galleryItems = products
            }
        }
    }()
    
    fileprivate lazy var locationsSearchController: SearchController = {

        weak var wself = self
        return SearchController(index: .places) { (opResult: [[String:Any]]?, _: Error?) in
            if let sself = wself, let result = opResult {
                sself.locationsViewController.searchState = .idle
                sself.locationsViewController.locationIds = result.flatMap { $0["objectID"] as? String }
            }
        }
    }()
    
    var pageController: UIPageViewController {
        return childViewControllers.first as! UIPageViewController
    }
    
    lazy var productsViewController: GalleryCollectionViewController = {
        
        let storyboard = UIStoryboard(name: "Gallery", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "GalleryCollectionViewController") as! GalleryCollectionViewController
        controller.selectionHandler = { item in
            
            let controller = ProductCollectionViewController.instantiate()
            
            switch item {
            case let tool as Tool:
                controller.productRef = App.fire.data.tools.child(item.key)
            case let material as Material:
                controller.productRef = App.fire.data.materials.child(item.key)
            default:
                fatalError("unexpected object type: \(item)")
            }
            
            return controller
        }
        
        return controller
    }()
    
    lazy var locationsViewController: LocationListCollectionViewController = {
        
        let storyboard = UIStoryboard(name: "Gallery", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LocationListCollectionViewController")
        return controller as! LocationListCollectionViewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pageController.dataSource = self
        pageController.delegate = self
        
        updateCurrentViewController(productsViewController, direction: .forward, animated: false)
        
        navigationItem.titleView = {
            
            let searchBar = UISearchBar()
            searchBar.delegate = self
            
            return searchBar
        }()
    }
    
    private func updateCurrentViewController(_ viewController: UIViewController, direction: UIPageViewControllerNavigationDirection, animated: Bool) {
        pageController.setViewControllers([viewController], direction: direction, animated: animated, completion: nil)
    }
    
    fileprivate func updateSegmentSelection() {
        
        if let controller = pageController.viewControllers?.first {
            segmentControl.selectedSegmentIndex = controller === productsViewController ? 0 : 1
        }
    }
    
    @IBAction func segmentControlValueChanged(_ sender: AnyObject) {
        
        let params: (UIViewController, UIPageViewControllerNavigationDirection)
        
        switch segmentControl.selectedSegmentIndex {
        case 0: params = (productsViewController, Locality.appLocality.isRTL ? .forward : .reverse)
        case 1: params = (locationsViewController, Locality.appLocality.isRTL ? .reverse : .forward)
        default: fatalError("Only 2 segments are supported")
        }
        
        updateCurrentViewController(params.0, direction: params.1, animated: true)
    }
    
}

extension SearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if !searchText.isEmpty {
            
            productsViewController.searchState = .loading
            locationsViewController.searchState = .loading
            
            let query = SearchQuery(text: searchText, page: 0)
            productsSearchController.perform(query: query)
            locationsSearchController.perform(query: query)
        }
    }
}

extension SearchViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return (viewController === locationsViewController ? productsViewController : nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return (viewController === productsViewController ? locationsViewController : nil)
    }
}

extension SearchViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        updateSegmentSelection()
    }
}
