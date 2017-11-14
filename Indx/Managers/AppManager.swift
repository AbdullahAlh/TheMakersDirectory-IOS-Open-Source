//
//  AppManager.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/14/16.
//  Copyright © 2016 level3. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import GoogleMaps
import GooglePlaces
import MapKit


let App = AppManager.instance

class AppManager {

    // MARK: - static members
    
    static let instance = AppManager()
    
    // MARK: - properties
    
    let fire = FireManager()
    let tint = UIColor(red:0.91, green:0.61, blue:0.24, alpha:1.00)
    
    var window = UIWindow()
    
    // MARK: - init & deinit
    
    private init() {}
    
    // MARK: - private methods
    
    private func configureApplication() {
        
        Fabric.with([Crashlytics.self])
        
        GMSServices.provideAPIKey("API_KEY")
        GMSPlacesClient.provideAPIKey("API_KEY")
        
        fire.setup()
    }
    
    private func call(_ number: String) {
        let sanatized = number.components(separatedBy: " ")[0]
        UIApplication.shared.openURL(URL(string: "tel://\(sanatized)")!)
    }
    
    // MARK: - public methods
    
    func setup(window: UIWindow, launchOptions: [UIApplicationLaunchOptionsKey:Any]) {
        
        configureApplication()
        
        self.window = window
        window.tintColor = tint
    }
    
    // MARK: - global actions
    
    func generateDeeplink(_ item: Shareable) -> String {
        
        let link = item.pathComponents
            .reduce(URL(string: "https://nv28q.app.goo.gl")!) { $0.appendingPathComponent($1) }
        
        return "https://nv28q.app.goo.gl/"
        + "?link=\(link.absoluteString)"
        + "&apn=com.themakersdirectory"
        + "&ibi=com.themakersdirectory.ios"
        + "&isi=1171329399"
    }
    
    func openURL(_ url: URL) {
        UIApplication.shared.openURL(url)
    }
    
    func call(_ numbers: [String]) {
        if numbers.count == 1 {
            call(numbers[0])
        } else {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            numbers.forEach {
                alert.addAction(UIAlertAction(title: $0, style: .default, handler: { action in
                    self.call(action.title!)
                }))
            }
            alert.addAction(UIAlertAction(title: NSLocalizedString("ALERT_BTN_CANCEL", comment: ""), style: .cancel))
            
            window.rootViewController!.present(alert, animated: true, completion: nil)
        }
    }
    
    func showMap(_ coord: Coordinates) {
        
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coord.asCLCoordinates, addressDictionary: nil))
        mapItem.openInMaps(launchOptions: nil)
    }
}
