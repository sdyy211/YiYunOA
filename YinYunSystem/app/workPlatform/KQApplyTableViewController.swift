//
//  KQApplyTableViewController.swift
//  YinYunSystem
//
//  Created by 魏辉 on 16/2/16.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class KQApplyTableViewController: UITableViewController {
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var httpRequest: HttpRequest!
    var applyArray: [KQApply]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        spinner.color = UIColor.blueColor()
        view.addSubview(spinner)
        spinner.startAnimating()
        
        applyArray = [KQApply]()
        
        httpRequest = HttpRequest()
        httpRequest.delegate = self
        
        let bodyStr = "page=1&rows=1000"
        do {
            
            try httpRequest.Post2(GetService + "/KaoQinCheck/JMyKaoQinList", str: bodyStr)
        } catch {
            let alert  = UIAlertController(title: "警告", message: "网络异常", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
                
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }

    }

}

private typealias TableViewDataSource = KQApplyTableViewController

extension TableViewDataSource {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return applyArray.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("KQApplyCell", forIndexPath: indexPath) as! KQApplyTableViewCell
        cell.startTimeLabel.text = "起：" + applyArray[indexPath.row].startTime
        cell.endTimeLabel.text = "止：" + applyArray[indexPath.row].endTime
        cell.stateLabel.text = applyArray[indexPath.row].state
        cell.stateLabel.textColor = UIColor.grayColor()
        
        if applyArray[indexPath.row].type == "公出" || applyArray[indexPath.row].type == "出差" {
            
            cell.chooseImage.image = UIImage(named: "chai")
            cell.endTimeLabel.textColor = UIColor(red: 69.0/255.0, green:
                163.0/255.0, blue: 230.0/255.0, alpha: 1.0)
            cell.startTimeLabel.textColor = UIColor(red: 69.0/255.0, green:
                163.0/255.0, blue: 230.0/255.0, alpha: 1.0)
            
        } else if applyArray[indexPath.row].type == "请假" {
            cell.chooseImage.image = UIImage(named: "jia")
            cell.endTimeLabel.textColor = UIColor(red: 255.0/255.0, green:
                115.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            cell.startTimeLabel.textColor = UIColor(red: 255.0/255.0, green:
                115.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        } else if applyArray[indexPath.row].type == "加班" {
            cell.chooseImage.image = UIImage(named: "JB")
            cell.endTimeLabel.textColor = UIColor(red: 230.0/255.0, green:
                82.0/255.0, blue: 69.0/255.0, alpha: 1.0)
            cell.startTimeLabel.textColor = UIColor(red: 230.0/255.0, green:
                82.0/255.0, blue: 69.0/255.0, alpha: 1.0)
        } else if applyArray[indexPath.row].type == "调休" {
            cell.chooseImage.image = UIImage(named: "tiao")
            cell.endTimeLabel.textColor = UIColor(red: 57.0/255.0, green:
                175.0/255.0, blue: 182.0/255.0, alpha: 1.0)
            cell.startTimeLabel.textColor = UIColor(red: 57.0/255.0, green:
                175.0/255.0, blue: 182.0/255.0, alpha: 1.0)
        } else if applyArray[indexPath.row].type == "补录考勤" {
            cell.chooseImage.image = UIImage(named: "bu")
            cell.endTimeLabel.textColor = UIColor(red: 102.0/255.0, green:
                102.0/255.0, blue: 102.0/255.0, alpha: 1.0)
            cell.startTimeLabel.textColor = UIColor(red: 102.0/255.0, green:
                102.0/255.0, blue: 102.0/255.0, alpha: 1.0)
        }
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

}

private typealias Https = KQApplyTableViewController
extension Https: HttpProtocol {
    func didResponse(result: NSDictionary) {
        print(result)
        
        if let data = result["rows"] {
            let json = JSON(data)
            
            for val in json {
                var apply = KQApply()
                apply.startTime = val.1["KQ_StartTime"].string!
                apply.endTime = val.1["KQ_EndTime"].string!
                apply.type = val.1["KQ_Type"].string!
                apply.state = val.1["KQ_State"].string!
                applyArray.append(apply)
            }
            spinner.stopAnimating()
            self.tableView.reloadData()
            
        }
    }

}
