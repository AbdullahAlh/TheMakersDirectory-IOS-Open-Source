//
//  Product.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/28/16.
//  Copyright © 2016 level3. All rights reserved.
//

import Foundation


protocol Product: Shareable {
    
    var name: LocalizedString { get }
    var description: LocalizedString { get }
    var imageURL: URL? { get }
    var locationKeys: [String] { get }
}
