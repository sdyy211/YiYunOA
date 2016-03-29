//
//  KQViewController.swift
//  YinYunSystem
//  考勤页面控制器
//  Created by 魏辉 on 16/1/15.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class KQViewController: UIViewController {
    
    
    @IBOutlet weak var listTableView: UITableView!
    
    var workArray = ["我的工作日历","考勤申请记录","考勤补录记录"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.tableFooterView = UIView(frame: CGRectZero)
    }

}

private typealias TableViewDataSource = KQViewController

extension TableViewDataSource: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RLCell", forIndexPath: indexPath) as! KQTableViewCell
        cell.nameLabel.text = workArray[indexPath.row]
        
        return cell
    }
}

private typealias TableViewDelegate = KQViewController

extension TableViewDelegate: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let num = indexPath.row
        switch num {
        case 0 :
            self.listTableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.performSegueWithIdentifier("RLSegue", sender: self)
            UITabBar.appearance().barTintColor = UIColor(red: 67.0/255.0, green:
                70.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            UITabBar.appearance().selectedImageTintColor = UIColor(red: 53.0/255.0, green:
                53.0/255.0, blue: 53.0/255.0, alpha: 1.0)
        case 1:
            self.listTableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.performSegueWithIdentifier("SQSegue", sender: self)
        case 2:
            self.listTableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.performSegueWithIdentifier("BLSegue", sender: self)
        default:
            break
        }
        
    }
    
}

private typealias Segues = KQViewController

extension Segues {
    @IBAction func unwindToKQ(segue: UIStoryboardSegue){
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "RLSegue" {
            let vc = segue.destinationViewController as! UITabBarController
            vc.tabBar.backgroundColor = UIColor(red: 67, green: 70, blue: 76, alpha: 1.0)
        }
    }

}



