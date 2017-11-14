//
//  Coordinates.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/14/16.
//  Copyright © 2016 level3. All rights reserved.
//


struct Coordinates {
    
    var latitude = 0.0
    var longitude = 0.0
}


// MARK: core location mapping


import CoreLocation


extension Coordinates {
    
    var asCLCoordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(coordinates2d: CLLocationCoordinate2D) {
        
        latitude = coordinates2d.latitude
        longitude = coordinates2d.longitude
    }
}


// MARK: - serialization


extension Coordinates: Serializable {

    init?(dict: [String:Any]) {
        
        guard let latitude = dict["lat"] as? Double,
            let longitude = dict["lng"] as? Double
            else {
                return nil
        }
        
        self.longitude = longitude
        self.latitude = latitude
    }
}
