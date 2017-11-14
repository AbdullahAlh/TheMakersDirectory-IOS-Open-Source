//
//  GalleryItem.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/18/16.
//  Copyright © 2016 level3. All rights reserved.
//

import Foundation

protocol GalleryItem: Serializable {
    
    var key: String { get }
    var name: LocalizedString { get }
    var imageURL: URL? { get }
}


extension GalleryItem {
    
    static func parse(dict: [String:[String:Any]]) -> [GalleryItem] {
        
        var result: [GalleryItem?] = []
        for (key, subdict) in dict {
            
            var newdict = subdict
            newdict["objectID"] = key
            
            result.append(self.init(dict: newdict))
        }
        
        return result.flatMap { $0 }
    }
}
