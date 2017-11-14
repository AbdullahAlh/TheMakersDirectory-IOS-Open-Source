//
//  SearchQuery.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/14/16.
//  Copyright © 2016 level3. All rights reserved.
//

import Foundation


enum SearchState {
    
    case idle
    case loading
}

enum SearchIndex: String {
    
    case places = "places"
    case directory = "directory"
}

struct SearchQuery {
    
    var text = ""
    var page: UInt? = nil
}
