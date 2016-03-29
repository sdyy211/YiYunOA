//
//  addressDetileView.swift
//  YinYunSystem
//
//  Created by Mac on 16/1/18.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import MessageUI
class addressDetileView: UIView,UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate{
    var  itemArray = NSMutableArray()
    var  itemDic = NSDictionary()
    var  cv:UIView = UIView()
    var  cv2:UIView = UIView()
    var  cellheight:CGFloat  = 40
    
    var yuanquan = UILabel()
    var nameL = UILabel()
    var departmentL = UILabel()
    var cusView = UIView()
    
    var tv:UITableView = UITableView()
    var viewController:UIViewController = UIViewController()
    
    var mobile = String()
    var phone = String()
    var titleImage = UIImageView()
    var myimage = UIImageView()
    var color = UIColor(colorLiteralRed: 113.0/255.0, green: 123.0/255.0, blue: 128.0/255.0, alpha: 1)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        cv.frame = CGRectMake(20, 100, CGRectGetWidth(UIScreen.mainScreen().bounds)-40,80)
        cv.layer.cornerRadius = 20;
        cv.backgroundColor = UIColor.blueColor()
        self.addSubview(cv)
        
//        cv2 = UIView()
//        cv2.frame = CGRectMake(0,60, CGRectGetWidth(cv.frame),50)
//        cv2.backgroundColor = UIColor.brownColor()
//        cv.addSubview(cv2)
        
        titleImage = UIImageView()
        titleImage.frame = CGRectMake(0, 0, CGRectGetWidth(cv.frame),80)
        titleImage.image = UIImage(named: "contact__dialog_pop")
        cv.addSubview(titleImage)
        
        myimage = UIImageView()
        myimage.frame = CGRectMake(20, 30, 50, 50)
        myimage.image = UIImage(named: "headicon")
        cv.addSubview(myimage)
        
        nameL = UILabel()
        nameL.frame = CGRectMake(CGRectGetMaxX(myimage.frame)+18,CGRectGetMinY(myimage.frame),CGRectGetWidth(cv.frame)-CGRectGetMaxX(myimage.frame)+15, 30)
        nameL.textColor = UIColor.whiteColor()
        nameL.font = UIFont.systemFontOfSize(18.0)
        cv.addSubview(nameL)
        
        departmentL = UILabel()
        departmentL.frame = CGRectMake(CGRectGetMaxX(myimage.frame)+15,CGRectGetMaxY(nameL.frame)-5,CGRectGetWidth(cv.frame)-CGRectGetMaxX(myimage.frame)+15, 20)
        departmentL.font = UIFont.systemFontOfSize(15.0)
        departmentL.textColor = color
        cv.addSubview(departmentL)
        
        tv.frame = CGRectMake(0,CGRectGetMaxY(titleImage.frame),CGRectGetWidth(cusView.frame),200)
        tv.delegate = self
        tv.dataSource = self
        tv.scrollEnabled = false
        cv.addSubview(tv)
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellheight
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style:.Default, reuseIdentifier:"mycell")
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.setSelected(false, animated:false)
        initdetile(cell, indexPath:indexPath)
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 0)
        {
            let phone = itemDic.objectForKey("TELEPHONE") as! String
            if(phone != "")
            {
                let url1 = NSURL(string: "tel://\(phone)")
                UIApplication.sharedApplication().openURL(url1!)
            }else{
            
                alter("提醒", message: "电话号码为空，不能进行电话操作！")
            }
            
        }else if(indexPath.row == 1){
            let phone = itemDic.objectForKey("Phone") as! String
            if(phone != "")
            {
                let url1 = NSURL(string: "tel://\(phone)")
                UIApplication.sharedApplication().openURL(url1!)
            }else{
                
                alter("提醒", message: "电话号码为空，不能进行电话操作！")
            }
        }
    }
    
    func alter(title:String,message:String)
    {
        let alertView =  UIAlertController.init(title:title, message:message, preferredStyle: UIAlertControllerStyle.Alert)
        let alertViewCancelAction: UIAlertAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        alertView.addAction(alertViewCancelAction)
        viewController.presentViewController(alertView, animated:true , completion: nil)
    }

    func initdetile(cell:UITableViewCell,indexPath:NSIndexPath)
    {
        let str =  itemArray.objectAtIndex(indexPath.row) as! String
        switch(str)  //移动电话","办公电话","电子邮箱"
        {
            case "移动电话":
                
                let phone = itemDic.objectForKey("TELEPHONE") as! String
                let label = UILabel()
                label.frame = CGRectMake(0,5,90,30)
                label.text = str
                label.font = UIFont.systemFontOfSize(15.0)
                label.textAlignment = NSTextAlignment.Center
                label.textColor = color
                cell.addSubview(label)
                let label2 = UILabel()
                label2.frame = CGRectMake(CGRectGetMaxX(label.frame),5,150,30)
                label2.text = phone
                label2.font = UIFont.systemFontOfSize(17.0)
                label2.textAlignment = NSTextAlignment.Left
                label2.textColor = UIColor.blackColor()
                cell.addSubview(label2)
                
                if(phone != "")
                {
                    let button = addressBtn()
                    button.frame = CGRectMake(CGRectGetMaxX(label2.frame),(cellheight-20)/2,30,20)
                    button.setBackgroundImage(UIImage(named: "message"), forState: UIControlState.Normal)
                    button.phoneNumber = phone
                    button.addTarget(self, action:Selector("sendMessage:"), forControlEvents: UIControlEvents.TouchUpInside)
                    cell.addSubview(button)
                }
                
                    break
            case "办公电话":
                
                let phone = itemDic.objectForKey("Phone") as! String
                let label = UILabel()
                label.frame = CGRectMake(0,5,90,30)
                label.text = str
                label.font = UIFont.systemFontOfSize(15.0)
                label.textAlignment = NSTextAlignment.Center
                label.textColor = color
                cell.addSubview(label)
                let label2 = UILabel()
                label2.frame = CGRectMake(CGRectGetMaxX(label.frame),5,150,30)
                label2.text = phone
                label2.font = UIFont.systemFontOfSize(17.0)
                label2.textAlignment = NSTextAlignment.Left
                label2.textColor = UIColor.blackColor()
                cell.addSubview(label2)
                
//                let button3 = addressBtn()
//                button3.frame = CGRectMake(CGRectGetWidth(cusView.frame)-90,30/2,60,30)
//                button3.setTitle("电话", forState:UIControlState.Normal)
//                button3.phoneNumber = phone
//                button3.backgroundColor = UIColor.blueColor()
//                button3.addTarget(self, action:Selector("callPhone:"), forControlEvents: UIControlEvents.TouchUpInside)
//                 cell.addSubview(button3)
                    break
            case "电子邮箱":
                let phone = itemDic.objectForKey("EMAIL") as! String
                let label = UILabel()
                label.frame = CGRectMake(0,5,90,30)
                label.text = str
                label.font = UIFont.systemFontOfSize(15.0)
                label.textAlignment = NSTextAlignment.Center
                label.textColor = color
                cell.addSubview(label)
                let label2 = UILabel()
                label2.frame = CGRectMake(CGRectGetMaxX(label.frame),5,CGRectGetWidth(tv.frame)-CGRectGetMaxX(label.frame),30)
                label2.text = phone
                label2.font = UIFont.systemFontOfSize(17.0)
                label2.textAlignment = NSTextAlignment.Left
                label2.textColor = UIColor.blackColor()
                cell.addSubview(label2)
                    break
            default:
                break
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.removeFromSuperview()
    }
    func sendMessage(button:addressBtn)
    {
        let phone = "\(button.phoneNumber)"
        initMessage(phone)
    }
    func callPhone(button:addressBtn)
    {
        
    }
    func initMessage(iphone:String)
    {
        if MFMessageComposeViewController.canSendText(){
            let controller = MFMessageComposeViewController()
            //设置短信内容
            controller.body = ""
            //设置收件人列表 阿 陈奕迅
            controller.recipients = ["\(iphone)"]
            //设置代理
            controller.messageComposeDelegate = self
            //打开界面
            viewController.presentViewController(controller, animated: true, completion: { () -> Void in
                
            })
        }else{
            print("本设备不能发送短信")
        }
    }
    //发送短信代理
    func messageComposeViewController(controller: MFMessageComposeViewController,
        didFinishWithResult result: MessageComposeResult) {
            controller.dismissViewControllerAnimated(true, completion: nil)
            switch (result.rawValue){
            case MessageComposeResultSent.rawValue:
                print("短信已发送")
            case MessageComposeResultCancelled.rawValue:
                print("短信取消发送")
            case MessageComposeResultFailed.rawValue:
                print("短信发送失败")
            default:
                break
            }
    }
    
    override func drawRect(rect: CGRect) {
        nameL.text = itemDic.objectForKey("U_Name") as? String
        let departmentStr = itemDic.objectForKey("D_Name") as! String
        departmentL.text = "(\(departmentStr))"
        let tvHeight = itemArray.count * Int(cellheight)
        tv.frame = CGRectMake(0,CGRectGetMaxY(titleImage.frame),CGRectGetWidth(cv.frame),CGFloat(tvHeight))
        cv.frame = CGRectMake(CGRectGetMinX(cv.frame),(CGRectGetHeight(UIScreen.mainScreen().bounds)-CGRectGetMaxY(tv.frame	))/2,CGRectGetWidth(cv.frame),CGRectGetMaxY(titleImage.frame)+CGFloat(tvHeight))
        let  scale = JNWSpringAnimation(keyPath: "transform.scale")
        
        scale.fromValue = 0
        scale.toValue = 0.9
        
        cv.layer.addAnimation(scale, forKey: scale.keyPath)
        cv.transform = CGAffineTransformMakeScale(0.9, 0.9)
        if(itemArray.count > 0)
        {
            tv.reloadData()
        }
}


}
