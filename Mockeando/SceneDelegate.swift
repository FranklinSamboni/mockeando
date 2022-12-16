//
//  SceneDelegate.swift
//  Mockeando
//
//  Created by Franklin Samboni on 15/12/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        
        let rootViewController = UIViewController()
        rootViewController.view.backgroundColor = .blue
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }

}

