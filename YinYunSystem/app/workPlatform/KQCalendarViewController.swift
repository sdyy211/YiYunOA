//
//  KQCalendarViewController.swift
//  YinYunSystem
//  工作日历页面控制器
//  Created by 魏辉 on 16/1/15.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
//储存当天是否有加班信息
var todayChai = [KQData]()

class KQCalendarViewController: UIViewController, UITableViewDelegate {
    
    var httpRequest: HttpRequest!
    var models = [KQData]()
    var todayData = [KQData]()
    var dateFormatter: NSDateFormatter!
    var currentDate: NSDate!

    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    //考勤列表
    @IBOutlet weak var listTableVew: UITableView!
    //时间
    @IBOutlet weak var date: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()

        currentDate = NSDate()
        
        listTableVew.delegate = self
        listTableVew.dataSource = self
        httpRequest = HttpRequest()
        httpRequest.delegate = self
        dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.stringFromDate(date.date)
        dateFormatter.dateFormat = "MM"
        let month = dateFormatter.stringFromDate(date.date)
        
        let bodyStr =  "nian=\(year)&yue=\(month)"
        do {
            
            try httpRequest.Post2(GetService + "/KaoQinMask/JMyList", str: bodyStr)
        } catch {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //查询当天数据
    func check(date: NSDate) {
        //当天数据数组
        todayData.removeAll()
        //当天出差数据数组
        todayChai.removeAll()
        for model in models {
            let index1 = Int((model.startTime as NSString).substringWithRange(NSMakeRange(8, 2)))
            let index2 = Int((model.endTime as NSString).substringWithRange(NSMakeRange(8, 2)))
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd"
            let allday = Int(dateFormatter.stringFromDate(date))

            if  index1 <= allday && index2 >= allday {
                todayData.append(model)
            }
            
        }

        for val in todayData {
            if val.type == "出差" || val.type == "公出" {
                todayChai.append(val)
            }
        }
    }

}

private typealias TableViewDataSource = KQCalendarViewController

extension TableViewDataSource: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todayData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RLCell", forIndexPath: indexPath) as! KQCalenderTableViewCell
        
        if todayData[indexPath.row].data == "OA" {
            let str = "\(todayData[indexPath.row].type)[\(todayData[indexPath.row].state)]"
            cell.chooseLabel.text = str
            if todayData[indexPath.row].type == "公出" || todayData[indexPath.row].type == "出差" {
                
                cell.chooseImage.image = UIImage(named: "chai")
                cell.chooseLabel.textColor = UIColor(red: 69.0/255.0, green:
                    163.0/255.0, blue: 230.0/255.0, alpha: 1.0)
            } else if todayData[indexPath.row].type == "请假" {
                cell.chooseImage.image = UIImage(named: "jia")
                cell.chooseLabel.textColor = UIColor(red: 255.0/255.0, green:
                    115.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            } else if todayData[indexPath.row].type == "加班" {
                cell.chooseImage.image = UIImage(named: "JB")
                cell.chooseLabel.textColor = UIColor(red: 230.0/255.0, green:
                    82.0/255.0, blue: 69.0/255.0, alpha: 1.0)
            } else if todayData[indexPath.row].type == "调休" {
                cell.chooseImage.image = UIImage(named: "tiao")
                cell.chooseLabel.textColor = UIColor(red: 57.0/255.0, green:
                    175.0/255.0, blue: 182.0/255.0, alpha: 1.0)
            } else if todayData[indexPath.row].type == "补录考勤" {
                cell.chooseImage.image = UIImage(named: "bu")
                cell.chooseLabel.textColor = UIColor(red: 102.0/255.0, green:
                    102.0/255.0, blue: 102.0/255.0, alpha: 1.0)
            }
            
        } else if todayData[indexPath.row].data == "KQ" {
            
            let index = (todayData[indexPath.row].startTime as NSString).substringWithRange(NSMakeRange(11, 5))
            let str = "\(index)-\(todayData[indexPath.row].type)"
            //            cell.dateButton.setTitle(str, forState: .Normal)
            //            cell.dateButton.backgroundColor = UIColor.yellowColor()
            //            cell.dateButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            cell.chooseLabel.text = str
            cell.chooseImage.image = UIImage(named: "daka")
            cell.chooseLabel.textColor = UIColor(red: 1.0/255.0, green:
                167.0/255.0, blue: 36.0/255.0, alpha: 1.0)
        }
 
        return cell
    }

}

private typealias Https = KQCalendarViewController

extension Https: HttpProtocol {
    
    func didResponse(result: NSDictionary) {
        
        models.removeAll()
        if let data: AnyObject = result["data"] {
            let json = JSON(data)
            for val in json {
                let model = KQData()
                if val.1["data"].string! == "OA" {
                    model.id = val.1["KQ_ID"].string!
                    model.endTime = val.1["KQ_EndTime"].string!
                    model.data = val.1["data"].string!
                    model.pass = val.1["KQ_Pass"].int!
                    model.startTime = val.1["KQ_StartTime"].string!
                    model.state = val.1["KQ_State"].string!
                    model.type = val.1["KQ_Type"].string!
                    models.append(model)
                } else if val.1["data"].string! == "KQ" {
                    model.id = val.1["KQ_ID"].string!
                    model.endTime = val.1["KQ_EndTime"].string!
                    model.data = val.1["data"].string!
                    model.startTime = val.1["KQ_StartTime"].string!
                    model.type = val.1["KQ_Type"].string!
                    models.append(model)
                }
                
            }
            
            self.check(date.date)
            spinner.stopAnimating()
            self.listTableVew.reloadData()
        }
    }
}

private typealias ButtonAction = KQCalendarViewController

extension ButtonAction {
    
    @IBAction func mounth(sender: AnyObject) {
        
        self.performSegueWithIdentifier("KQOfMonthSegue", sender: self)
    }
    
    
    //恢复按钮
    @IBAction func regainDate(sender: UIButton) {
        currentDate = date.date
        
        date.setDate(NSDate(), animated: true)
        
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.stringFromDate(date.date)
        dateFormatter.dateFormat = "MM"
        let month = dateFormatter.stringFromDate(date.date)
        
        let bodyStr =  "nian=\(year)&yue=\(month)"
        do {
            
            try httpRequest.Post2(GetService + "/KaoQinMask/JMyList", str: bodyStr)
        } catch {
            
        }
        
        check(date.date)
        self.listTableVew.reloadData()
    }
    
    //查询按钮
    @IBAction func selectDate(sender: UIButton) {
        currentDate = date.date
        
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.stringFromDate(date.date)
        dateFormatter.dateFormat = "MM"
        let month = dateFormatter.stringFromDate(date.date)
        
        let bodyStr =  "nian=\(year)&yue=\(month)"
        do {
            
            try httpRequest.Post2(GetService + "/KaoQinMask/JMyList", str: bodyStr)
        } catch {
            
        }
        
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //        print(dateFormatter.stringFromDate(date.date))
        check(date.date)
        self.listTableVew.reloadData()
    }

}

private typealias Segues = KQCalendarViewController

extension Segues {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "KQOfMonthSegue" {
            let viewController = segue.destinationViewController as! KQCalenderOfMonthViewController
            viewController.dates = models
            print(currentDate)
            viewController.currentDate = currentDate
        }
        
        
    }
    
    @IBAction func unwindToCalendar(segue: UIStoryboardSegue) {
        
    }
}
