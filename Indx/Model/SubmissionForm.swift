//
//  SubmissionForm.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/14/16.
//  Copyright © 2016 level3. All rights reserved.
//

import Foundation

struct SubmissionForm {
    
    // MARK: - nested types

    enum Kind {
        
        case project
        case material
        case tool
    }
    
    // MARK: - properties
    
    var kind = Kind.project
    var name = ""
    var description = ""
    var userEmail = ""
    
    var locationName: String? = nil
    var locationAddress: String? = nil
    var coordinates: Coordinates? = nil
}


// MARK: - validation

extension SubmissionForm {

    func validate() -> String? {
        
        guard !name.isEmpty else {
            return NSLocalizedString("FORM_ERROR_EMPTY_NAME", comment: "")
        }
        
        guard !description.isEmpty else {
            return NSLocalizedString("FORM_ERROR_DETAILS_EMPTY", comment: "")
        }
        
        return nil
    }
}


// MARK: - serialization


extension SubmissionForm {

    var asDict: [String:Any] {
        var dict: [String:Any] = [
            "type": kind.serialized,
            "name": name,
            "description": description,
            "user": userEmail,
        ]
        
        if let locationName = locationName {
            dict["place_name"] = locationName
        }
        
        if let locationAddress = locationAddress {
            dict["place_address"] = locationAddress
        }
        
        if let coordinates = coordinates {
            dict["latlng"] = "lat/lng: (\(coordinates.latitude),\(coordinates.longitude))"
        }
        
        return dict
    }
}


extension SubmissionForm.Kind {

    var serialized: String {
        switch self {
        case .project:  return "Projects"
        case .tool:     return "Tools"
        case .material: return "Materials"
        }
    }
}
