//
//  showImageView.swift
//  YinYunSystem
//
//  Created by Mac on 16/3/30.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class showImageView: UIView,UIScrollViewDelegate{

    var imge = UIImage()
    var imgeV = UIImageView()
    
    var name = ""
    var url = ""
    var lab = UILabel()
    var topView = UIView()
    var myscroll = UIScrollView()
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
    func btnAction(button:UIButton)
    {
        self.removeFromSuperview()
    }
    override func drawRect(rect: CGRect) {
        // Drawing code
        lab.text = name
        
        myscroll = UIScrollView()
        myscroll.delegate = self
        myscroll.frame = CGRectMake(0, CGRectGetMaxY(topView.frame),CGRectGetWidth(UIScreen.mainScreen().bounds),CGRectGetHeight(UIScreen.mainScreen().bounds) - CGRectGetMaxY(topView.frame))
        myscroll.contentSize = imgeV.frame.size
        myscroll.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        myscroll.maximumZoomScale = 5.0
        myscroll.minimumZoomScale = 1.0
        self.addSubview(myscroll)
        
        imgeV = UIImageView(frame: CGRectMake(20,50,CGRectGetWidth(myscroll.frame)-40,CGRectGetHeight(myscroll.frame)-100))
        imgeV.image = imge
        myscroll.addSubview(imgeV)
        
    }
    //MARK: scrollViewdelegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imgeV
    }
}
