//
//  myselfMeetingRoomVController.swift
//  YinYunSystem
//
//  Created by Mac on 16/2/2.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class myselfMeetingRoomVController: UITableViewController,HttpProtocol{

    @IBOutlet var tv: UITableView!
    var url = "/MeetingRoom/JMyList"
    var deleteUrl = "/MeetingRoom/JDeleteReq"
    var itemArry:NSMutableArray = NSMutableArray()
    var request = HttpRequest()
    var dataArray = NSMutableArray()
    var roomId  = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "我的会议室"
        addLeftItem()
        request.delegate = self
    }
  
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
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
    func loadData()
    {
        let postStr = "page=1&rows=100000"
        loadingAnimationMethod.sharedInstance.startAnimation()
        request.Post(GetService + url, str: postStr)
    }
    func deleteCell(roomId:String)
    {

        let postStr = "qid=\(roomId)"
        loadingAnimationMethod.sharedInstance.startAnimation()
        request.Post(GetService + deleteUrl, str: postStr)
    }
    func didResponse(result: NSDictionary) {
        loadingAnimationMethod.sharedInstance.endAnimation()
        let keyArry =  result.allKeys as NSArray
	        for(var i = 0;i < keyArry.count;i++)
        {
            let str =  keyArry[i] as! String
            if(str == "rows")
            {
                let arry = result.objectForKey("rows") as! NSArray
                itemArry = NSMutableArray(array: arry as [AnyObject], copyItems: true)
                break
            }
            if(str == "msg")
            {
                let str = result.objectForKey("msg") as! String
                if(str == "")
                {
                    alter("提示", message:"删除成功")
                    loadData()
                }else{
                    alter("提示", message:str)
                    loadData()
                }
            }
        }
        
        tv.reloadData()
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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110;
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArry.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.registerNib(UINib(nibName: "myselfMeetingRoomCell", bundle: nil), forCellReuseIdentifier:"cell")
        
        let cell:myselfMeetingRoomCell = tableView.dequeueReusableCellWithIdentifier("cell")! as! myselfMeetingRoomCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let dic = itemArry.objectAtIndex(indexPath.row) as! NSDictionary
        cell.meetName.text = dic.objectForKey("Q_Title") as? String
        cell.meetRoom.text = dic.objectForKey("MZ_Name") as? String
        cell.meetType.text = dic.objectForKey("Q_Type") as? String
        cell.startTime.text = dic.objectForKey("Q_StartTime") as? String
        cell.endTime.text = dic.objectForKey("Q_EndTime") as? String
        
        let btn = UIButton()
        btn.frame = CGRectMake(CGRectGetWidth(UIScreen.mainScreen().bounds), 0, 55, 110)
        btn.setImage(UIImage(named: "deleteImage"), forState: UIControlState.Normal)
        btn.backgroundColor = UIColor.whiteColor()
        
        let cusview = UIView()
        cusview.frame = CGRectMake(CGRectGetWidth(UIScreen.mainScreen().bounds), 0, 300, 110)
        cusview.backgroundColor = UIColor.whiteColor()
//        cusview.addSubview(btn)
        cell.contentView.addSubview(cusview)
        cell.contentView.addSubview(btn)
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dataArray.removeAllObjects()
        dataArray.addObject(itemArry.objectAtIndex(indexPath.row))
        self.performSegueWithIdentifier("myselfPushApply", sender: self)
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "删除"
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let dic =  itemArry.objectAtIndex(indexPath.row) as! NSDictionary
            
            deleteCell(dic.objectForKey("Q_ID") as! String)
            itemArry.removeObjectAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let  channel:myselfMeetRoomDetileVController = segue.destinationViewController as! myselfMeetRoomDetileVController
        channel.itemArry = dataArray
        channel.type = "1"
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
