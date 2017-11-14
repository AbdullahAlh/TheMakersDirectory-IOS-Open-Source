//
//  FireManager.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/14/16.
//  Copyright © 2016 level3. All rights reserved.
//

import Foundation
import Firebase


final class FireManager {
    
    // MARK: - properties
    
    let data = FireData()
    let auth = FireAuth()
    let links = FireLinks()
    let storage = FireStorage()
    let push = FirebPush()
    
    // MARK: - public methods
    
    func setup() {
        FIRApp.configure()
        
        auth.setup()
        data.setup()
        push.setup()
    }
}
