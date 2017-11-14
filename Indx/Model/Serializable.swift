//
//  Serializable.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/18/16.
//  Copyright © 2016 level3. All rights reserved.
//

import Foundation

protocol Serializable {
    init?(dict: [String:Any])
}
