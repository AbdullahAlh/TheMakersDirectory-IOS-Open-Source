//
//  ProjectCollectionViewController.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/15/16.
//  Copyright © 2016 level3. All rights reserved.
//

import UIKit
import FirebaseDatabase


class ProjectCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    // MARK: - static convenience
    
    class func instantiate() -> ProjectCollectionViewController {
        
        let storyboard = UIStoryboard(name: "Gallery", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ProjectCollectionViewController") as! ProjectCollectionViewController
        return controller
    }
    
    // MARK: - properties
    
    var projectRef = FIRDatabaseReference() {
        willSet { projectRef.removeAllObservers() }
        didSet { updateContent() }
    }
    
    private(set) var project: Project = Project() {
        didSet {
            title = project.name.value
            data = [
                project.materialKeys.map(App.fire.data.materials.child(_:)),
                project.toolKeys.map(App.fire.data.tools.child(_:)),
            ]
        }
    }
    
    private var data: [[FIRDatabaseReference]] = [[]] {
        didSet { collectionView?.reloadData() }
    }
    
    // MARK: init & deinit
    
    deinit {
        projectRef.removeAllObservers()
    }
    
    // MARK: view lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action, target: self, action: #selector(share))
        
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // MARK: - private methods
    
    private func updateContent() {
        
        projectRef.observe(.value) { [unowned self] (snapshot: FIRDataSnapshot) in
            if var dict = snapshot.value as? [String:Any] {
                dict["objectID"] = snapshot.key
                self.project = Project(dict: dict)
            }
        }
    }
    
    // MARK: - action methods
    
    func share() {
        let controller = UIActivityViewController(activityItems: [project.shareItem], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
    }

    // MARK: - UICollectionViewDataSource methods
    
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
            let height = project.description.value.calculateHeight(
                width: collectionView.bounds.width - 16, font: UIFont.systemFont(ofSize: 15))
            return CGSize(width: collectionView.bounds.width, height: height + 20)
            
        default:
            return CGSize(width: collectionView.bounds.width / 2 - 15, height: 115)
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:     return project.description.value.isEmpty ? 0 : 1
        default:    return data[section - 1].count
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
            view.imageView.kf.setImage(with: project.imageURL)
        case 1:
            view.imageView.isHidden = true
            view.textLabel.text = NSLocalizedString("SECTION_HEADER_MATERIALS", comment: "")
        default:
            view.imageView.isHidden = true
            view.textLabel.text = NSLocalizedString("SECTION_HEADER_TOOLS", comment: "")
        }
        
        return view
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "DescriptionCell", for: indexPath) as! DescriptionCell
            cell.descriptionLabel.text = project.description.value
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ProjectProductCell", for: indexPath) as! ProjectProductCell
            cell.productRef = data[indexPath.section - 1][indexPath.item]
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? ProjectProductCell else {
            return
        }
        
        let controller = ProductCollectionViewController.instantiate()
        controller.productRef = cell.productRef
        
        navigationController!.pushViewController(controller, animated: true)
    }
}
