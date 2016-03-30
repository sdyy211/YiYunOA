//
//  downLoadFile.swift
//  YinYunSystem
//
//  Created by Mac on 16/3/30.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class downLoadFile: UIView{

    var url = ""
    var name = ""
    var lab = UILabel()
    var topView = UIView()
    var progress = UIImageView()
    var cusView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.orangeColor()
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
    
    override func drawRect(rect: CGRect) {
//        progress = UIProgressView(frame: CGRectMake(0,100,300,20))
//        progress.progressViewStyle.rawValue

        cusView = UIView(frame: CGRectMake(10,(CGRectGetHeight(UIScreen.mainScreen().bounds)-100)/2,CGRectGetWidth(UIScreen.mainScreen().bounds)-20,100))
        cusView.backgroundColor = UIColor.whiteColor()
        cusView.layer.cornerRadius = 50
        cusView.layer.borderWidth = 1
        cusView.layer.borderColor = UIColor.brownColor().CGColor
        self.addSubview(cusView)
        
        progress = UIImageView(frame: CGRectMake(10,(CGRectGetHeight(cusView.frame)-10)/2, 5, 10))
        progress.image = UIImage(named: "progress")
        cusView.addSubview(progress)
        loadData()
    }
    func loadData()
    {
        print(url)
        let destination = Request.suggestedDownloadDestination(
            directory: .DocumentDirectory, domain: .UserDomainMask)
        
        download(.GET, url, destination: destination)
            .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
                
                let percent = totalBytesRead*100/totalBytesExpectedToRead
//                self.progress.setProgress(float_t(percent), animated: true)
                let with = CGRectGetWidth(self.cusView.frame)-20
                self.progress.frame.size.width = with * CGFloat(percent);
                print("已下载：\(totalBytesRead)  当前进度：\(percent)%")
            }
            .response { (request, response, _, error) in
                print(response)
        }
        
    }
    func btnAction(button:UIButton)
    {
        self.removeFromSuperview()
    }
}
