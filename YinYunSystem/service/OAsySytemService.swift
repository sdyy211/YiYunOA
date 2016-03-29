//
//  OAsySytemService.swift
//  YinYunSystem
//
//  Created by Mac on 16/2/18.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class OAsySytemService:NSObject{
    
    var loginUrl = "/Login/JDoLogin"
    var timer = NSTimer()
    var request = HttpRequest()
    class var sharedInstance : OAsySytemService {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : OAsySytemService? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = OAsySytemService()
        }
        return Static.instance!
    }

    //开始服务器
    func startService()
    {
         timer =  NSTimer.scheduledTimerWithTimeInterval(600, target: self, selector: "timerFireMethod:", userInfo: nil, repeats: true)
    }
    //关闭服务器
    func endService()
    {
        timer.invalidate()
    }
    func timerFireMethod(t: NSTimer) {
        
        print("正在进行服务")
        
        let bodyStr = NSString(format: "uname=\(NSUserDefaults.standardUserDefaults().objectForKey("user"))&upwd=\(NSUserDefaults.standardUserDefaults().objectForKey("pwd"))")
        let str = GetService + loginUrl
        request.Post(str, str: bodyStr as String)
    }
}
