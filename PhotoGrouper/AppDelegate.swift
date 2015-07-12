//
//  AppDelegate.swift
//  PhotoGrouper
//
//  Created by Elex Lee on 7/9/15.
//  Copyright (c) 2015 Elex Lee. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var root: UINavigationController?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: UIScreen.mainScreen().bounds.width , height: UIScreen.mainScreen().bounds.height))
        self.window = UIWindow(frame: rect)
        
        let numberOfTableViewRows: NSInteger = 100
        let numberOfCollectionViewCells: NSInteger = 1
        
        var stringArray = NSMutableArray(capacity: numberOfCollectionViewCells)
        for var tableViewRow = 0; tableViewRow < numberOfTableViewRows; ++tableViewRow {
            var tempArray: NSMutableArray = NSMutableArray(capacity: numberOfCollectionViewCells)
            stringArray.addObject(tempArray)
        }
        
        let viewController = PhotoTableViewController(source: stringArray)
        viewController.title = "PhotoGrouper"
        self.root = UINavigationController(rootViewController: viewController)
        self.window?.rootViewController = self.root
        self.window?.makeKeyAndVisible()
        return true
    }
    
    func prefersStatusBarHidden() -> Bool {
        return true;
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
    
    
}

