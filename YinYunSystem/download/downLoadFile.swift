//
//  downLoadFile.swift
//  YinYunSystem
//
//  Created by Mac on 16/3/30.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
@objc protocol downLoadProtocol{
    func openDownLoadFile(name:String)
}

class downLoadFile: UIView{

    var url = ""
    var name = ""
    var lab = UILabel()
    var topView = UIView()
    var progressV = UIProgressView()
    
    var cusView = UIView()
    var VC = UIViewController()
    var delegate:downLoadProtocol?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.orangeColor()
        topView = UIView()
        topView.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen().bounds),60)
        topView.backgroundColor = UIColor.blackColor()
//        self.addSubview(topView)
        
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

        progressV = UIProgressView(progressViewStyle: UIProgressViewStyle.Default)
        progressV.frame = CGRectMake(0, 300,CGRectGetWidth(self.frame),10)
        self.addSubview(progressV)
        
    }
        required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func drawRect(rect: CGRect) {
        lab.text = name
        loadData()
    }
    func loadData()
    {
        let destination = Request.suggestedDownloadDestination(
            directory: .DocumentDirectory, domain: .UserDomainMask)
        
        download(.GET, url, destination: destination)
            .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
                
                
                let percent = Float(totalBytesRead)/Float(totalBytesExpectedToRead)
                //进度条更新
                dispatch_async(dispatch_get_main_queue(), {
                    self.progressV.setProgress(percent,animated:true)
                })
            }
            .response { (request, response, _, error) in
            
                    self.alter("提示！", message: "下载成功，是否要打开")
    
        }
        
    }
    func btnAction(button:UIButton)
    {
        self.removeFromSuperview()
    }
    func alter(title:String,message:String)
    {
        let alertView =  UIAlertController.init(title:title, message:message, preferredStyle: UIAlertControllerStyle.Alert)
        let alertViewCancelAction: UIAlertAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
            self.removeFromSuperview()
        }
        alertView.addAction(alertViewCancelAction)
        
        let alertViewCancelAction2: UIAlertAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.removeFromSuperview()
            self.delegate?.openDownLoadFile(self.name)
        }
        alertView.addAction(alertViewCancelAction2)
        VC.presentViewController(alertView, animated:true , completion: nil)
    }
}
