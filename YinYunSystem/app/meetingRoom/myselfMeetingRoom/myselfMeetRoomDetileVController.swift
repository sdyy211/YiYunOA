//
//  myselfMeetRoomDetileVController.swift
//  YinYunSystem
//
//  Created by Mac on 16/2/4.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class myselfMeetRoomDetileVController: UITableViewController,HttpProtocol,UIAlertViewDelegate{
    var itemArry = NSMutableArray()
    var deleteUrl = "/MeetingRoom/JDeleteReq"
    var request = HttpRequest()
    var type = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "会议详情"
        if(type == "1")
        {
             addRightItem()
        }
        addLeftItem()
        request.delegate = self
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
    func addRightItem()
    {
        let btn1 = UIButton(frame: CGRectMake(0, 0,40, 30))
        btn1.setTitle("删除", forState: UIControlState.Normal)
        btn1.titleLabel?.font = UIFont.systemFontOfSize(17.0)
        btn1.titleLabel?.textAlignment = NSTextAlignment.Right
        btn1.addTarget(self, action: Selector("deleteItemAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        let item2=UIBarButtonItem(customView: btn1)
        self.navigationItem.rightBarButtonItem = item2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func deleteItemAction(send:UIButton)
    {
        let dicData = itemArry.objectAtIndex(0)
        let roomId = dicData.objectForKey("Q_ID") as! String
        let postStr = "qid=\(roomId)"
        loadingAnimationMethod.sharedInstance.startAnimation()
        request.Post(GetService + deleteUrl, str: postStr)
    }
    func  didResponse(result: NSDictionary) {
        loadingAnimationMethod.sharedInstance.endAnimation()
        let str = result.objectForKey("msg") as! String
        if(str == "")
        {
            alter("提示", message:"删除成功")
        }else{
            alter("提示", message:str)
        }
    }
    func alter(title:String,message:String)
    {
        let alertView =  UIAlertController.init(title:title, message:message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let alertViewCancelAction: UIAlertAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default,
            handler: {
                action in
                self.navigationController?.popViewControllerAnimated(true)
        })
        
        alertView.addAction(alertViewCancelAction)
        alertView.addAction(okAction)
        self.presentViewController(alertView, animated:true , completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGRectGetHeight(UIScreen.mainScreen().bounds) - 65
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        tableView.registerNib(UINib(nibName: "myselfMeetRoomDetileCell", bundle: nil), forCellReuseIdentifier:"cell")
        let cell:myselfMeetRoomDetileCell = tableView.dequeueReusableCellWithIdentifier("cell")! as! myselfMeetRoomDetileCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let dicData = itemArry.objectAtIndex(0)
        
        cell.meetName.text =  dicData.objectForKey("Q_Title") as? String
        cell.startTime.text =  dicData.objectForKey("Q_StartTime") as? String
        cell.endTime.text =  dicData.objectForKey("Q_EndTime") as? String
        cell.meetphone.text =  dicData.objectForKey("Q_Telphone") as? String
        cell.meetRemebers.text =  dicData.objectForKey("Q_UNames") as? String
        cell.meetRoom.text =  dicData.objectForKey("MZ_Name") as? String
        cell.meetType.text =  dicData.objectForKey("Q_Type") as? String
        let fenPei = dicData.objectForKey("Q_MayFenPei") as? String
        if(fenPei == "0")
        {
//            cell.mayFeiPeiBtn.selected = true
            cell.mayFeiPeiBtn.setTitle("不允许", forState: UIControlState.Normal)
//            cell.mayFeiPeiBtn.setImage(UIImage(named: "choosed"), forState: UIControlState.Selected)
        }else{
//            cell.mayFeiPeiBtn.selected = false
            cell.mayFeiPeiBtn.setTitle("允许", forState: UIControlState.Normal)
//            cell.mayFeiPeiBtn.setImage(UIImage(named: "inchoose"), forState: UIControlState.Reserved)
        }
        return cell
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
