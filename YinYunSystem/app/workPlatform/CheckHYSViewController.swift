//
//  CheckHYSViewController.swift
//  YinYunSystem
//查询会议室页面
//  Created by 魏辉 on 16/1/13.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class CheckHYSViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate {
    //会议室选择
    @IBOutlet weak var conferenceRoom: UIPickerView!
    // 会议室查询列表
    @IBOutlet weak var list: UITableView!
    
    var currentRoom: String!
    
    
    @IBAction func submit(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("TJSegue", sender: self)
    }
    
    
    var date = ["8:00", "9:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00"]
    
    var room = ["207室", "217室", "415室"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        conferenceRoom.selectRow(1, inComponent: 1, animated: true)
        currentRoom = room[0]
        
        conferenceRoom.dataSource = self
        conferenceRoom.delegate = self
        list.dataSource = self
        list.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: pickerview
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return room.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return room[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentRoom = room[row]
    }
    
    // MARK: tableveiw
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return date.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell", forIndexPath: indexPath) as! ListTableViewCell
        cell.dateLabel.text = date[indexPath.row]
        
        return cell
        
    }
    
    // MARK: segue传值
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let applicationViewController = segue.destinationViewController as! HYSApplicationViewController
        print(currentRoom)
        applicationViewController.selectRoom = currentRoom
    }
    
    // MARK: 反向导航
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        
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
