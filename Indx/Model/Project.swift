//
//  Project.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/14/16.
//  Copyright © 2016 level3. All rights reserved.
//

import Foundation


struct Project {
    
    var key = ""
    var name = LocalizedString()
    var description = LocalizedString()
    var imageURL: URL? = nil
    
    var toolKeys: [String] = []
    var materialKeys: [String] = []
    
}


// MARK: - gallery item


extension Project: GalleryItem {}


// MARK: - sharing


extension Project: Shareable {
    
    var pathComponents: [String] {
        return ["project", key]
    }
    
    var shareItem: String {
        
        return "\(name.value):"
        + "\n\(description.value)"
        + "\n\(App.generateDeeplink(self))"
    }
}


// MARK: - serialization


extension Project: Serializable {

    init(dict: [String:Any]) {
        
        key = (dict["objectID"] as? String ?? "").trimmed
        name = LocalizedString(dict: dict, prefix: "name")
        description = LocalizedString(dict: dict, prefix: "description")
        
        if let string = dict["img"] as? String {
            imageURL = URL(string: string.trimmed)
        }
        
        let toolsDict = dict["tools"] as? [String:Bool] ?? [:]
        let materialsDict = dict["materials"] as? [String:Bool] ?? [:]
        
        toolKeys = Array(toolsDict.keys)
        materialKeys = Array(materialsDict.keys)
    }
}
