//
//  yongZhangPendingVController.swift
//  YinYunSystem
//
//  Created by Mac on 16/3/7.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class yongZhangPendingVController: UIViewController,HttpProtocol,UITableViewDataSource,UITableViewDelegate{

     //服务器/mobile/mobile/JGetCachetCheckList   zt =2  待审 zt=-1 退回 zt=1 通过
    
    @IBOutlet weak var tv: UITableView!
    var url = "/mobile/mobile/JGetCachetCheckList"
    var url2 = "/mobile/mobile/JShenHeCachet"
    var request = HttpRequest()
    var itemArry = NSArray()
    var flag = "0"
    var detileView = yongZhangDetileView()
    var color = UIColor(colorLiteralRed: 238.0/255.0, green: 247.0/255.0, blue: 244.0/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
//        tv.delegate = self
//        tv.dataSource = self
        tv.backgroundColor = color
        request.delegate = self
        addLeftItem()
        loadData()
    }
    func addLeftItem()
    {
        let btn1 = UIButton(frame: CGRectMake(0, 0,12, 20))
        btn1.setBackgroundImage(UIImage(named: "7"), forState: UIControlState.Normal)
        btn1.addTarget(self, action: Selector("letfItemAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        let item2=UIBarButtonItem(customView: btn1)
        self.navigationItem.leftBarButtonItem = item2
    }
    func letfItemAction(send:UIButton)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    //当前页面请求方法
    func loadData()
    {
        flag = "0"
        loadingAnimationMethod.sharedInstance.startAnimation()
        let param = ["zt":"2"]
        request.Get(GetService + url, parameters: param)
    }
    //退回按钮的请求方法
    func loadData_exitAction(id:String)
    {
        flag = "1"
        loadingAnimationMethod.sharedInstance.startAnimation()
        
        let param = ["flag":"－1","bid":id]
        request.Get(GetService + url2, parameters: param)
    }
    //通过按钮的请求方法
    func loadData_trueAction(id:String)
    {
        flag = "2"
        loadingAnimationMethod.sharedInstance.startAnimation()
        let param = ["flag":"1","bid":id]
        request.Get(GetService + url2, parameters: param)
    }
    func didResponse(result: NSDictionary) {
        loadingAnimationMethod.sharedInstance.endAnimation()
        if(flag == "0")
        {
            
            print(result)
            itemArry = (result.objectForKey("dt") as? NSArray)!
            tv.reloadData()
        }else if(flag == "1"){
            print(result)
            let num = result.objectForKey("flag") as! NSNumber
            let flag =  "\(num)"
            if(flag == "0")
            {
                alter("提示", message: "操作失败！")
            }else{
                detileView.removeFromSuperview()
                alter("提示", message: "操作成功！")
                loadData()
            }

        }else if(flag == "2"){
            print(result)
            let num = result.objectForKey("flag") as! NSNumber
            let flag =  "\(num)"
            if(flag == "0")
            {
                alter("提示", message: "操作失败！")
            }else{
                detileView.removeFromSuperview()
                alter("提示", message: "操作成功！")
                loadData()
            }

        }
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArry.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 113
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.registerNib(UINib(nibName: "yongZhangPendingCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        let cell:yongZhangPendingCell = tableView.dequeueReusableCellWithIdentifier("cell") as! yongZhangPendingCell
        cell.contentView.backgroundColor = color
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.textLabel?.textColor = UIColor(colorLiteralRed: 113.0/255.0, green: 123.0/255.0, blue: 128.0/255.0, alpha: 1)
        cell.cellbackView.layer.borderWidth = 1
        cell.cellbackView.layer.borderColor = UIColor.grayColor().CGColor
        cell.cellbackView.layer.cornerRadius  = 10
        
        let dic =  itemArry.objectAtIndex(indexPath.row) as! NSDictionary
        cell.name.text = dic.objectForKey("BD_UName") as? String
        cell.department.text = dic.objectForKey("BD_BuMen") as? String
        cell.type.text = dic.objectForKey("BD_LeiXing") as? String
        cell.time.text = dic.objectForKey("BD_Time") as? String
        cell.state.text = dic.objectForKey("FCK_State") as? String
       
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let dic = itemArry.objectAtIndex(indexPath.row) as! NSDictionary
        detileView = yongZhangDetileView.init(frame: CGRectMake(0,0,CGRectGetWidth(UIScreen.mainScreen().bounds),CGRectGetHeight(UIScreen .mainScreen().bounds)))
        detileView.backgroundColor = UIColor.init(colorLiteralRed:0, green: 0, blue: 0, alpha:0.5)
        detileView.url = url2
        detileView.dataDic = dic
        detileView.nameKey = "BD_UName"
        detileView.departmentKey = "BD_BuMen"
        detileView.viewController = self
        detileView.titleArry = ["用印分类","用印时间","用印事由","备注","留存材料","用印次数","当前状态"]
        detileView.keyArry = ["BD_LeiXing","BD_Time","BD_Reason","BD_BeiZhu","BD_CaiLiao","BD_CiShu","BD_State"]
//        detileView.delegate = self
        let window:UIWindow = UIApplication.sharedApplication().keyWindow!
        window.addSubview(detileView)

    }
    
    func setLoadData() {
        
        loadData()
    }
    func exitBtnAction(button: UIButton, id: String) {
        loadData_exitAction(id)
    }
    func trueBtnAction(button: UIButton, id: String) {
        loadData_trueAction(id)
    }
    func alter(title:String,message:String)
    {
        let alertView =  UIAlertController.init(title:title, message:message, preferredStyle: UIAlertControllerStyle.Alert)
        let alertViewCancelAction: UIAlertAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        alertView.addAction(alertViewCancelAction)
        self.presentViewController(alertView, animated:true , completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
