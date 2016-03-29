//
//  loadingAnimationView.swift
//  YinYunSystem
//
//  Created by Mac on 16/2/25.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class loadingAnimationView: UIView {

    var myImage = UIImageView()
    var activityView = UIActivityIndicatorView()
    var timer = NSTimer()
    var flag = 1
    var imageWith:CGFloat = 60
    var imageHeight:CGFloat = 60
    var loadViewHeight:CGFloat = 150 - 20
    var loadViewWith:CGFloat = 110
    var loadView = UIView()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        loadView = UIView()
        loadView.frame = CGRectMake((CGRectGetWidth(UIScreen.mainScreen().bounds) - loadViewWith)/2, (CGRectGetHeight(UIScreen.mainScreen().bounds) - loadViewHeight)/2, loadViewWith, loadViewHeight)
        loadView.layer.borderWidth = 1
        loadView.layer.borderColor = UIColor.whiteColor().CGColor
        loadView.layer.cornerRadius = 10
        loadView.backgroundColor =  UIColor(red:0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.2)
        self.addSubview(loadView)
        
        myImage = UIImageView()
        myImage.frame = CGRectMake((CGRectGetWidth(loadView.frame)-imageWith)/2,10, imageWith, imageHeight)
        loadView.addSubview(myImage)
        
        let lab = UILabel()
        lab.frame = CGRectMake(0, CGRectGetMaxY(myImage.frame)+10,CGRectGetWidth(loadView.frame),20)
        lab.text = "努力加载中...."
        lab.font = UIFont.systemFontOfSize(15.0)
        lab.textAlignment = NSTextAlignment.Center
        lab.textColor = UIColor.whiteColor()
        
        loadView.addSubview(lab)
        
//        activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
//        activityView.frame = CGRectMake((CGRectGetWidth(loadView.frame) - 20)/2, CGRectGetMaxY(lab.frame)+15, 20, 20)
//        
//        loadView.addSubview(activityView)
        
    }
    
    override func drawRect(rect: CGRect) {
        
        
    }
    func timerFireMethod(t: NSTimer) {
        
        if(flag >= 1 && flag <= 8)
        {
            let str = "loading\(flag)"
            myImage.image = UIImage(named: str)
            flag = flag + 1
            if(flag == 8)
            {
                flag = 1
            }
        }
//        activityView.startAnimating()
    }
    func startAnimation()
    {        
        timer =  NSTimer.scheduledTimerWithTimeInterval(0.08, target: self, selector: "timerFireMethod:", userInfo: nil, repeats: true)
    }

    func endAnimation()
    {
        timer.invalidate()
//        activityView.stopAnimating()
    }

}
