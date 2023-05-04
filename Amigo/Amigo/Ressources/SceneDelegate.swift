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
    
    /*func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
     print("MKA - Listener va démarrer")
     handle = Auth.auth().addStateDidChangeListener { (_, user) in
     if ((user) != nil) {
     UserService.shared.currentlyLoggedIn = true
     print("MKA - currentlyLoggedIn est à true")
     } else {
     UserService.shared.currentlyLoggedIn = false
     }
     }
     }*/

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let theme = UserDefaults.standard.integer(forKey: "theme")
        
        switch theme {
        case 0:
            window?.overrideUserInterfaceStyle = .unspecified
        case 1:
            window?.overrideUserInterfaceStyle = .light
        case 2:
            window?.overrideUserInterfaceStyle = .dark
        default:
            window?.overrideUserInterfaceStyle = .unspecified
        }
    }
    
    /*func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
     // Version avec fetchUser()
     guard let windowScene = (scene as? UIWindowScene) else { return }
     window = UIWindow(windowScene: windowScene)
     let storyboard = UIStoryboard(name: "Main", bundle: nil)
     
     // Ce listener est déclenché dès qu'un changement d'authentification a lieu (il est également lancé au démarrage de l'app s'il y a un utilisateur qui était précédement authentifié.
     handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
     
     // Si un user est trouvé
     if ((user) != nil) {
     
     // On va chercher notre utilisateur
     FirebaseManager().fetchUser { user in
     guard let user = user else { return }
     
     // Comme on a un utilisateur, on définit notre UITabBar en tant que rootViewController
     // On lui transmet également l'user, afin qu'il le transmette lui-même aux différents onglets
     let customTabBarController = storyboard.instantiateViewController(withIdentifier: "CustomTabBarController") as! CustomTabBarController
     customTabBarController.user = user
     self?.window?.rootViewController = customTabBarController
     self?.window?.makeKeyAndVisible()
     }
     } else {
     // S'il n'y a pas d'user, alors on revient au début, sur l'écran login/mdp
     let welcomeNC = storyboard.instantiateViewController(withIdentifier: "WelcomeNavigationController")
     self?.window?.rootViewController = welcomeNC
     self?.window?.makeKeyAndVisible()
     }
     }
     }*/
    
    /*func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Version sans fetchUser()
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window?.windowScene =  windowScene
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if ((user) != nil) {
                
                // If the user is logged in, the UITabBar which contains all his personal screens become the new RootViewController, fot cleaner navigation.
                UserService.shared.currentlyLoggedIn = true
                let MainTabBar = storyboard.instantiateViewController(withIdentifier: "MainTabBar")
                self?.window?.rootViewController = MainTabBar
                self?.window?.makeKeyAndVisible()
                
            } else {
                // Otherwise, if he disconnect, then we go back to the WelcomeVC.
                let welcomeNC = storyboard.instantiateViewController(withIdentifier: "WelcomeNavigationController")
                self?.window?.rootViewController = welcomeNC
                self?.window?.makeKeyAndVisible()
            }
        }
    }*/
    
    /*func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
     // Version qui mène sur AuthStateVC
     guard let windowScene = (scene as? UIWindowScene) else { return }
     window = UIWindow(windowScene: windowScene)
     let storyboard = UIStoryboard(name: "Main", bundle: nil)
     
     // Ce listener est déclenché dès qu'un changement d'authentification a lieu (il est également lancé au démarrage de l'app s'il y a un utilisateur qui était précédement authentifié.
     handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
     
     // Si un user est trouvé
     if ((user) != nil) {
     
     // If the user is logged in, we can go and fetch the user's informations inside AuthStateVC
     let authStateVC = storyboard.instantiateViewController(withIdentifier: "AuthStateVC") as! AuthStateVC
     self?.window?.rootViewController = authStateVC
     self?.window?.makeKeyAndVisible()
     
     } else {
     
     // Otherwise, if he disconnect, then we go back to the WelcomeVC.
     let welcomeNC = storyboard.instantiateViewController(withIdentifier: "WelcomeNavigationController")
     self?.window?.rootViewController = welcomeNC
     self?.window?.makeKeyAndVisible()
     }
     }
     }*/
    
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
// If the user is logged in, the UITabBar which contains all his personal screens become the new RootViewController, fot cleaner navigation.
