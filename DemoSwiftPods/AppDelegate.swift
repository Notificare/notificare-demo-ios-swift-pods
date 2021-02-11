//
//  AppDelegate.swift
//  DemoSwiftPods
//
//  Created by Joel Oliveira on 11/02/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, NotificarePushLibDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        NotificarePushLib.shared().initialize(withKey: nil, andSecret: nil)
        NotificarePushLib.shared().delegate = self
        NotificarePushLib.shared().launch()
        NotificarePushLib.shared().didFinishLaunching(options: launchOptions);
        
        if #available(iOS 10.0, *) {
            NotificarePushLib.shared().presentationOptions = .banner
        }
        
        return true
    }
    
    func notificarePushLib(_ library: NotificarePushLib, onReady application: NotificareApplication) {
    
        NotificarePushLib.shared().registerForNotifications()

    }
    
    func notificarePushLib(_ library: NotificarePushLib, didRegister device: NotificareDevice) {
        print(device.deviceID)
        
//        NotificarePushLib.shared().addTag("tag_swift", completionHandler: {(_ response: Any?, _ error: Error?) -> Void in
//            if error == nil {
//                //Tag added
//            }
//        })
//
//        if (NotificarePushLib.shared().locationServicesEnabled()) {
//            NotificarePushLib.shared().startLocationUpdates()
//        }
        
        
    }
    
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        NotificarePushLib.shared().continue(userActivity, restorationHandler: restorationHandler);
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        NotificarePushLib.shared().handleOpen(url, withOptions: options)
        print(url)
        return true;
    }
    
    func notificarePushLib(_ library: NotificarePushLib, didReceiveLocationServiceAuthorizationStatus status: NotificareGeoAuthorizationStatus) {
        
        if (NotificareGeoAuthorizationStatusAuthorizedAlways != status) {
            
        }
    }
    
    func notificarePushLib(_ library: NotificarePushLib, didReceiveLocationServiceAccuracyAuthorization accuracy: NotificareGeoAccuracyAuthorization) {
        
        if (NotificareGeoAccuracyAuthorizationFull != accuracy) {
            
        }
        
        if (NotificarePushLib.shared().myDevice().locationServicesAuthStatus == "always" ||
            NotificarePushLib.shared().myDevice().locationServicesAccuracyAuth != "full") {
            
        }
    }
    
    func notificarePushLib(_ library: NotificarePushLib, didReceiveRemoteNotificationInBackground notification: NotificareNotification, withController controller: Any?) {

        guard let navigationController = self.findNavigationViewController() else { return }

        NotificarePushLib.shared().present(notification, in: navigationController , withController: controller as Any)
    }
    
    private func findNavigationViewController(from controller: UIViewController? = nil) -> UINavigationController? {
        guard let controller = controller else {
            let keyWindows = UIApplication.shared.windows.filter { $0.isKeyWindow }
            guard let window = keyWindows.first, let controller = window.rootViewController else {
                return nil
            }

            return findNavigationViewController(from: controller)
        }

        switch controller {
        case let split as UISplitViewController:
            guard let last = split.viewControllers.last else { return nil }
            return findNavigationViewController(from: last)
        case let navigation as UINavigationController:
            return navigation
        default:
            return nil
        }
    }
    
    func notificarePushLib(_ library: NotificarePushLib, didReceiveRemoteNotificationInForeground notification: NotificareNotification, withController controller: Any?) {
        print("didReceiveRemoteNotificationInForeground")
    }
    
    
    func notificarePushLib(_ library: NotificarePushLib, shouldOpenSettings notification: NotificareNotification?) {
        print("shouldOpenSettings")
    }
    
    
    func notificarePushLib(_ library: NotificarePushLib, didLoadInbox items: [NotificareDeviceInbox]) {
        print("didLoadInbox")
    }
    
    func notificarePushLib(_ library: NotificarePushLib, didUpdateBadge badge: Int32) {
        print(badge)
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        NotificarePushLib.shared().didRegisterForRemoteNotifications(withDeviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //Handle Error
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        NotificarePushLib.shared().didReceiveRemoteNotification(userInfo, completionHandler: {(_ response: Any?, _ error: Error?) -> Void in
            if error == nil {
                completionHandler(.newData)
            } else {
                completionHandler(.noData)
            }
        })
    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

