//
//  KQJiaTimeViewController.swift
//  YinYunSystem
//
//  Created by 魏辉 on 16/2/3.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class KQJiaTimeViewController: UIViewController {
    
    @IBOutlet weak var beginTime: UIDatePicker!
    
    @IBOutlet weak var endTime: UIDatePicker!
    
    @IBAction func saveAction(sender: UIBarButtonItem) {
        
    }
    
    @IBAction func backAction(sender: UIBarButtonItem) {

    }
    
    //初始时间记录
    var begin: NSDate!
    var end: NSDate!

    override func viewDidLoad() {
        super.viewDidLoad()
        if begin != nil {
            
            beginTime.setDate(begin, animated: true)
            endTime.setDate(end, animated: true)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let datefor = NSDateFormatter()
        datefor.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if segue.identifier == "UnwindAskForJiaDone" {
            
            
            let begin = datefor.stringFromDate(beginTime.date)
            let end = datefor.stringFromDate(endTime.date)
            let viewController = segue.destinationViewController as! KQJiaTableViewController
            viewController.beginButton.setTitle(begin, forState: UIControlState.Normal)
            viewController.endButton.setTitle(end, forState: .Normal)
        } else if segue.identifier == "UnwindAskForJia" {
            if begin != nil {
                
                let viewController = segue.destinationViewController as! KQJiaTableViewController
                viewController.beginButton.setTitle(datefor.stringFromDate(begin), forState: UIControlState.Normal)
                viewController.endButton.setTitle(datefor.stringFromDate(end), forState: .Normal)
            }
        }
        
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
