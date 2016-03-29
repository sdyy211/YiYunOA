//
//  KQTiaoTableViewController.swift
//  YinYunSystem
//
//  Created by 魏辉 on 16/2/3.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class KQTiaoTableViewController: UITableViewController {
    
    //流程
    @IBOutlet weak var flowData: UIButton!
    //开始时间和结束时间
    @IBOutlet weak var beginButton: UIButton!
    @IBOutlet weak var endButton: UIButton!
    //事由
    @IBOutlet weak var reasonText: UITextField!
    //备注
    @IBOutlet weak var otherText: UITextField!
    
    @IBOutlet weak var messageLabel: UILabel!
    
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
            let alert = UIAlertController(title: "警告", message: "目的地和事由不能为空！", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (alertActon) -> Void in
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            
            
            let beigin = beginButton.titleLabel!.text!
            let end = endButton.titleLabel!.text!
            let other = otherText.text!
            //        print(liuChengId)
            let bodStr = "F_ID=\(liuChengId)&endtime=\(end)&info=\(other)&leixing=tx&pendtime=\(end)&pstarttime=\(beigin)&reason=\(reasonText.text!)&starttime=\(beigin)"
            if request1 == false {
                request1 = true
                do {
                    try self.httpRequest.Post2(GetService + "/KaoQinMask/JSendShenHe", str: bodStr)

                } catch {
                    
                }
                
            }
        }
        
        
    }
    

    var httpRequest: HttpRequest!
    var flowArray = Array<FlowData>()
    var liuChengId = ""
    var request1 = false
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        httpRequest = HttpRequest()
        httpRequest.delegate = self
        reasonText.delegate = self
        otherText.delegate = self
        //调休剩余时间请求
        let datefor = NSDateFormatter()
        datefor.dateFormat = "yyyy-MM-dd"
        let date = datefor.stringFromDate(NSDate())

        
        let parameters = ["date": date, "lx":"tx"]
        httpRequest.Get(GetService + "/Mobile/Mobile/JMGetKQInfo", parameters: parameters)
        //流程申请
        httpRequest.Get(GetService + "/Mobile/Mobile/JMGetLiuCheng", parameters: [:])

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

private typealias Segues = KQTiaoTableViewController

extension Segues {
    
    @IBAction func unwindAskForTiao(segue: UIStoryboardSegue) {
        
    }
    @IBAction func unwindAskForTiaoDone(segue: UIStoryboardSegue) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TimeSegue" {
            if beginButton.titleLabel?.text != "开始试时间" {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if let vc = segue.destinationViewController as? KQTiaoTimeViewController {
                    
                    vc.begin = dateFormatter.dateFromString(beginButton.titleLabel!.text!)
                    vc.end = dateFormatter.dateFromString(endButton.titleLabel!.text!)
                }
                
            }
        }
    }
    
}

private typealias Https = KQTiaoTableViewController

extension Https: HttpProtocol {
    
    func didResponse(result: NSDictionary) {
        
        //流程返回
        if let data = result["rows"] {
            let json = JSON(data)
            for val in json {
                let flowdata = FlowData()
                flowdata.id = val.1["F_ID"].string!
                flowdata.name = val.1["F_Name"].string!
                flowdata.nodes = val.1["Nodes"].string!
                flowArray.append(flowdata)
                
                
            }
            
        }
        //保存事件返回
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
        
        //年假天数信息
        if let data = result["values"] {
            
            let json = JSON(data)
            guard json["nianjiatianshu"].string != nil else {
                return
            }
            
            let shijian = json["tiaoxiutianshu"].string!
            let shengyu = json["tiaoxiushengyu"].string!
            let daishen = json["daishentiaoxiufenzhong"].string!
            let shiyong = json["yishentiaoxiufenzhong"].string!
            self.messageLabel.text = "该年共有\(shijian)分钟加班，已使用\(shiyong)分钟，\n待审\(daishen)分钟，剩余\(shengyu)分钟。"
            
            
        }
        
        
    }
    
}

private typealias TextFieldDelegate = KQTiaoTableViewController

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
