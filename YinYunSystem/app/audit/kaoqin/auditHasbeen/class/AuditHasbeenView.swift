//
//  AuditHasbeenView.swift
//  YinYunSystem
//
//  Created by Mac on 16/2/23.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class AuditHasbeenView: UIView,UITableViewDelegate,UITableViewDataSource{


    var tv = UITableView()
    var itemArray = NSMutableArray()
    var itemDic = NSDictionary()
    var headerView = UIView()
    var footerView = UIView()
    var height = CGFloat()
    var request = HttpRequest()
    var viewController = UIViewController()
    var delegate = AuditDetileProtocol?()
    var detileView = UIView()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    func initView()
    {
        
        tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.frame = CGRectMake(30, 20, 10,60)
        tv.estimatedRowHeight = 50.0
        tv.rowHeight = UITableViewAutomaticDimension
        detileView.addSubview(tv)
        
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 248
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.registerNib(UINib(nibName: "AuditHasbeenCell", bundle: nil), forCellReuseIdentifier: "cell")
        let cell:AuditHasbeenCell = tableView.dequeueReusableCellWithIdentifier("cell") as! AuditHasbeenCell
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.projectL.text =  itemDic.objectForKey("XiangMu") as? String
        cell.startTime.text =  itemDic.objectForKey("KQ_StartTime") as? String
        cell.endTime.text =  itemDic.objectForKey("KQ_EndTime") as? String
        cell.shiyou.text =  itemDic.objectForKey("KQ_Content") as? String
        cell.type.text =  itemDic.objectForKey("KQ_Type") as? String
        height = CGRectGetHeight((cell.frame))
        
        return cell
    }
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        let leftWith:CGFloat = 15
        let with = (CGRectGetWidth(self.frame) - leftWith*2)
        let h = 6*50+80
        let xh = CGRectGetHeight(self.frame)
        let heightY = (xh - CGFloat(h+40))/2
        
        
        headerView = UIView()
        headerView.frame = CGRectMake(leftWith, heightY, with, 50)
        headerView.backgroundColor = UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 204.0/255.0, alpha: 1)
        
        let label = UILabel()
        label.frame = CGRectMake(0, 0,CGRectGetWidth(headerView.frame), CGRectGetHeight(headerView.frame))
        label.textAlignment = NSTextAlignment.Center
        label.text = "\( itemDic.objectForKey("U_Name") as! String)(\( itemDic.objectForKey("D_Name") as! String))"
        label.textColor = UIColor.whiteColor()
        headerView.addSubview(label)
        detileView.addSubview(headerView)
        
        tv.frame = CGRectMake(leftWith, CGRectGetMaxY(headerView.frame), with,CGFloat(h)-50)
        tv.reloadData()
        
        footerView = UIView()
        footerView.frame = CGRectMake(CGRectGetMinX(tv.frame),CGRectGetMaxY(tv.frame),CGRectGetWidth(tv.frame),60)
        footerView.backgroundColor = UIColor.whiteColor()
        
 
        
        let btnWith2 = CGRectGetWidth(tv.frame)-80
        
        let btn3 = UIButton()
        btn3.frame = CGRectMake(40, 15,btnWith2,CGRectGetHeight(footerView.frame)-30)
        btn3.setBackgroundImage(UIImage(named: "trueBtn"), forState: UIControlState.Normal)
        btn3.setTitle("返回", forState: UIControlState.Normal)
        btn3.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn3.addTarget(self, action: Selector("btn3Action"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let lineL = UILabel()
        lineL.frame = CGRectMake(0, 0,CGRectGetWidth(tv.frame), 1)
        lineL.backgroundColor = UIColor(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1)
        
        
        footerView.addSubview(lineL)
        footerView.addSubview(btn3)
        
        detileView.frame = UIScreen.mainScreen().bounds
        detileView.transform = CGAffineTransformMakeScale(0, 0)
        let  scale = JNWSpringAnimation(keyPath: "transform.scale")
        
        scale.fromValue = 0
        scale.toValue = 0.95
        
        detileView.layer.addAnimation(scale, forKey: scale.keyPath)
        detileView.transform = CGAffineTransformMakeScale(0.95, 0.95)
        detileView.addSubview(footerView)
        self.addSubview(detileView)

    }
    func btn3Action()
    {
        self.removeFromSuperview()
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.removeFromSuperview()
    }
    
}
