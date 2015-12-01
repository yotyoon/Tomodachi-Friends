//
//  AppDelegate.swift
//  TOMODACHI
//
//  Created by Yot Yoon Toh on 10/20/15.
//  Copyright © 2015 Yot Yoon Toh. All rights reserved.
//

import UIKit
import Parse
import Bolts
import AudioToolbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //Parse.enableLocalDatastore()
        
        //Initialize Parse
        Parse.setApplicationId("jsShjEqeesnlFSVJkV78YnskxsuhcnTzmlaLgQue", clientKey: "wqphbRdOmYiHjn3MksUENmyfUSBfIRlyUyKOKVCy")
        
         PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        let settings = UIUserNotificationSettings(forTypes: UIUserNotificationType([.Alert, .Badge, .Sound]), categories: nil)
       
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()

        //PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        if PFUser.currentUser() != nil {
            buildUserInterface()
        }
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData){
        //store the deviceToken in the current Installation and save it to Parse
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        //installation.addUniqueObject("ALL", forKey: "channels")
        //installation.addUniqueObject("US", forKey: "channels")
        //installation.addUniqueObject("JP", forKey: "channels")
       // installation.addUniqueObject("Tohoku", forKey: "channels")
        installation.saveInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
            print("Registration successful? \(success)")
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register \(error.localizedDescription)")
    }
    
    func application(application: UIApplication,  didReceiveRemoteNotification userInfo: [NSObject : AnyObject],  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        //PFPush.handlePush(userInfo)
        
        AudioServicesPlayAlertSound(1110)
        NSNotificationCenter.defaultCenter().postNotificationName("displayMessage", object: userInfo)
        NSNotificationCenter.defaultCenter().postNotificationName("reloadMessages", object: nil)
        
        completionHandler(UIBackgroundFetchResult.NewData)
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
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
         FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func buildUserInterface()
    {
        let userName:String? = NSUserDefaults().stringForKey("username")
        
        if (userName == nil)
        {
            //Navigate to Sign in Page
            let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let signInPage:SignInViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("SignInViewController") as! SignInViewController
            
            let signInPageNav = UINavigationController(rootViewController: signInPage)
            
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.window?.rootViewController = signInPageNav
            
        }
        
    }


}

