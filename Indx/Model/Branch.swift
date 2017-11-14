//
//  Branch.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/14/16.
//  Copyright © 2016 level3. All rights reserved.
//

import Foundation


struct Branch {
    
    var name = LocalizedString()
    var phoneNumbers: [String] = []
    var coordinates: Coordinates? = nil
}


// MARK: - serialization


extension Branch: Serializable {

    init(dict: [String:Any]) {
        
        name = LocalizedString(dict: dict, prefix: "name")
        coordinates = Coordinates(dict: dict)
        
        if let numbers = dict["phone_number"] as? [String] {
            phoneNumbers = numbers.map { $0.trimmed }
        }
    }
}
