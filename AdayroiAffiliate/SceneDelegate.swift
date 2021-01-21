//
//  SceneDelegate.swift
//  AdayroiAffiliate
//
//  Created by Mitesh's MAC on 04/06/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        if UserDefaults.standard.value(forKey: UD_isTutorial) == nil || UserDefaults.standard.value(forKey: UD_isTutorial) as! String == "" || UserDefaults.standard.value(forKey: UD_isTutorial) as! String == "N/A" {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let objVC = storyBoard.instantiateViewController(withIdentifier: "TutorialVC") as! TutorialVC
            let nav : UINavigationController = UINavigationController(rootViewController: objVC)
            nav.navigationBar.isHidden = true
            self.window?.rootViewController = nav
        }
        else {
            if UserDefaults.standard.value(forKey: UD_userId) == nil || UserDefaults.standard.value(forKey: UD_userId) as! String == "" || UserDefaults.standard.value(forKey: UD_userId) as! String == "N/A" || UserDefaults.standard.value(forKey: UD_userId) as! String == ""{
                let storyBoard = UIStoryboard(name: "User", bundle: nil)
                let objVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                let nav : UINavigationController = UINavigationController(rootViewController: objVC)
                nav.navigationBar.isHidden = true
                self.window?.rootViewController = nav
            }
            else {
                if UserDefaultManager.getStringFromUserDefaults(key: UD_isSelectLng) == "en" || UserDefaultManager.getStringFromUserDefaults(key: UD_isSelectLng) == "" || UserDefaultManager.getStringFromUserDefaults(key: UD_isSelectLng) == "N/A"
                {
                    let storyBoard = UIStoryboard(name: "Home", bundle: nil)
                    let objVC = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    let sideMenuViewController = storyBoard.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
                    let appNavigation: UINavigationController = UINavigationController(rootViewController: objVC)
                    appNavigation.setNavigationBarHidden(true, animated: true)
                    let slideMenuController = SlideMenuController(mainViewController: appNavigation, leftMenuViewController: sideMenuViewController)
                    slideMenuController.changeLeftViewWidth(UIScreen.main.bounds.width * 0.8)
                    slideMenuController.removeLeftGestures()
                    self.window?.rootViewController = slideMenuController
                }
                else 
                {
                    let storyBoard = UIStoryboard(name: "Home", bundle: nil)
                    let objVC = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    let sideMenuViewController = storyBoard.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
                    let appNavigation: UINavigationController = UINavigationController(rootViewController: objVC)
                    appNavigation.setNavigationBarHidden(true, animated: true)
                    let slideMenuController = SlideMenuController(mainViewController: appNavigation, rightMenuViewController: sideMenuViewController)
                    slideMenuController.changeRightViewWidth(UIScreen.main.bounds.width * 0.8)
                    slideMenuController.removeRightGestures()
                    self.window?.rootViewController = slideMenuController
                }
                
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
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
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
}

