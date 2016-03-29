//
//  AuditDetileView.swift
//  YinYunSystem
//
//  Created by Mac on 16/2/17.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
@objc  protocol AuditDetileProtocol{
    func setLoadData()
}
class AuditDetileView: UIView,UITableViewDelegate,UITableViewDataSource,HttpProtocol{
    var deleteURL = ""
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
        request.delegate = self
        
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
       
        return 200
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.registerNib(UINib(nibName: "AuditDetileTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        let cell:AuditDetileTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! AuditDetileTableViewCell
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        cell.selectionStyle = UITableViewCellSelectionStyle.None	
        cell.projectL.text =  itemDic.objectForKey("XiangMu") as? String
        cell.startTime.text =  itemDic.objectForKey("KQ_StartTime") as? String
        cell.endTime.text =  itemDic.objectForKey("KQ_EndTime") as? String
        cell.shiyou.text =  itemDic.objectForKey("KQ_Content") as? String
        height = CGRectGetHeight((cell.frame))
    
        return cell
    }
    override func willMoveToWindow(newWindow: UIWindow?) {
        
    }
    override func didMoveToWindow() {
        
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
        
        let leftW:CGFloat = 20
        let btnWith = (CGRectGetWidth(tv.frame)-leftW*2)/2-20
       
        
        let btn = UIButton()
        btn.frame = CGRectMake(leftW, 15,btnWith,CGRectGetHeight(footerView.frame)-30)
        btn.setTitle("退回", forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "exitBtn"), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn.addTarget(self, action: Selector("btnAction"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let btnCenter = CGRectGetWidth(tv.frame)-CGRectGetMaxX(btn.frame)-20-btnWith
        let btn2 = UIButton()
        btn2.frame = CGRectMake(CGRectGetMaxX(btn.frame)+btnCenter, 15,btnWith,CGRectGetHeight(btn.frame))
        btn2.setBackgroundImage(UIImage(named: "trueBtn"), forState: UIControlState.Normal)
        btn2.setTitle("通过", forState: UIControlState.Normal)
        btn2.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn2.addTarget(self, action: Selector("btn2Action"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let btnWith2 = CGRectGetWidth(tv.frame)-40
        let btn3 = UIButton()
        btn3.frame = CGRectMake(20, 15,btnWith2,CGRectGetHeight(btn.frame))
        btn3.setBackgroundImage(UIImage(named: "trueBtn"), forState: UIControlState.Normal)
        btn3.setTitle("确定", forState: UIControlState.Normal)
        btn3.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn3.addTarget(self, action: Selector("btn3Action"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let lineL = UILabel()
        lineL.frame = CGRectMake(0, 0,CGRectGetWidth(tv.frame), 1)
        lineL.backgroundColor = UIColor(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1)
        
      
        footerView.addSubview(lineL)
        footerView.addSubview(btn)
        footerView.addSubview(btn2)

        
        detileView.addSubview(footerView)
        
        detileView.frame = UIScreen.mainScreen().bounds
        let  scale = JNWSpringAnimation(keyPath: "transform.scale")
        
        scale.fromValue = 0
        scale.toValue = 1
        
        detileView.layer.addAnimation(scale, forKey: scale.keyPath)
        detileView.transform = CGAffineTransformMakeScale(1, 1)
        self.addSubview(detileView)
    }
    // MARK:退回的点击事件
    func btnAction()
    {
        let str = itemDic.objectForKey("KQ_ID") as! String
        loadBatch("0", kqid: str)
    }
    // MARK:通过的点击事件
    func btn2Action()
    {
        let str = itemDic.objectForKey("KQ_ID") as! String
        loadBatch("1", kqid: str)
    }
    func loadBatch(type:String,kqid:String)
    {
        let bodyStr = NSString(format:"type=\(type)&kqid=\(kqid)")
        let str = GetService + deleteURL
        request.delegate = self
        request.Post(str, str: bodyStr as String)
    }
    // MARK: 接收请求后台的数据
    func didResponse(result: NSDictionary) {
        print("\(result)")
        let num = result.objectForKey("flag") as! NSNumber
        let flag =  "\(num)"
        if(flag == "0")
        {
                alter("提示", message: "操作失败！")
        }else{
            alter("提示", message: "操作成功！")
        }
    }
    func alter(title:String,message:String)
    {
        let alertView =  UIAlertController.init(title:title, message:message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default,
            handler: {
                action in
                self.delegate!.setLoadData()
                self.removeFromSuperview()
        })
        
        alertView.addAction(okAction)
        viewController.navigationController!.presentViewController(alertView, animated:true , completion: nil)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.removeFromSuperview()
    }

}
