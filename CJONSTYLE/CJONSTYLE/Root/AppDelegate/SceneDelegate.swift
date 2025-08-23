//
//  SceneDelegate.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/23/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var rootRoutable: LaunchRoutable?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        self.window = UIWindow(windowScene: windowScene)
        
        if let component = appDelegate.rootComponent {
            let rootRoutable = RootRouter(component: component, view: window!)
            self.rootRoutable = rootRoutable
            rootRoutable.launchStart(path: .splash)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

