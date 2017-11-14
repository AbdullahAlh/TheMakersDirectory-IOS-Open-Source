//
//  ReplaceSegue.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/28/16.
//  Copyright © 2016 level3. All rights reserved.
//

import UIKit


class ReplaceSegue: UIStoryboardSegue {

    override func perform() {
        assert(App.window.rootViewController == source)
        
        let animation = CATransition()
        animation.type = kCATransitionFade
        animation.duration = 0.3
        
        App.window.layer.add(animation, forKey: "fade")
        App.window.rootViewController = destination
    }
}
