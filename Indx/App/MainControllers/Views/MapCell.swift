//
//  MapCell.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/16/16.
//  Copyright © 2016 level3. All rights reserved.
//

import UIKit
import GoogleMaps
import PureLayout


class MapCell: UICollectionViewCell {
    
    var coordinates = Coordinates() {
        didSet { updateContent() }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 12)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        
        contentView.addSubview(mapView)
        mapView.autoPinEdgesToSuperviewEdges()
    }
    
    private func updateContent() {
      
        let camera = GMSCameraPosition.camera(withLatitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 15)
        let mapView = contentView.subviews.first! as! GMSMapView
        mapView.camera = camera
        
        let marker = GMSMarker(position: coordinates.asCLCoordinates)
        marker.map = mapView
    }
}
