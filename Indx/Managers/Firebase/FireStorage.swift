//
//  FireStorage.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/14/16.
//  Copyright © 2016 level3. All rights reserved.
//

import Foundation
import FirebaseStorage


final class FireStorage {
    
    // MARK: - properties
    
    lazy var images = FIRStorage.storage().reference(forURL: "gs://the-makers-directory.appspot.com")
}
