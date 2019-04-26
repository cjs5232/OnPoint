//
//  AppDelegate.swift
//  Mom
//
//  Created by Aidan Barr Bono (student LM) on 1/3/19.
//  Copyright © 2019 Duck Inc. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { granted, error in
                // handle error, or granted is false do something
            if granted {
                
            }
            })
        
        Notifications.createOptions()
        
        UserDefaults.standard.register(defaults: ["DarkTheme": false, "snoozeTime": 5, "reminderTimeBefore": [0, 15]])
        
        let navigationBarAppearance = UINavigationBar.appearance()
        let tabBarAppearance = UITabBar.appearance()
        
        //  must add code to keep dark theme if the setting is there
        if UserDefaults.standard.bool(forKey: "DarkTheme") {
            // must add more general changes to colors
            // could make a protocol that all view controllers implement
            //      all this would require from the VC would be a list of all the elements that would need colors changed
            //      possibly seperate lists for text elements, button elements, general stuff...
            //      loop through the list a set the colors to be something in the dark theme
            // this would be a lot of work and a lot of outlets, but thats what we pay for making an app with a storyboard...
            // that also DID NOT WORK because i tried to access labels in view controllers before they were created so it looks like
            // we are going to do it all in each individual view did load
            // still might want to use a protocol somehow
            navigationBarAppearance.barTintColor = UIColor.myPurple
            tabBarAppearance.barTintColor = UIColor.myPurple
            
        } else {
            navigationBarAppearance.barTintColor = UIColor.myPurple
            tabBarAppearance.barTintColor = UIColor.myPurple
        }
        
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
    }


}

