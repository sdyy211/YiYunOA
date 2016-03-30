//
//  baoXiaoBottomView.swift
//  YinYunSystem
//
//  Created by Mac on 16/3/30.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

@objc protocol baoXiaoBottomProtocol{
    func tuiHuiAction(button:UIButton)
    func tongGuoAction(button:UIButton)
}
class baoXiaoBottomView: UIView {

    var delegate:baoXiaoBottomProtocol?
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        self.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        let with = (CGRectGetWidth(self.frame)-30)/2
        let btn = UIButton()
        btn.frame = CGRectMake(10, 5,with, 30)
        btn.setBackgroundImage(UIImage(named: "exitBtn"), forState: UIControlState.Normal)
        btn.setTitle("退回", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        btn.addTarget(self, action: Selector("tuiHuiAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(btn)
        
        let btn2 = UIButton()
        btn2.frame = CGRectMake(CGRectGetMaxX(btn.frame)+10, 5,with, 30)
        btn2.setTitle("通过", forState: UIControlState.Normal)
        btn2.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        btn2.addTarget(self, action: Selector("tongGuoAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        btn2.setBackgroundImage(UIImage(named: "trueBtn"), forState: UIControlState.Normal)
        self.addSubview(btn2)
        
    }
    func tuiHuiAction(button:UIButton)
    {
        delegate?.tuiHuiAction(button)
    }
    func tongGuoAction(button:UIButton)
    {
        delegate?.tongGuoAction(button)
    }
}
