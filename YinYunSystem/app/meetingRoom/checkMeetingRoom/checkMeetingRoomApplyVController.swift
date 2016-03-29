//
//  checkMeetingRoomApplyVController.swift
//  YinYunSystem
//
//  Created by Mac on 16/2/2.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class checkMeetingRoomApplyVController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    
    @IBOutlet weak var tv: UITableView!
    
    var roomName = String()
    var startTime = String()
    var endTime = String()
    var roomId = String()
    var style = String()  //style = 1 是查看会议室跳转会议室申请
    var itemArry = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tv.delegate = self
        tv.dataSource = self
        addLeftItem()
//        self.tableView.scrollEnabled = false
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

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
       if(style == "1")
       {
            self.title = "会议室申请"
       }else if( style == "2"){
            self.title = "会议室详情"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"删除", style: UIBarButtonItemStyle.Plain, target:self, action: Selector("deleteBtnAction:"))
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGRectGetHeight(UIScreen.mainScreen().bounds) - 65
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
         tableView.registerNib(UINib(nibName: "meetingRoomApplyCell", bundle: nil), forCellReuseIdentifier:"cell")
        let cell:meetingRoomApplyCell = tableView.dequeueReusableCellWithIdentifier("cell")! as! meetingRoomApplyCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
   
        cell.meetphoneNumLabel.hidden = true
        cell.meetNameLabel.hidden = true
        cell.meetTypeLabel.hidden = true
        cell.meetingName.hidden = false
        cell.peoplePhoneNum.hidden = false
        cell.meetingType.hidden = false
        cell.tureBtn.hidden = false
        
        cell.meetingRoom.text = roomName
        cell.startTime.text = startTime
        cell.endTime.text = endTime
        cell.roomId = roomId
        cell.VC = self
        
        return cell
    }
    func deleteBtnAction(btn:UIBarButtonItem)
    {
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
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
