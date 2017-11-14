//
//  String+Convenience.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/25/16.
//  Copyright © 2016 level3. All rights reserved.
//

import UIKit


extension String {
    
    var trimmed: String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func calculateHeight(width: CGFloat, font: UIFont) -> CGFloat {
        
        let string = self as NSString
        return string.boundingRect(
            with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin],
            attributes: [NSFontAttributeName:font],
            context: nil).height
    }
}
