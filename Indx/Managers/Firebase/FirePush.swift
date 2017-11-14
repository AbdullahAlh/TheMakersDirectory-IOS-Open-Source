//
//  FirePush.swift
//  Indx
//
//  Created by abdullah alhussainan on 1/7/17.
//  Copyright © 2017 level3. All rights reserved.
//

import Foundation
import UserNotifications
import FirebaseMessaging
import UIKit

final class FirebPush: NSObject, FIRMessagingDelegate, UNUserNotificationCenterDelegate {
    
    // MARK: - public methods
    
    func setup() {
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    public func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        
    }
}
