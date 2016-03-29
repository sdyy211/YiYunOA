//
//  meetingRoomApplyCell.swift
//  YinYunSystem
//
//  Created by Mac on 16/2/2.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class meetingRoomApplyCell: UITableViewCell,HttpProtocol,UITextFieldDelegate,meetingApplyTypeDelegate, UITextViewDelegate,selectContactProtocol,UIAlertViewDelegate,UIActionSheetDelegate{

    var url = "/MeetingRoom/JShenQing"
    @IBOutlet weak var meetingRoom: UILabel!
    @IBOutlet weak var meetingName: UITextField!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    
    @IBOutlet weak var peoplePhoneNum: UITextField!
    @IBOutlet weak var meetingType: UITextField!
    @IBOutlet weak var joinPeople: UITextView!
    @IBOutlet weak var tureBtn: UIButton!
    
    @IBOutlet weak var mayFenPeiBtn: UIButton!
    @IBOutlet weak var typeView: UIView!
    
    //产看会议详情的控件
    
    @IBOutlet weak var meetNameLabel: UILabel!
    @IBOutlet weak var meetphoneNumLabel: UILabel!
    
    @IBOutlet weak var meetTypeLabel: UILabel!
    
    
    var VC = UIViewController()
    var meetingTypeView = meetingApplyTypeView()
    var roomId = String()
    var request = HttpRequest()
    override func awakeFromNib() {
        super.awakeFromNib()
       tureBtn.addTarget(self, action: Selector("tureBtnAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        meetingType.delegate = self
        request.delegate = self
        joinPeople.delegate = self
        peoplePhoneNum.delegate = self
//        peoplePhoneNum.keyboardType = UIKeyboardType.NamePhonePad
    }
    //MARK: 确认预订按钮点击事件
    func tureBtnAction(button:UIButton)
    {
        if(meetingName.text == "" || peoplePhoneNum.text == "" || joinPeople.text == "")
        {
            alter("提示！", message: "请检查会议名称、联系电话、参会人员是否填写完整。")
        }else{
            
            postData()
        }
    }
    func alter(title:String,message:String)
    {
        let alertView =  UIAlertController.init(title:title, message:message, preferredStyle: UIAlertControllerStyle.Alert)
        let alertViewCancelAction: UIAlertAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        alertView.addAction(alertViewCancelAction)
        VC.presentViewController(alertView, animated:true , completion: nil)
    }

    func postData()
    {
        loadingAnimationMethod.sharedInstance.startAnimation()
        let index = mayFenPeiBtn.selected
        let postStr =  "endtime=\(endTime.text!)&qname=\(meetingName.text!)&qtype=\(meetingType.text!)&qunames=\(joinPeople.text!)&room=\(roomId)&starttime=\(startTime.text!)&telphone=\(peoplePhoneNum.text!)&mayfenpei=\(index)"
        
        request.Post(GetService + url, str: postStr as String)
    }
    func didResponse(result: NSDictionary) {

        let flag = result.objectForKey("flag") as! NSNumber
        loadingAnimationMethod.sharedInstance.endAnimation()
        if(flag == 1)
        {
            let alertView =  UIAlertController.init(title:"提示", message:"上传成功", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default,
                handler: {
                    action in
                    self.VC.navigationController!.popViewControllerAnimated(true)
            })

            alertView.addAction(okAction)
            VC.presentViewController(alertView, animated:true , completion: nil)
        }else{
            let str = result.objectForKey("msg") as! String
            alter("警告！", message:str)
        }
    }
    //MARK:检测字符串是否含有字母
    func checkPhoneNum(str:String)
    {
        for char in str.utf8 {
            if (char > 64 && char < 91) || (char > 96 && char < 123) {
                peoplePhoneNum.text = ""
                alter("警告！", message: "电话号码中包含字母，请重新输入！")
                break;
            }
        }
        print(str.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        if((str.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 4 )||( str.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 8 )||( str.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 13))
        {
            
        }else{
            peoplePhoneNum.text = ""
            alter("警告！", message: "电话号码的长度不正确，请重新输入（允许的长度为4、8、11位）")
        }
    }

    func textFieldDidEndEditing(textField: UITextField) {
        if(textField.tag == 1)
        {
            if(textField.text == "")
            {
                
            }else{
                checkPhoneNum(peoplePhoneNum.text!)
            }
        }
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        if(textField.tag == 2)
        {
            meetingType.resignFirstResponder()
            
            let myActionSheet = UIActionSheet.init(title: "选择会议类型", delegate:self, cancelButtonTitle: "关闭", destructiveButtonTitle:nil, otherButtonTitles: "内部会议","外部会议")
            myActionSheet.showInView(myActionSheet)
        }
    }
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if(buttonIndex == 1)
        {
            self.meetingType.text = "内部会议"
        }else if(buttonIndex == 2){
            self.meetingType.text = "外部会议"
        }else{
            self.meetingType.text = ""
        }
    }
    func textViewDidBeginEditing(textView: UITextView) {
        joinPeople.resignFirstResponder()
        let selectVC:selectContactViewController = selectContactViewController()
        selectVC.delegate = self
        VC.navigationController?.pushViewController(selectVC, animated: true)
    }
    @IBAction func mayfenpeiBtnAction(sender: AnyObject) {
        var btn = mayFenPeiBtn
        btn = sender as! UIButton
        if(btn.selected == false)
        {
            btn.tag == 1
            btn.selected = true
            btn.setImage(UIImage(named: "choosed"), forState: UIControlState.Selected)
        }else if(btn.selected == true){
            btn.tag == 0
            btn.selected = false
            btn.setImage(UIImage(named: "inchoose"), forState: UIControlState.Reserved)
        }
    }
    func getMeetingType(type: String) {
        meetingType.text = type
        meetingType.resignFirstResponder()
    }
    func getSelectData(array: NSMutableArray) {
        var strName = String()
        for(var i = 0; i < array.count;++i)
        {
            let dic = array.objectAtIndex(i) as! NSDictionary
            let str = dic.objectForKey("U_Name") as! String
            strName = strName + "\(str);"
        }
        print("\(strName)")
        joinPeople.text = strName
        joinPeople.resignFirstResponder()
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        meetingName.resignFirstResponder()
        peoplePhoneNum.resignFirstResponder()
        joinPeople.resignFirstResponder()
        meetingTypeView.removeFromSuperview()
        meetingType.resignFirstResponder()
    }
    
}
