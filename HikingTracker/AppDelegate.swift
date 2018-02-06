//  AppDelegate.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/4/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit
import CoreData
import WatchConnectivity
import Firebase
import FirebaseAuthUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    override init() {
        super.init()
        FirebaseApp.configure()
        let databaseRef = Database.database()
        databaseRef.isPersistenceEnabled = true
    }
    var window: UIWindow?
    
    let navigationBarDefaultFont = UIFont(name: "Cabin", size: 24)
    let barButtonDefaultFont = UIFont(name: "Cabin", size: 14)
    let defaultBlack = DefaultUI().defaultBlack
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.


        
        setNavigationBarTitleAttributes()
        


        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.barTintColor = DefaultUI().navBarBackgroundColor
        navigationBarAppearace.tintColor = UIColor.white
        
//        UIApplication.shared.statusBarStyle = .lightContent


        setTabBarAppearanceAttributes()

        checkForUserInfoAndPresentCorrectScreen()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }

    func checkForUserInfoAndPresentCorrectScreen() {
        if !userSettingsSet {
            if loggedIn {
                do {
                    try Auth.auth().signOut()
                } catch {
                    print("problems signing user out")
                }
            }
            displayOnboardingScreen()
            return
        } else {
            displayMainHikeScreen()
        }
    }

    func displayOnboardingScreen() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let userVC = storyBoard.instantiateViewController(withIdentifier: "OnboardInitialVC") as! OnboardingFirstViewController
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = userVC
        self.window?.makeKeyAndVisible()
    }

    func displayUserSettingsScreenOnly() {

        let storyBoard = UIStoryboard(name: "Settings:User", bundle: nil)
        let userVC = storyBoard.instantiateViewController(withIdentifier: "UserSettings") as! EditUserInfoViewController
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = userVC
        self.window?.makeKeyAndVisible()

    }

    func displayLogInScreenOnly() {

    }

    func displayMainHikeScreen() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let userVC = storyBoard.instantiateViewController(withIdentifier: "MainTabBar") as! UITabBarController
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = userVC
        self.window?.makeKeyAndVisible()
    }

    
    var userSettingsSet: Bool {
        print(StoredUser().name)
        if StoredUser().name == nil {
            return false
        } else {
            return true
        }
    }

    var loggedIn: Bool {
        if let currentUser = Auth.auth().currentUser {
            return true
        } else {
            return false
        }
    }
    
    //Appearance Functions
    fileprivate func setNavigationBarTitleAttributes() {
    
        let navigationTitleAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: navigationBarDefaultFont!
        ]
        UINavigationBar.appearance().titleTextAttributes = navigationTitleAttributes
        
        let barButtonAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: barButtonDefaultFont!
        ]
        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributes, for: UIControlState.normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributes, for: UIControlState.focused)
        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributes, for: UIControlState.selected)
        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributes, for: UIControlState.highlighted)
    }
    
    
    private func setTabBarAppearanceAttributes() {
        let appearance = UITabBarItem.appearance()
        appearance.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Cabin", size: 10)!], for: .normal)
//        let attributes = [NSAttributedStringKey.font: UIFont ]
//        appearance.setTitleTextAttributes(attributes, for: .normal)
        
        UITabBar.appearance().tintColor = DefaultUI().navBarBackgroundColor
    }
    
    // MARK: Firebase Auth Delegate






}
