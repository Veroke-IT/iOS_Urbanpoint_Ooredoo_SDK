//
//  AppDelegate.swift
//  OredooMoneyApp
//
//  Created by MamooN_ on 3/9/23.
//

import UIKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
       return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}

//    func applicationDidEnterBackground(_ application: UIApplication) {
//
//    }
//
//    func applicationDidBecomeActive(_ application: UIApplication) {
//
//    }
//
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
//
//    }
//
//    func applicationDidFinishLaunching(_ application: UIApplication) {
//
//    }
    
}

