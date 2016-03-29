//
//  myTableView.swift
//  YinYunSystem
//
//  Created by Mac on 16/3/14.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class myTableView: UIView,UITableViewDelegate,UITableViewDataSource{

    var selectStyle = ""
    var tv = UITableView()
    var itemArry = NSMutableArray()
    var selectViewItemArry = NSMutableArray()
    var dataArry = NSMutableArray()
    var flageArry = NSMutableArray()
    var selectView = selectStyleView()
    var yongzhangDetileView = yongZhangDetileView()
    var segmentV = segmentView()
    var request = HttpRequest()
    var flag = "0"
    var flag2 = ""
    var permissionURL = "/Mobile/Mobile/right"
    
    var kaoqinURL = "/KaoQinCheck/JDaiShenList"
    var KaoqinPiFuURL = "/KaoQinCheck/JShenHe"
    
    var yongZhangURL = "/mobile/mobile/JGetCachetCheckList"
    var yongZhangPiFuURL = "/mobile/mobile/JShenHeCachet"
    
    var rightItem = UIButton()
    var color = UIColor(colorLiteralRed: 238.0/255.0, green: 247.0/255.0, blue: 244.0/255.0, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
    }
    override func drawRect(rect: CGRect) {
        
    }

    //MARK: UItableviewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArry.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(flag == "0"){
            //全部列表的高度
            return 50
        }else if(flag == "1")
        {
            //考勤列表的高度
            return 90
        }else if(flag == "2"){
            //用章列表的高度
            return 113
        }else if(flag == "3"){
            //报销列表的高度
            return 50
        }else{
            //其他
            return 50
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(flag == "1")
        {
            //考勤列表的cell
            tableView.registerNib(UINib(nibName: "AuditTableViewCell", bundle: nil), forCellReuseIdentifier: "cell1")
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            let cell:AuditTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell1") as! AuditTableViewCell
            
            return cell
        }else if(flag == "2"){
            //用章列表的cell
            tableView.registerNib(UINib(nibName: "yongZhangPendingCell", bundle: nil), forCellReuseIdentifier: "cell2")
            
            let cell:yongZhangPendingCell = tableView.dequeueReusableCellWithIdentifier("cell2") as! yongZhangPendingCell
            return cell
            
        }else{
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
            return cell
        }
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    func selectTableViewCell(tv:UITableView,index:NSIndexPath)
    {
        selectView.removeFromSuperview()
        if(flag == "1"){
            //点击考勤的列表判断
            let flagStr = flageArry.objectAtIndex(index.row) as! String
            if(rightItem.tag == 2)
            {
                if(flagStr == "0")
                {
                    flageArry.replaceObjectAtIndex(index.row, withObject:"1")
                }else if(flagStr == "1"){
                    flageArry.replaceObjectAtIndex(index.row, withObject:"0")
                }
                tv.reloadData()
            }else if(rightItem.tag == 1){
                
                let dic = itemArry.objectAtIndex(index.row) as! NSDictionary
                let detileView = AuditDetileView.init(frame: CGRectMake(0,0,CGRectGetWidth(UIScreen.mainScreen().bounds),CGRectGetHeight(UIScreen .mainScreen().bounds)))
                detileView.backgroundColor = UIColor.init(colorLiteralRed:0, green: 0, blue: 0, alpha:0.5)
                detileView.deleteURL = "/KaoQinCheck/JShenHe"
                detileView.itemDic = dic
                //                detileView.viewController = self
                //                detileView.delegate = self
                let window:UIWindow = UIApplication.sharedApplication().keyWindow!
                window.addSubview(detileView)
            }
            
        }else if(flag == "2"){
            //点击用章的列表判断
            let flagStr = flageArry.objectAtIndex(index.row) as! String
            if(rightItem.tag == 2)
            {
                if(flagStr == "0")
                {
                    flageArry.replaceObjectAtIndex(index.row, withObject:"1")
                }else if(flagStr == "1"){
                    flageArry.replaceObjectAtIndex(index.row, withObject:"0")
                }
                tv.reloadData()
            }else if(rightItem.tag == 1){
                let dic = itemArry.objectAtIndex(index.row) as! NSDictionary
                yongzhangDetileView = yongZhangDetileView.init(frame: CGRectMake(0,0,CGRectGetWidth(UIScreen.mainScreen().bounds),CGRectGetHeight(UIScreen .mainScreen().bounds)))
                yongzhangDetileView.backgroundColor = UIColor.init(colorLiteralRed:0, green: 0, blue: 0, alpha:0.5)
                yongzhangDetileView.dataDic = dic
                yongzhangDetileView.nameKey = "BD_UName"
                yongzhangDetileView.departmentKey = "BD_BuMen"
                //                yongzhangDetileView.viewController = self
                yongzhangDetileView.titleArry = ["用印分类","用印时间","用印事由","备注","留存材料","用印次数","当前状态"]
                yongzhangDetileView.keyArry = ["BD_LeiXing","BD_Time","BD_Reason","BD_BeiZhu","BD_CaiLiao","BD_CiShu","BD_State"]
                //                yongzhangDetileView.delegate = self
                let window:UIWindow = UIApplication.sharedApplication().keyWindow!
                window.addSubview(yongzhangDetileView)
                
            }
        }

    }
    func setTableViewCell(cell2:AnyObject,index:NSIndexPath)
    {
        if(selectStyle == "考勤")
        {
            let cell:AuditTableViewCell = cell2 as! AuditTableViewCell
            cell.contentView.backgroundColor = color
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            if(rightItem.tag == 1)
            {
                cell.imageFlage.hidden = true
                cell.imageFlage.image = UIImage(named: "inchoose")
            }else if(rightItem.tag == 2){
                cell.imageFlage.hidden = false
                if(flageArry.count > 0)
                {
                    let flagStr =  flageArry.objectAtIndex(index.row) as! String
                    if(flagStr == "0")
                    {
                        cell.imageFlage.image = UIImage(named: "inchoose")
                    }else if(flagStr == "1")
                    {
                        cell.imageFlage.image = UIImage(named: "choosed")
                    }
                }
            }
            cell.cellBackView.layer.borderWidth = 1
            cell.cellBackView.layer.borderColor = UIColor.grayColor().CGColor
            cell.cellBackView.layer.cornerRadius  = 10
            
            
            let dic = itemArry.objectAtIndex(index.row) as! NSDictionary
            cell.name.text = dic.objectForKey("U_Name") as? String
            cell.endTime.text = dic.objectForKey("KQ_EndTime") as? String
            cell.startTime.text = dic.objectForKey("KQ_AddTime") as? String
        }else if(selectStyle == "用章"){
            let cell:yongZhangPendingCell = cell2 as! yongZhangPendingCell
            cell.contentView.backgroundColor = color
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.textLabel?.textColor = UIColor(colorLiteralRed: 113.0/255.0, green: 123.0/255.0, blue: 128.0/255.0, alpha: 1)
            cell.cellbackView.layer.borderWidth = 1
            cell.cellbackView.layer.borderColor = UIColor.grayColor().CGColor
            cell.cellbackView.layer.cornerRadius  = 10
            
            if(rightItem.tag == 1)
            {
                cell.yongzhangImage.hidden = true
                cell.yongzhangImage.image = UIImage(named: "inchoose")
            }else if(rightItem.tag == 2){
                cell.yongzhangImage.hidden = false
                if(flageArry.count > 0)
                {
                    let flagStr =  flageArry.objectAtIndex(index.row) as! String
                    if(flagStr == "0")
                    {
                        cell.yongzhangImage.image = UIImage(named: "inchoose")
                    }else if(flagStr == "1")
                    {
                        cell.yongzhangImage.image = UIImage(named: "choosed")
                    }
                }
            }
            
            let dic =  itemArry.objectAtIndex(index.row) as! NSDictionary
            cell.name.text = dic.objectForKey("BD_UName") as? String
            cell.department.text = dic.objectForKey("BD_BuMen") as? String
            cell.type.text = dic.objectForKey("BD_LeiXing") as? String
            cell.time.text = dic.objectForKey("BD_Time") as? String
            //            cell.state.text = dic.objectForKey("FCK_State") as? String

        }

    }

}
