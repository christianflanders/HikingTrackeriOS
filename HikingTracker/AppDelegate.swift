//  AppDelegate.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/4/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit
import CoreData
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    
    let navigationBarDefaultFont = UIFont(name: "Futura-Medium", size: 24)
    let barButtonDefaultFont = UIFont(name: "Futura-Medium", size: 14)
    let defaultBlack = DefaultUI().defaultBlack
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        setNavigationBarTitleAttributes()
        
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
        PersistanceService.store.saveContext()
    }

    func checkForUserInfoAndPresentCorrectScreen() {
        let myUser = StoredUser()
        let userWeight = myUser.weightInKilos
        if userWeight == nil  || userWeight == 0 {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) // this assumes your storyboard is titled "Main.storyboard"
            let yourVC = mainStoryboard.instantiateViewController(withIdentifier: "User Info") as! EditUserInfoViewController
            appDelegate.window?.rootViewController = yourVC
            appDelegate.window?.makeKeyAndVisible()
        }
    }
    
    //Appearance Functions
    fileprivate func setNavigationBarTitleAttributes() {
    
        let navigationTitleAttributes = [
            NSAttributedStringKey.foregroundColor: defaultBlack,
            NSAttributedStringKey.font: navigationBarDefaultFont!
        ]
        UINavigationBar.appearance().titleTextAttributes = navigationTitleAttributes
        
        let barButtonAttributes = [
            NSAttributedStringKey.foregroundColor: defaultBlack,
            NSAttributedStringKey.font: barButtonDefaultFont!
        ]
        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributes, for: UIControlState.normal)
    }

}
