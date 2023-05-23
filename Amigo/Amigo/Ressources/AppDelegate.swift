//
//  AppDelegate.swift
//  Amigo
//
//  Created by Mickaël Horn on 11/04/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Starting Firebase.
        FirebaseApp.configure()
        
        #if DEBUG
        // By utilizing the #if DEBUG, we ensure that the following code is not executed during the build process, but exclusively during testing.
        if ProcessInfo.processInfo.environment["unit_tests"] == "true" {
            print("""
            
                ********************************************************
                      Setting up Firebase emulator localhost:8080
                ********************************************************
            
            """
            )
            Auth.auth().useEmulator(withHost: "localhost", port: 9099)
            let settings = Firestore.firestore().settings
            settings.host = "localhost:8080"
            settings.isPersistenceEnabled = false
            settings.isSSLEnabled = false
            Firestore.firestore().settings = settings
        }
        #endif

        return true
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

