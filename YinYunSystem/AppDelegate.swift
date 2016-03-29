//
//  AppDelegate.swift
//  YinYunSystem
//
//  Created by 魏辉 on 16/1/12.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, BMKGeneralDelegate {

    var window: UIWindow?
    var mapManager: BMKMapManager?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
//        UITabBar.appearance().backgroundColor = UIColor(red: 0.0/255.0, green:
//            122.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.0/255.0, green:
            122.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        if let barFont = UIFont(name: "Avenir-Light", size: 18.0) {
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: barFont]
        }
        
        mapManager = BMKMapManager()
        let ret = mapManager?.start("CNqd149MwFZN4MEGSvNs7cYo", generalDelegate: self)
        if ret! == false {
            print("出现错误")
        } else {
            print("hahha")
        }
        
        //网络管理
        checkConnect()
        return true
    }
    
    func checkConnect()
    {
//        let reachability  = Reachability.reachabilityForInternetConnection()
//        //判断连接状态
//        if reachability!.isReachable(){
////           = "网络连接：可用"
//        }else{
////             "网络连接：不可用"
//        }
//        
//        //判断连接类型
//        if reachability!.isReachableViaWiFi() {
////            "连接类型：WiFi"
//        }else if reachability!.isReachableViaWWAN() {
////             "连接类型：移动网络"
//        }else {
////            "连接类型：没有网络连接"
//        }
    }
    
    func getCookie()->String
    {
        let cookie = NSUserDefaults.standardUserDefaults().valueForKey("cookie") as! String
        return cookie
    }
    func getUserName()->String
    {
        let user = NSUserDefaults.standardUserDefaults().valueForKey("user") as! String
        return user
    }
    func getPassword()->String
    {
        let pwd = NSUserDefaults.standardUserDefaults().valueForKey("pwd") as! String
        return pwd
    }
//    internal func getService()->String
//    {
////        let pwd = "http://172.16.8.109"
//        let pwd = "http://172.16.8.250:8085"
//        return pwd
//    }
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

