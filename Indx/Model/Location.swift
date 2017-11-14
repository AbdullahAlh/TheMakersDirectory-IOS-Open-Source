//
//  Location.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/14/16.
//  Copyright © 2016 level3. All rights reserved.
//

import Foundation


struct Location {
    
    // MARK: - properties
    
    var key = ""
    var name = LocalizedString()
    var type = LocalizedString()
    var phoneNumbers: [String] = []
    var branches: [Branch] = []
    
    var coordinates: Coordinates? = nil
    
    var url: URL? = nil
    var imageURL: URL? = nil
    var logoURL: URL? = nil
}


// MARK: - sharing


extension Location: Shareable {
    
    var pathComponents: [String] {
        return ["place", key]
    }
    
    var shareItem: String {
        
        return "\(name.value):"
            + "\n\(App.generateDeeplink(self))"
    }
}


// MARK: - serialization


extension Location: Serializable {

    init(dict: [String:Any]) {
        
        key = (dict["objectID"] as? String)?.trimmed ?? "ERR"
        name = LocalizedString(dict: dict, prefix: "name")
        type = LocalizedString(dict: dict, prefix: "type")
        coordinates = Coordinates(dict: dict)
        
        if let string = dict["url"] as? String {
            url = URL(string: string.trimmed)
        }
        
        if let string = dict["img"] as? String {
            imageURL = URL(string: string.trimmed)
        }
        
        if let string = dict["logo"] as? String {
            logoURL = URL(string: string.trimmed)
        }
        
        if let numbers = dict["phone_number"] as? [String] {
            phoneNumbers = numbers.map { $0.trimmed }
        }
        
        let branchDicts: [[String:Any]]
        
        switch dict["branch"] {
        case .some(let array as [[String:Any]]):
            branchDicts = array
            
        case .some(let dict as [Int:[String:Any]]):
            branchDicts = Array(dict.values)
            
        default:
            branchDicts = []
        }
        
        branches = branchDicts.map(Branch.init(dict:))
    }
}
