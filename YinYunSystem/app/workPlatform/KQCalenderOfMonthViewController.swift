//
//  KQCalenderOfMonthViewController.swift
//  YinYunSystem
//  月考勤页面控制器
//  Created by 魏辉 on 16/1/18.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class KQCalenderOfMonthViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var monthOfDate: UIDatePicker!
    @IBOutlet weak var checkSegment: UISegmentedControl!
    
    var httpRequest: HttpRequest!
    //总考勤标题数组
    var sectionArray = Array<String>()
    //时间格式设置
    var dateFormatter = NSDateFormatter()
    //总数据
    var dates = Array<KQData>()
    //当天的总数据
    var dayIndexs = Array<KQData>()
    //出差考勤数据
    var chaiArray = Array<KQData>()
    //出差打卡数据
    var chaiDKArray = Array<KQChaiData>()
    // 每个出差事件保存的打卡数据
    var nChaiDKArray = Array<KQChaiData>()
    
    // 是否查询
    var check = false
    var currentDate: NSDate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView.delegate = self
        listTableView.dataSource = self
        httpRequest = HttpRequest()
        httpRequest.delegate = self
        monthOfDate.setDate(currentDate, animated: true)
        //section头的时间数据
        self.sectionAdd(monthOfDate.date)
        //查询出差的数据添加数组
        self.checkChaiData()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

private typealias TableViewDataSource = KQCalenderOfMonthViewController

extension TableViewDataSource: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if checkSegment.selectedSegmentIndex == 0 {
            return sectionArray.count
        } else {
            return chaiArray.count
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 20
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if checkSegment.selectedSegmentIndex == 0 {
            return sectionArray[section]
        } else {
            return (chaiArray[section].startTime as NSString).substringWithRange(NSMakeRange(5, 14)) + "--" + (chaiArray[section].endTime as NSString).substringWithRange(NSMakeRange(5, 14))
            //            return chaiArray[section].startTime + "-" + chaiArray[section].endTime
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if checkSegment.selectedSegmentIndex == 0 {
            
            let day = Int((sectionArray[section] as NSString).substringWithRange(NSMakeRange(8, 2)))
            self.check(day!)
            return dayIndexs.count
        } else {
            var num = 1
            let id = chaiArray[section].id
            for val in chaiDKArray {
                if id == val.id {
                    num += 1
                }
            }
            return num
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! KQCalenderOfMonthTableViewCell
        if checkSegment.selectedSegmentIndex == 0 {
            let day = Int((sectionArray[indexPath.section] as NSString).substringWithRange(NSMakeRange(8, 2)))

            
            self.check(day!)
            if dayIndexs[indexPath.row].data == "OA" {
                let str = "\(dayIndexs[indexPath.row].type)[\(dayIndexs[indexPath.row].state)]"
                cell.chooseLabel.text = str
                if dayIndexs[indexPath.row].type == "公出" || dayIndexs[indexPath.row].type == "出差" {
                    
                    cell.chooseImage.image = UIImage(named: "chai")
                    cell.chooseLabel.textColor = UIColor(red: 69.0/255.0, green:
                        163.0/255.0, blue: 230.0/255.0, alpha: 1.0)
                } else if dayIndexs[indexPath.row].type == "请假" {
                    cell.chooseImage.image = UIImage(named: "jia")
                    cell.chooseLabel.textColor = UIColor(red: 255.0/255.0, green:
                        115.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                } else if dayIndexs[indexPath.row].type == "加班" {
                    cell.chooseImage.image = UIImage(named: "JB")
                    cell.chooseLabel.textColor = UIColor(red: 230.0/255.0, green:
                        82.0/255.0, blue: 69.0/255.0, alpha: 1.0)
                } else if dayIndexs[indexPath.row].type == "调休" {
                    cell.chooseImage.image = UIImage(named: "tiao")
                    cell.chooseLabel.textColor = UIColor(red: 57.0/255.0, green:
                        175.0/255.0, blue: 182.0/255.0, alpha: 1.0)
                } else if dayIndexs[indexPath.row].type == "补录考勤" {
                    cell.chooseImage.image = UIImage(named: "bu")
                    cell.chooseLabel.textColor = UIColor(red: 102.0/255.0, green:
                        102.0/255.0, blue: 102.0/255.0, alpha: 1.0)
                }
                
            } else if dayIndexs[indexPath.row].data == "KQ" {
                let index = (dayIndexs[indexPath.row].startTime as NSString).substringWithRange(NSMakeRange(11, 5))
                let str = "\(index)-\(dayIndexs[indexPath.row].type)"
                //            cell.dateButton.setTitle(str, forState: .Normal)
                //            cell.dateButton.backgroundColor = UIColor.yellowColor()
                //            cell.dateButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
                cell.chooseLabel.text = str
                cell.chooseImage.image = UIImage(named: "daka")
                cell.chooseLabel.textColor = UIColor(red: 1.0/255.0, green:
                    167.0/255.0, blue: 36.0/255.0, alpha: 1.0)
            }
            
            return cell
        } else {
            if indexPath.row == 0 {
                let str = "\(chaiArray[indexPath.section].type)[\(chaiArray[indexPath.section].state)]"
                cell.chooseLabel.text = str
                if chaiArray[indexPath.row].type == "公出" || chaiArray[indexPath.row].type == "出差" {
                    
                    cell.chooseImage.image = UIImage(named: "chai")
                    cell.chooseLabel.textColor = UIColor(red: 69.0/255.0, green:
                        163.0/255.0, blue: 230.0/255.0, alpha: 1.0)

                }
            } else {
                let id = chaiArray[indexPath.section].id
                nChaiDKArray.removeAll()
                for val in chaiDKArray {
                    if id == val.id {
                        nChaiDKArray.append(val)
                    }
                }
                let str = "\(nChaiDKArray[indexPath.row - 1].time)-出差打卡"
                cell.chooseLabel.text = str
                //                cell.chooseLabel.font = UIFont(name: "Avenir-Light", size: 14)
                cell.chooseImage.image = UIImage(named: "daka")
                cell.chooseLabel.textColor = UIColor(red: 1.0/255.0, green:
                    167.0/255.0, blue: 36.0/255.0, alpha: 1.0)
                
            }
            return cell
        }

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
}

private typealias Https = KQCalenderOfMonthViewController

extension Https: HttpProtocol {
    
    func didResponse(result: NSDictionary) {
        //        print(result)
        if let data = result["dt"] {
            let json = JSON(data)
            for val in json {
                var kQChaiData = KQChaiData()
                kQChaiData.time = val.1["G_Time"].string!
                kQChaiData.id = val.1["G_KQID"].string!
                chaiDKArray.append(kQChaiData)
            }
            
        }
        if check == true {
            dates.removeAll()
            
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
                        dates.append(model)
                    } else if val.1["data"].string! == "KQ" {
                        model.id = val.1["KQ_ID"].string!
                        model.endTime = val.1["KQ_EndTime"].string!
                        model.data = val.1["data"].string!
                        model.startTime = val.1["KQ_StartTime"].string!
                        model.type = val.1["KQ_Type"].string!
                        dates.append(model)
                    }
                }
                
                //section头的时间数据
                self.sectionAdd(monthOfDate.date)
                //查询出差的数据添加数组
                self.checkChaiData()
                self.listTableView.reloadData()
                
            }
            check = false
        }
        
    }
}

private typealias ButtonAction = KQCalenderOfMonthViewController

extension ButtonAction {
    
    @IBAction func checkIndex(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        switch index {
        case 0:
            self.listTableView.reloadData()
        case 1:
            self.listTableView.reloadData()
        default:
            return
        }
    }
    
    @IBAction func checkButton(sender: UIButton) {
        check = true
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.stringFromDate(monthOfDate.date)
        dateFormatter.dateFormat = "MM"
        let month = dateFormatter.stringFromDate(monthOfDate.date)
        
        let bodyStr =  "nian=\(year)&yue=\(month)"
        //        print(bodyStr)
        do {
            
            try httpRequest.Post2(GetService + "/KaoQinMask/JMyList", str: bodyStr)
        } catch {
            
        }
        checkSegment.selectedSegmentIndex = 0
        
    }

}

private typealias SectionDatas = KQCalenderOfMonthViewController

extension SectionDatas {
    //转换星期
    func getWeeks(day: String) -> String {
        var week = ""
        switch day {
        case "Monday","星期一":
            week = "星期一"
        case "Tuesday","星期二":
            week = "星期二"
        case "Wednesday","星期三":
            week = "星期三"
        case "Thursday","星期四":
            week = "星期四"
        case "Friday","星期五":
            week = "星期五"
        case "Saturday","星期六":
            week = "星期六"
        case "Sunday","星期日":
            week = "星期日"
        default:
            break
        }
        
        return week
    }
    
    //获取显示月的天数
    func getMonthDays(date: NSDate) -> Int{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM"
        let month = Int(dateFormatter.stringFromDate(date))
        dateFormatter.dateFormat = "yyyy"
        let year = Int(dateFormatter.stringFromDate(date))
        let days = getDaysOfMonth(year!, month: month!)
        return days
    }
    
    //计算每个月有多少天
    func getDaysOfMonth(year: Int, month: Int) -> Int{
        var days = 0
        if month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12 {
            days = 31
        } else if month == 4 || month == 6 || month == 9 || month == 11 {
            days = 30
        } else {
            if year % 4 == 0 && year % 100 != 0 || year % 400 == 0 {
                days = 29
            } else {
                days = 28
            }
        }
        
        return days
        
    }
    
    //提取星期
    func weekAdd(year: String, month: String, day: String) -> String{
        let str = "\(year)-\(month)-\(day)"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let weekDate = dateFormatter.dateFromString(str)
        dateFormatter.dateFormat = "EEEE"
        let week = getWeeks(dateFormatter.stringFromDate(weekDate!))
        return week
    }
    
    //向section数组中添加数据
    func sectionAdd(date: NSDate) {
        sectionArray.removeAll()
        var days = getMonthDays(date)
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.stringFromDate(date)
        dateFormatter.dateFormat = "MM"
        let month = dateFormatter.stringFromDate(date)
        
        for i in 1...days {
            if i < 10 {
                let w = weekAdd(year, month: month, day: "0\(i)")
                //                print(w + "ashdiugefdkasbfdiuqgd")
                
                let d = "\(year)年\(month)月0\(i)日"
                
                sectionArray.append("\(d),\(w)")
            } else {
                let w = weekAdd(year, month: month, day: "\(i)")
                
                let d = "\(year)年\(month)月\(i)日"
                
                sectionArray.append("\(d),\(w)")
            }
            
        }
        
    }
    
    
    //查询当天数据
    func check(day: Int) {
        dayIndexs.removeAll()
        for model in dates {
            let index1 = Int((model.startTime as NSString).substringWithRange(NSMakeRange(8, 2)))
            let index2 = Int((model.endTime as NSString).substringWithRange(NSMakeRange(8, 2)))
            if  index1 <= day && index2 >= day {
                dayIndexs.append(model)
            }
            
        }
        //        print(dayIndexs)
    }
    
    //查询数组中是否有加班信息
    func checkChaiData() {
        chaiArray.removeAll()
        chaiDKArray.removeAll()
        for val in dates {
            if val.type == "公出" || val.type == "出差" {
                chaiArray.append(val)
                
                let bodyStr = "kqid=\(val.id)"
                do {
                    try httpRequest.Post2(GetService + "/Mobile/Mobile/JGetTravelKQData", str: bodyStr)
                } catch {
                    
                }
            }
        }
    }
}
