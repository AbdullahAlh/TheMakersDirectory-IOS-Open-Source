//
//  Material.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/28/16.
//  Copyright © 2016 level3. All rights reserved.
//

import Foundation


struct Material: Product {
    
    // MARK: - properties
    
    var key = ""
    var name = LocalizedString()
    var description = LocalizedString()
    var imageURL: URL? = nil
    
    var locationKeys: [String] = []
}


// MARK: - gallery item


extension Material: GalleryItem {}


// MARK: - sharing


extension Material: Shareable {
    
    var pathComponents: [String] {
        return ["material", key]
    }
    
    var shareItem: String {
        
        return "\(name.value):"
            + "\n\(description.value)"
            + "\n\(App.generateDeeplink(self))"
    }
}

// MARK: - serialization


extension Material: Serializable {
    
    init(dict: [String:Any]) {
        
        key = (dict["objectID"] as? String ?? "").trimmed
        name = LocalizedString(dict: dict, prefix: "name")
        description = LocalizedString(dict: dict, prefix: "description")
        
        if let string = dict["img"] as? String {
            imageURL = URL(string: string.trimmed)
        }
        
        if let keysDict = dict["location"] as? [String:Bool] {
            locationKeys = keysDict.keys.map { $0.trimmed }
        }
    }
}
