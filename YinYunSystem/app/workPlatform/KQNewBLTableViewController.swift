//
//  KQNewBLTableViewController.swift
//  YinYunSystem
//
//  Created by 魏辉 on 16/2/18.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class KQNewBLTableViewController: UITableViewController {
    
    
    @IBOutlet weak var timeBT: UIButton!
    @IBOutlet weak var reasonTF: UITextField!
   
    var httpRequest: HttpRequest!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        httpRequest = HttpRequest()
        httpRequest.delegate = self
        reasonTF.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

private typealias Https = KQNewBLTableViewController

extension Https: HttpProtocol {
    func didResponse(result: NSDictionary) {

        let json = JSON(result)
        
        if let flag = json["flag"].int {
            if flag == 1 {
                self.performSegueWithIdentifier("UnwindToBL", sender: self)
            } else {
                let alert = UIAlertController(title: "警告", message: json["msg"].string, preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "警告", message: "网络错误", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}

private typealias TextFeildDelegate = KQNewBLTableViewController

extension TextFeildDelegate: UITextFieldDelegate {
    // 点击return会隐藏键盘
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        reasonTF.resignFirstResponder()
 
        return true
    }
    
    //点击空白处会隐藏键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        reasonTF.resignFirstResponder()
        
    }
}

private typealias TableViewDelegate = KQNewBLTableViewController

extension TableViewDelegate {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        reasonTF.resignFirstResponder()
    }
}

private typealias Segues = KQNewBLTableViewController

extension Segues {
    
    @IBAction func unwindToNewBL(segue: UIStoryboardSegue) {
        if let vc = segue.sourceViewController as? KQNewBLTimeViewController {
            if let time = vc.chooseDate {
                timeBT.setTitle(time, forState: .Normal)
            }
        }
    }
}

private typealias ButtonAction = KQNewBLTableViewController

extension ButtonAction {
    
    @IBAction func saveAction(sender: UIBarButtonItem) {
        
        if timeBT.titleLabel?.text != "考勤时间" && reasonTF.text != "" {
            
            let time = timeBT.titleLabel!.text!
            let reason = reasonTF.text!
            
            let bodStr = "pstarttime=\(time)&reason=\(reason)&starttime=\(time)"
            do {
                try self.httpRequest.Post2(GetService + "/KaoQinMask/JAddBuLu", str: bodStr)
            } catch {
                
            }
        } else {
            
            let alert = UIAlertController(title: "警告", message: "有选项未填写！", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func timeChoose(sender: AnyObject) {
        self.performSegueWithIdentifier("TimeSegue", sender: self)
    }
}


