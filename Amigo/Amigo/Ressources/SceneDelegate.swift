//
//  SceneDelegate.swift
//  Amigo
//
//  Created by Mickaël Horn on 11/04/2023.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    weak var handle: AuthStateDidChangeListenerHandle?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        //try? Auth.auth().signOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        
        handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if ((user) != nil) {
                // If the user is logged in, the UITabBar which contains all his personal screens become the new RootViewController, fot cleaner navigation.
                let customTabBarController = storyboard.instantiateViewController(withIdentifier: "CustomTabBarController") as! CustomTabBarController
                self?.window?.rootViewController = customTabBarController
                
            } else {
                // Otherwise, if he disconnect, then we go back to the WelcomeVC.
                let welcomeVC = storyboard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                self?.window?.rootViewController = welcomeVC
            }
        }
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
