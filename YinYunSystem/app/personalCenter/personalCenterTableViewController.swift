//
//  personalCenterTableViewController.swift
//  YinYunSystem
//
//  Created by Mac on 16/3/7.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class personalCenterTableViewController: UITableViewController,HttpProtocol{

    var titleArry = NSArray()
    var itemArry = NSMutableArray()
    var itemDic = NSDictionary()
    var  url = "/Mobile/Mobile/JContacts"
     var url2 = "/MyInfo/JMySet"
    var request = HttpRequest()
    var rightItem = UIButton()
    
    var name:String = ""
    var zhanghao:String = ""
    var miMa:String = ""
    var mobilePhone:String = ""
    var phone:String = ""
    var email:String = ""
    var flagRequest = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.scrollEnabled = false
        titleArry = NSArray(objects: "姓 名","帐 号","密 码","移动电话","办公电话","邮箱")
        loadDataMethod()
        addRightItem()
        
    }
    //MARK: 加载数据的方法
    func loadDataMethod()
    {
        loadingAnimationMethod.sharedInstance.startAnimation()
        itemArry.removeAllObjects()
        let bodyStr = NSString(format: "page=1&rows=100000")
        let str = GetService + url
        request.delegate = self
        request.Post(str, str: bodyStr as String)
    }
    func didResponse(result: NSDictionary) {
        loadingAnimationMethod.sharedInstance.endAnimation()
         print(result)
        if(flagRequest == false)
        {
            let arryIt =  (result.objectForKey("dt") as? NSMutableArray)!
            let userName = ((UIApplication.sharedApplication().delegate) as! AppDelegate).getUserName()
            for(var i = 0;i < arryIt.count;++i)
            {
                let arryDic =  arryIt.objectAtIndex(i) as! NSDictionary
                let str = arryDic.objectForKey("U_UName") as! String
                if(userName == str)
                {
                    itemArry.addObject(arryDic)
                }
            }
            self.tableView.reloadData()
        }else{
           
            let flag = result.objectForKey("flag") as? NSNumber
            if(Int(flag!) == 1)
            {
                NSUserDefaults.standardUserDefaults().setObject(zhanghao, forKey:"user")
                NSUserDefaults.standardUserDefaults().setObject(miMa, forKey:"pwd")
                loadDataMethod()
                flagRequest = false
                alter("提示", message: "请求成功")
                
            }else{
                let meg = result.objectForKey("msg") as? String
                alter("提示！", message: meg!)
            }

        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titleArry.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        tableView.registerNib(UINib(nibName: "personalTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        let cell:personalTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! personalTableViewCell
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        if(titleArry.count > 0)
        {
            cell.titleName.text = titleArry.objectAtIndex(indexPath.row) as? String
        }
        if(rightItem.selected == false)
        {
            cell.contentText.hidden = true
            cell.contentL.hidden = false
            
        }else{
            cell.contentText.hidden = false
            cell.contentL.hidden = true
        }
        getValue(indexPath, cell: cell)
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
         resignFirstResponderMenthod()
    }
    func resignFirstResponderMenthod()
    {
        let cellArry =  tableView.visibleCells as NSArray
        for(var i = 0;i < cellArry.count; ++i)
        {
            let cell = cellArry.objectAtIndex(i) as! personalTableViewCell
            cell.contentText.resignFirstResponder()
        }

    }
    func getValue(index:NSIndexPath,cell:personalTableViewCell)
    {
        if(itemArry.count > 0)
        {
            itemDic = (itemArry.objectAtIndex(0) as? NSDictionary)!
            if(index.row == 0)
            {
                // yong hu ming
                cell.contentL.text = itemDic.objectForKey("U_Name") as? String
                cell.contentText.text = itemDic.objectForKey("U_Name") as? String
            }else if(index.row == 1)
            {
                // yong hu ming
                cell.contentL.text = itemDic.objectForKey("U_UName") as? String
                cell.contentText.text = itemDic.objectForKey("U_UName") as? String
            }else if(index.row == 2){
                // mi ma
                cell.contentL.text = ((UIApplication.sharedApplication().delegate) as! AppDelegate).getPassword()
                cell.contentText.text = ((UIApplication.sharedApplication().delegate) as! AppDelegate).getPassword()
            }else if(index.row == 3){
                // yi dong dian hua
                cell.contentL.text = itemDic.objectForKey("TELEPHONE") as? String
                cell.contentText.text = itemDic.objectForKey("TELEPHONE") as? String
            }else if(index.row == 4){
                //ban gong dian hua
                cell.contentL.text = itemDic.objectForKey("Phone") as? String
                cell.contentText.text = itemDic.objectForKey("Phone") as? String
            }else if(index.row == 5){
                // email
                cell.contentL.text = itemDic.objectForKey("EMAIL") as? String
                cell.contentText.text = itemDic.objectForKey("EMAIL") as? String

            }

        }
       

    }
    func addRightItem()
    {
        rightItem = UIButton(frame: CGRectMake(0, 0,60, 30))
        rightItem.selected = false
        rightItem.setTitle("编辑", forState: UIControlState.Normal)
        rightItem.titleLabel?.font = UIFont.systemFontOfSize(16.0)
        rightItem.titleLabel?.textAlignment = NSTextAlignment.Right
        rightItem.addTarget(self, action: Selector("rightItemAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        let item2=UIBarButtonItem(customView: rightItem)
        self.navigationItem.rightBarButtonItem = item2
    }
    func rightItemAction(send:UIButton)
    {
        if(rightItem.selected == false)
        {
            rightItem.selected = true
            flagRequest = false
            rightItem.setTitle("提交", forState: UIControlState.Normal)
            self.tableView.reloadData()
        }else if(rightItem.selected == true){
            rightItem.selected = false
            flagRequest = true
            loadDataMethod2()
            resignFirstResponderMenthod()
            rightItem.setTitle("编辑", forState: UIControlState.Normal)
//            self.tableView.reloadData()
        }
    }
    func loadDataMethod2()
    {
       
        loadingAnimationMethod.sharedInstance.startAnimation()
        let cellArry =  tableView.visibleCells as NSArray
        for(var i = 0;i < cellArry.count;++i)
        {
            let cell = cellArry.objectAtIndex(i) as! personalTableViewCell
            if(i == 0)
            {
                name = cell.contentText.text!
            }else if(i == 1){
                zhanghao = cell.contentText.text!
            }else if(i == 2){
                miMa = cell.contentText.text!
            }else if(i == 3){
                mobilePhone = cell.contentText.text!
            }else if(i == 4){
                phone = cell.contentText.text!
            }else if(i == 5){
                email = cell.contentText.text!
            }
            
        }
        if(zhanghao != "" || miMa != "")
        {
            let bodyStr = NSString(format: "uname=\(name)&uno=\(zhanghao)&upwd=\(miMa)&telphone=\(mobilePhone)&bangong=\(phone)&email=\(email)")
            print(bodyStr)
            let str = GetService + url2
            request.delegate = self
            request.Post(str, str: bodyStr as String)
        }else{
            alter("提示", message: "用户名或密码不能为空！")
        }
        
    }
   
    func alter(title:String,message:String)
    {
        let alertView =  UIAlertController.init(title:title, message:message, preferredStyle: UIAlertControllerStyle.Alert)
        let alertViewCancelAction: UIAlertAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        alertView.addAction(alertViewCancelAction)
        self.presentViewController(alertView, animated:true , completion: nil)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
