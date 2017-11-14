//
//  LocalizedString.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/14/16.
//  Copyright © 2016 level3. All rights reserved.
//

import Foundation


struct LocalizedString {
    
    var strings: [Locality:String] = [:]
    
    var value: String {
        return strings[Locality.appLocality] ?? "ERR"
    }
}


// MARK: - serialization


extension LocalizedString {

    init(dict: [String:Any], prefix: String) {
        
        let defaultString = dict[prefix] as? String ?? ""
        strings[.arabic] = (dict["\(prefix)_ar"] as? String ?? defaultString).trimmed
        strings[.english] = defaultString.trimmed
    }
}
