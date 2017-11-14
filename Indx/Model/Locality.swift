//
//  Locality.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/14/16.
//  Copyright © 2016 level3. All rights reserved.
//

import Foundation


enum Locality {
    
    case english
    case arabic
    
    
    static var appLocality: Locality {
        get {
            let lang = Locale.preferredLanguages.first ?? "en"
            return lang.contains("ar") ? .arabic : .english
        }
        set {
            let langs: [String]
            switch newValue {
            case .english:  langs = ["en"]
            case .arabic:   langs = ["ar"]
            }
            
            UserDefaults.standard.set(langs, forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        }
    }
    
    var isRTL: Bool {
        return [Locality.arabic].contains(self)
    }
}
