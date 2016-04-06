//
//  openDownloadFile.swift
//  YinYunSystem
//
//  Created by Mac on 16/3/31.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class openDownloadFile: UIView {

    
    var web = UIWebView()
    var topView = UIView()
    var path = ""
    var name = ""
    var lab = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        topView = UIView()
        
        topView = UIView()
        topView.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen().bounds),60)
        topView.backgroundColor = UIColor.blackColor()
        self.addSubview(topView)
        
        let btn = UIButton()
        btn.frame =  CGRectMake(CGRectGetWidth(UIScreen.mainScreen().bounds)-50, 25,50,30)
        btn.setTitle("关闭", forState: UIControlState.Normal)
        btn.addTarget(self, action: Selector("btnAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        topView.addSubview(btn)
        
        lab = UILabel()
        lab.frame = CGRectMake(CGRectGetWidth(btn.frame), 25, CGRectGetWidth(UIScreen.mainScreen().bounds)-2*CGRectGetWidth(btn.frame),30)
        lab.textAlignment = NSTextAlignment.Center
        lab.textColor = UIColor.whiteColor()
        topView.addSubview(lab)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func btnAction(button:UIButton)
    {
        self.removeFromSuperview()
    }
    override func drawRect(rect: CGRect) {
        
        
        web = UIWebView()
        web.frame = CGRectMake(0,CGRectGetMaxY(topView.frame),CGRectGetWidth(UIScreen.mainScreen().bounds), CGRectGetHeight(UIScreen.mainScreen().bounds)-CGRectGetHeight(topView.frame))
        web.sizeToFit()
        self.addSubview(web)
        
        path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        
        let fileManager = NSFileManager()
        let arry: NSArray = try! fileManager.contentsOfDirectoryAtPath(path)
        for filename in arry
        {
            if(filename as! String == name)
            {
                lab.text = name
                let url = NSURL(fileURLWithPath: path + "/" + name)
                web.loadRequest(NSURLRequest(URL: url))
            }
        }
       
        
    }


}
