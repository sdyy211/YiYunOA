//
//  ViewController.swift
//  YinYunSystem
//
//  Created by 魏辉 on 16/1/12.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class ViewController: UIViewController,HttpProtocol{

    @IBOutlet weak var userTextfield: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    
    @IBOutlet weak var rememberBtn: UIButton!
    @IBOutlet weak var zidongBtn: UIButton!
    
    var loginStatus = NSDictionary()
    var loginUrl = "/Login/JDoLogin"
    var loginMutableDic = NSMutableDictionary()
    var request = HttpRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request.delegate = self
        
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let str =  NSUserDefaults.standardUserDefaults().objectForKey("flag") as? String
        if(str == "0" && str != nil)
        {
            rememberBtn.selected = false
            rememberBtn.setImage(UIImage(named: "inchoose"), forState: UIControlState.Reserved)
            userTextfield.text = NSUserDefaults.standardUserDefaults().objectForKey("user") as? String
            pwdTextField.text = NSUserDefaults.standardUserDefaults().objectForKey("pwd") as? String
        }else if(str == "1" && str != nil){
            rememberBtn.selected = true
            rememberBtn.setImage(UIImage(named: "choosed"), forState: UIControlState.Selected)
            userTextfield.text = NSUserDefaults.standardUserDefaults().objectForKey("user") as? String
            pwdTextField.text = NSUserDefaults.standardUserDefaults().objectForKey("pwd") as? String
        }

    }
    //记住密码事件
    @IBAction func rememberBtnAction(sender: AnyObject) {
        rememberBtn = sender as! UIButton
        if(rememberBtn.selected == false)
        {
            rememberBtn.tag == 1
            rememberBtn.selected = true
            rememberBtn.setImage(UIImage(named: "choosed"), forState: UIControlState.Selected)
        }else if(rememberBtn.selected == true){
            rememberBtn.tag == 0
            rememberBtn.selected = false
            rememberBtn.setImage(UIImage(named: "inchoose"), forState: UIControlState.Reserved)
        }
    }
    //自动登录事件
    @IBAction func zidongBtnAction(sender: AnyObject) {
        if(zidongBtn.tag == 0)
        {
            zidongBtn.tag == 1;
            zidongBtn.setImage(UIImage(named: "inchoose"), forState: UIControlState.Normal)
        }else if(zidongBtn.tag == 1){
            zidongBtn.tag == 0;
            zidongBtn.setImage(UIImage(named: "choosed"), forState: UIControlState.Selected)
        }
    }
    //登录事件
    @IBAction func loginBtnAction(sender: AnyObject) {
        
        
        if(userTextfield.text != "" || pwdTextField.text != "")
        {
            loadingAnimationMethod.sharedInstance.startAnimation()
            let bodyStr = NSString(format: "uname=\(userTextfield.text!)&upwd=\(pwdTextField.text!)")
            let str = GetService + loginUrl
            request.Post(str, str: bodyStr as String)
        }else{
            let alertView =  UIAlertController.init(title:"提示", message:"请检查用户名和密码是否填写写！！", preferredStyle: UIAlertControllerStyle.Alert)
            let alertViewCancelAction: UIAlertAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
            alertView.addAction(alertViewCancelAction)
            self.presentViewController(alertView, animated:true , completion: nil)

        }
    
    }
    func didResponse(result: NSDictionary) {
        loadingAnimationMethod.sharedInstance.endAnimation()
        let cookieJob = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        let cookieArray:[NSHTTPCookie] = cookieJob.cookies!
        if(cookieArray.count > 0)
        {
            var cook = NSHTTPCookie()
            
            //            for (var i = 0;i < cookieArray.count; ++i) {
            //                cookieJob.deleteCookie(cook)
            //            }
            for(var i = 0;i < cookieArray.count; ++i)
            {
                cook = cookieArray[i]
                NSUserDefaults.standardUserDefaults().setObject(cook.value, forKey:"cookie")
                
            }
        }
        
        
        
        //处理审核中待审的权限处理
        let dic = result.objectForKey("values") as! NSDictionary
        let str = dic.objectForKey("rids") as! String
        let ary = str.componentsSeparatedByString(",") as NSArray
        let baoXiaoPermissions = NSMutableArray()
        "11e2-b7c1-81808260-abf8-5b8974d843b8,310742af-81a6-4761-9bc0-6468028c898c,81cc8dd7-70d3-452a-91ee-12192face90e,11e0-fbb1-2d9446ea-bb6a-776133f77891"
        for ids in ary
        {
            switch(ids as! String){
                case "11e0-f890-57dfabba-9d52-47c4bc674a35":
                    baoXiaoPermissions.addObject("部门经理")
                    break
                case "11e0-f890-5ca45fbb-9d52-47c4bc674a35":
                    baoXiaoPermissions.addObject("副总经理")
                    break
                case "11e0-fbb1-2d9446ea-bb6a-776133f77891":
                    baoXiaoPermissions.addObject("员工")
                    break
                case "11e0-fbb1-182b03c7-bb6a-776133f77891":
                    baoXiaoPermissions.addObject("总经理")
                    break
                case "11e2-b7c1-81808260-abf8-5b8974d843b8":
                    baoXiaoPermissions.addObject("总经理助理")
                    break
                default:
                    break
            }
        }
        NSUserDefaults.standardUserDefaults().setObject(baoXiaoPermissions, forKey:"baoXiaoPermissions")
        
        //对登陆状态的处理
        let value:NSNumber = result.objectForKey("flag") as! NSNumber
        let index = value.intValue
        if(index == 1)
        {
            OAsySytemService.sharedInstance.startService()
            if( rememberBtn.selected ==	 true)
            {
                NSUserDefaults.standardUserDefaults().setObject(self.userTextfield.text, forKey:"user")
                NSUserDefaults.standardUserDefaults().setObject(self.pwdTextField.text, forKey:"pwd")
                NSUserDefaults.standardUserDefaults().setObject("1", forKey:"flag")
            }else{
                rememberBtn.selected =	false
                NSUserDefaults.standardUserDefaults().setObject(self.userTextfield.text, forKey:"user")
                NSUserDefaults.standardUserDefaults().setObject(self.pwdTextField.text, forKey:"pwd")
                let btnFlog = rememberBtn.selected
                NSUserDefaults.standardUserDefaults().setObject(btnFlog, forKey:"flag")
            }
            UIApplication.sharedApplication().statusBarStyle = .LightContent
            self.performSegueWithIdentifier("action", sender:self)
        }else{
            let alertView =  UIAlertController.init(title:"提示", message:"登录失败！", preferredStyle: UIAlertControllerStyle.Alert)
            let alertViewCancelAction: UIAlertAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
            alertView.addAction(alertViewCancelAction)
            self.presentViewController(alertView, animated:true , completion: nil)
            
        }

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        userTextfield.resignFirstResponder()
        pwdTextField.resignFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

