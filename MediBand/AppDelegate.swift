//
//  AppDelegate.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/5/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let settings = NSUserDefaults.standardUserDefaults()
        if let themeColor = settings.colorForKey("themeColor") {
            sharedDataSingleton.theme = themeColor
        }else {
           sharedDataSingleton.theme = UIColor(red: 0.16, green: 0.89, blue: 0.98, alpha: 1.0)
        }
//        if let userSelectedColorData = settings.objectForKey("themeColor") as? NSData {
//            if let userSelectedColor = NSKeyedUnarchiver.unarchiveObjectWithData(userSelectedColorData) as? UIColor {
//                print(userSelectedColor)
//                sharedDataSingleton.theme = userSelectedColor
//            }
//        }else {
//            sharedDataSingleton.theme = UIColor(red: 0.16, green: 0.89, blue: 0.98, alpha: 1.0)
//        }
        UINavigationBar.appearance().barTintColor = sharedDataSingleton.theme
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
        gai.logger.logLevel = GAILogLevel.Verbose  // remove before app release
        var tracker:GAITracker = GAI.sharedInstance().trackerWithTrackingId("UA-65859570-1")
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
//    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
//        
//        return checkOrientation(self.window?.rootViewController)// This is the custom function that u need to set your custom view to each orientation which u want to lock
//        
//    }
    
    func checkOrientation(viewController:UIViewController?)-> Int{
        
        if(viewController == nil){
            
            return Int(UIInterfaceOrientationMask.All.rawValue)//All means all orientation
            
        }else if (viewController is NewTaskViewController){
            
            return Int(UIInterfaceOrientationMask.Portrait.rawValue)//This is sign in view controller that i only want to set this to portrait mode only
            
        }else{
            
            return checkOrientation(viewController!.presentedViewController)
        }
    }


}

