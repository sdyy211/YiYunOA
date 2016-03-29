//
//  KQChaiTableViewController.swift
//  YinYunSystem
//
//  Created by 魏辉 on 16/2/3.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class KQChaiTableViewController: UITableViewController, selectContactProtocol {
    
    //流程
    @IBOutlet weak var flowData: UIButton!
    //开始时间和结束时间
    @IBOutlet weak var beginButton: UIButton!
    @IBOutlet weak var endButton: UIButton!

    //项目
    @IBOutlet weak var workButton: UIButton!
    //所在地区
    @IBOutlet weak var areaButton: UIButton!
    //随行人员
    @IBOutlet weak var peopleName: UIButton!
    //目的地
    @IBOutlet weak var destinationText: UITextField!
    //联系电话
    @IBOutlet weak var phoneText: UITextField!
    //预计差旅支出
    @IBOutlet weak var moneyText: UITextField!
    //联系人
    @IBOutlet weak var friendText: UITextField!
    
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
  //项目
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
    //所在地区选则
    @IBAction func areaSelect(sender: UIButton) {
        let alert = UIAlertController(title: "请选择项目", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        for i in 1...area.count {
            let action = UIAlertAction(title: area[i - 1], style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
                self.areaButton.setTitle(self.area[i - 1], forState: UIControlState.Normal)

            })
            alert.addAction(action)
        }
        let cancel = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    //时间选择
    @IBAction func beginTime(sender: UIButton) {
        self.performSegueWithIdentifier("TimeSegue", sender: self)
    }
    @IBAction func endTime(sender: UIButton) {
        self.performSegueWithIdentifier("TimeSegue", sender: self)
    }
    
    //随行人员选择

    @IBAction func peopleCheck(sender: UIButton) {
        
        let selectVC:selectContactViewController = selectContactViewController()
        selectVC.delegate = self
        self.navigationController?.pushViewController(selectVC, animated: true)
    }
    
    
    //保存事件
    @IBAction func saveAction(sender: UIBarButtonItem) {
        destinationText.resignFirstResponder()
        phoneText.resignFirstResponder()
        moneyText.resignFirstResponder()
        friendText.resignFirstResponder()
        reasonText.resignFirstResponder()
        otherText.resignFirstResponder()
        if destinationText.text == "" || reasonText.text == "" {
            let alert = UIAlertController(title: "警告", message: "目的地和事由不能为空！", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (alertActon) -> Void in
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            
            let beigin = beginButton.titleLabel!.text!
            let end = endButton.titleLabel!.text!
            var area = areaButton.titleLabel!.text!
            let feiyong = moneyText!.text!
            //随行人员ID
            var idssuixingrens = follows[0].id
            for i in 1..<follows.count {
                idssuixingrens += "," + follows[i].id
            }
            var suixingrens = follows[0].name
            for i in 1..<follows.count {
                suixingrens += "," + follows[i].name
            }
            
            let lianxiren = friendText!.text!
            let phone = phoneText!.text!
            
            let address = destinationText!.text!
            let other = otherText.text!
            if area == "所在地区" {
                area = ""
            }
            //        print(liuChengId)
            let bodStr = "F_ID=\(liuChengId)&KQ_XiangMu=\(projectID)&address=\(address)&area=\(area)&endtime=\(end)&feiyong=\(feiyong)&idssuixingrens=\(idssuixingrens)&info=\(other)&leixing=cc&lianxiren=\(lianxiren)&pendtime=\(end)&phone=\(phone)&pstarttime=\(beigin)&reason=\(reasonText!.text!)&starttime=\(beigin)&ssuixingrens=\(suixingrens)"
            if request1 == false {
                request1 = true
                do {
                    try self.httpRequest.Post2(GetService + "/KaoQinMask/JSendShenHe", str: bodStr)
                 
                } catch {
                    
                }
                
            }
        }
    }
    
    var area = ["01历下区","01市中区","01天桥区","01高新区","01槐荫区","01历城区","02出差"]
    var httpRequest: HttpRequest!
    var flowArray = [FlowData]()
    //项目数组
    var projectArray = [ProjectData]()
    var liuChengId = ""
    var projectID = ""
    var request1 = false
    //随行人员数组
    var follows = [ChaiUser]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        destinationText.delegate = self
        phoneText.delegate = self
        moneyText.delegate = self
        friendText.delegate = self
        reasonText.delegate = self
        otherText.delegate = self
        phoneText.keyboardType = .NumberPad
        moneyText.keyboardType = .NumbersAndPunctuation
        
        httpRequest = HttpRequest()
        httpRequest.delegate = self
        //流程请求
        httpRequest.Get(GetService + "/Mobile/Mobile/JMGetLiuCheng", parameters: [:])
        //项目请求
        httpRequest.Get(GetService + "/Mobile/Mobile/JMGetXiangMu", parameters: [:])

    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        destinationText.resignFirstResponder()
        phoneText.resignFirstResponder()
        moneyText.resignFirstResponder()
        friendText.resignFirstResponder()
        reasonText.resignFirstResponder()
        otherText.resignFirstResponder()
        if phoneText.text?.characters.count > 11 {
            let alert = UIAlertController(title: "警告", message: "请输入正确的电话号码", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (alertActon) -> Void in
                self.phoneText.text = ""
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getSelectData(array: NSMutableArray) {
        print(array)
        for val in array {
            follows.append(ChaiUser(id: val["U_ID"] as! String, name: val["U_Name"] as! String))
        }
        var name = ""
        for val in follows {
            name += val.name + " "
        }
        
        peopleName.setTitle(name, forState: UIControlState.Normal)
        
    }
    
    
    

}

private typealias Segues = KQChaiTableViewController

extension Segues {
    
    @IBAction func unwindAskForChai(segue: UIStoryboardSegue) {
        
    }
    @IBAction func unwindAskForChaiDone(segue: UIStoryboardSegue) {
        
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TimeSegue" {
            if beginButton.titleLabel?.text != "开始试时间" {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if let vc = segue.destinationViewController as? KQChaiTimeViewController {
                    
                    vc.begin = dateFormatter.dateFromString(beginButton.titleLabel!.text!)
                    vc.end = dateFormatter.dateFromString(endButton.titleLabel!.text!)
                }
                
            }
        }
    }
    
}

private typealias Https = KQChaiTableViewController

extension Https: HttpProtocol {
    
    func didResponse(result: NSDictionary) {
        
        
        if let data = result["rows"] {
            let json = JSON(data)
            for val in json {
                let flowdata = FlowData()
                flowdata.id = val.1["F_ID"].string!
                flowdata.name = val.1["F_Name"].string!
                flowdata.nodes = val.1["Nodes"].string!
                flowArray.append(flowdata)
                
                
            }
            //            print(flowArray[0].nodes)
            
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

private typealias TextFieldDelegate = KQChaiTableViewController

extension TextFieldDelegate: UITextFieldDelegate {

    // 点击return会隐藏键盘
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        destinationText.resignFirstResponder()
        phoneText.resignFirstResponder()
        moneyText.resignFirstResponder()
        friendText.resignFirstResponder()
        reasonText.resignFirstResponder()
        otherText.resignFirstResponder()
        
        return true
    }
    
    //点击空白处会隐藏键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        destinationText.resignFirstResponder()
        //        peopleText.resignFirstResponder()
        phoneText.resignFirstResponder()
        moneyText.resignFirstResponder()
        friendText.resignFirstResponder()
        reasonText.resignFirstResponder()
        otherText.resignFirstResponder()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if phoneText.text?.characters.count > 11 {
            
            let alert = UIAlertController(title: "警告", message: "请输入正确的电话号码", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (alertActon) -> Void in
                self.phoneText.text = ""
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            return false
            
        } else {
            //            for character in string.characters {
            //                switch character {
            //                case "0","1","2","3","4","5","6","7","8","9":
            //                    continue
            //                default:
            //                    return false
            //                }
            //            }
            return true
            
        }
    }
}
