//
//  loadingAnimationMethod.swift
//  YinYunSystem
//
//  Created by Mac on 16/2/25.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class loadingAnimationMethod: NSObject {
    var loadingView = loadingAnimationView()
    class var sharedInstance : loadingAnimationMethod {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : loadingAnimationMethod? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = loadingAnimationMethod()
        }
        return Static.instance!
    }
    func startAnimation()
    {
        loadingView = loadingAnimationView(frame: CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen().bounds), CGRectGetHeight(UIScreen.mainScreen().bounds)))
        
        loadingView.backgroundColor = UIColor(red:0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.6)
        let window = UIApplication.sharedApplication().keyWindow
        window?.addSubview(loadingView)
        
        loadingView.startAnimation()
    }
    func endAnimation()
    {
        loadingView.endAnimation()
        loadingView.removeFromSuperview()
    }

}
