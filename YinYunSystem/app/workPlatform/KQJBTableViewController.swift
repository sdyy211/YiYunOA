//
//  KQJBTableViewController.swift
//  YinYunSystem
//
//  Created by 魏辉 on 16/2/3.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class KQJBTableViewController: UITableViewController {
    //流程
    @IBOutlet weak var flowData: UIButton!
    //开始时间和结束时间
    @IBOutlet weak var beginButton: UIButton!
    @IBOutlet weak var endButton: UIButton!
    //类型
    @IBOutlet weak var typeButton: UIButton!
    //项目
    @IBOutlet weak var workButton: UIButton!
    //事由
    @IBOutlet weak var reasonText: UITextField!
    //备注
    @IBOutlet weak var otherText: UITextField!
    
    
    //流程选择
    @IBAction func flowButton(sender: UIButton) {
        if flowArray.count > 0 {
            let alert = UIAlertController(title: "请选择流程", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
            for i in 1...flowArray.count {
                let action = UIAlertAction(title: flowArray[i - 1].name + flowArray[i - 1].nodes, style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
                    self.flowData.setTitle(self.flowArray[i - 1].name + self.flowArray[i - 1].nodes, forState: UIControlState.Normal)
                    self.liuChengId = self.flowArray[i - 1].id
                })
                alert.addAction(action)
            }
            let cancel = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            self.flowData.setTitle("暂无流程", forState: .Normal)
        }
        
    }
    //类型选择
    @IBAction func typeAction(sender: UIButton) {
        
        let alert = UIAlertController(title: "请选择类型", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        for i in 1...types.count {
            let action = UIAlertAction(title: types[i - 1], style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
                self.typeButton.setTitle(self.types[i - 1], forState: UIControlState.Normal)
            })
            alert.addAction(action)
        }
        let cancel = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //项目选择
    @IBAction func workAction(sender: UIButton) {
        
        if projectArray.count > 0 {
        let alert = UIAlertController(title: "请选择项目", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
            for i in 1...projectArray.count {
                let action = UIAlertAction(title: projectArray[i - 1].name, style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
                    self.workButton.setTitle(self.projectArray[i - 1].name, forState: UIControlState.Normal)
                    self.projectID = self.projectArray[i - 1].id
                })
                alert.addAction(action)
            }
            let cancel = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            workButton.setTitle("暂无项目", forState: UIControlState.Normal)
        }
    }
    
    //时间选择
    @IBAction func beginTime(sender: UIButton) {
        self.performSegueWithIdentifier("TimeSegue", sender: self)
    }
    @IBAction func endTime(sender: UIButton) {
        self.performSegueWithIdentifier("TimeSegue", sender: self)
    }
    //保存事件
    @IBAction func saveAction(sender: UIBarButtonItem) {
        reasonText.resignFirstResponder()
        otherText.resignFirstResponder()
        if reasonText.text == "" {
            let alert = UIAlertController(title: "警告", message: "事由不能为空！", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (alertActon) -> Void in
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            
            let beigin = beginButton.titleLabel!.text!
            let end = endButton.titleLabel!.text!
            var type = typeButton.titleLabel!.text!
            let other = otherText.text!
            if type == "项目" {
                type = ""
            }
            //        print(liuChengId)
            let bodStr = "F_ID=\(liuChengId)&KQ_XiangMu=\(projectID)&endtime=\(end)&info=\(other)&&jbtype=\(type)leixing=jb&pendtime=\(end)&pstarttime=\(beigin)&reason=\(reasonText.text!)&starttime=\(beigin)"
            if request1 == false {
                request1 = true
                do {
                    try self.httpRequest.Post2(GetService + "/KaoQinMask/JSendShenHe", str: bodStr)

                } catch {
                    
                }
                
            }
        }

        
        
        
    }
    
    var types = ["普通","公休","节日"]
    var httpRequest: HttpRequest!
    //流程数组
    var flowArray = Array<FlowData>()
    //项目数组
    var projectArray = Array<ProjectData>()
    var liuChengId = ""
    var projectID = ""
    var request1 = false

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        httpRequest = HttpRequest()
        httpRequest.delegate = self
        
        reasonText.delegate = self
        otherText.delegate = self
        
        //流程请求
        httpRequest.Get(GetService + "/Mobile/Mobile/JMGetLiuCheng", parameters: [:])
        //项目请求
        httpRequest.Get(GetService + "/Mobile/Mobile/JMGetXiangMu", parameters: [:])
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        reasonText.resignFirstResponder()
        otherText.resignFirstResponder()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

private typealias Segues = KQJBTableViewController

extension Segues {
    
    @IBAction func unwindAskForJB(segue: UIStoryboardSegue) {
        
    }
    @IBAction func unwindAskForJBDone(segue: UIStoryboardSegue) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TimeSegue" {
            if beginButton.titleLabel?.text != "开始试时间" {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if let vc = segue.destinationViewController as? KQJBTimeViewController {
                    
                    vc.begin = dateFormatter.dateFromString(beginButton.titleLabel!.text!)
                    vc.end = dateFormatter.dateFromString(endButton.titleLabel!.text!)
                }
                
            }
        }
    }
    
}

private typealias Https = KQJBTableViewController

extension Https: HttpProtocol {
    
    func didResponse(result: NSDictionary) {
        
        
        if let data = result["rows"] {
            let json = JSON(data)
            //            print(json)
            for val in json {
                let flowdata = FlowData()
                flowdata.id = val.1["F_ID"].string!
                flowdata.name = val.1["F_Name"].string!
                flowdata.nodes = val.1["Nodes"].string!
                flowArray.append(flowdata)
                
                
            }
            
        }
        
        if let data = result["dt"] {
            let json = JSON(data)
            //            print(json)
            for val in json {
                let project = ProjectData()
                project.id = val.1["projectID"].string!
                project.name = val.1["projectName"].string!
                projectArray.append(project)
            }
            
        }
        
        if request1 == true {
            request1 = false
            let json = JSON(result)
            
            if let flag = json["flag"].int {
                if flag == 0 {
                    let alert = UIAlertController(title: "警告", message: json["msg"].string, preferredStyle: UIAlertControllerStyle.Alert)
                    let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else if flag == 1 {
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
        
    }

    
}

private typealias TextFieldDelegate = KQJBTableViewController

extension TextFieldDelegate: UITextFieldDelegate {

    // 点击return会隐藏键盘
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        reasonText.resignFirstResponder()
        otherText.resignFirstResponder()
        
        
        return true
    }
    
    //点击空白处会隐藏键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        reasonText.resignFirstResponder()
        otherText.resignFirstResponder()
    }
    
}
