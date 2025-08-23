//
//  AppDelegate.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/23/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var rootComponent: RootComponent?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.rootComponent = RootComponent()
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

