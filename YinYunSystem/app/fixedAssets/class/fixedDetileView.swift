//
//  fixedDetileView.swift
//  YinYunSystem
//
//  Created by Mac on 16/1/14.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class fixedDetileView: UIView,UITableViewDataSource,UITableViewDelegate{

    var tv:UITableView = UITableView()
    var cv:UIView = UIView()
    var megDic:NSDictionary = NSDictionary()
    var itemArry:NSArray = NSArray()
    var titleArry:NSArray = NSArray()
    var height:CGFloat = 0
    var with:CGFloat = 300
    var hc = fixedDetileHeaderView()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleArry = NSArray(objects:"设备名称","设备号","借用人","借用人电话","部门名称","借用日期","借用原因")
        let index:Int = (titleArry.count*35)
        height = CGFloat(Float(index))+40
        
        cv.frame =  CGRectMake((CGRectGetWidth(UIScreen.mainScreen().bounds)-with)/2,(CGRectGetHeight(UIScreen.mainScreen().bounds)-height)/2, with, height)
        cv.backgroundColor = UIColor.blueColor()
        cv.layer.cornerRadius = 20
        
        tv.frame = CGRectMake(0,40,CGRectGetWidth(cv.frame), CGRectGetHeight(cv.frame)-40)
        tv.dataSource = self;
        tv.delegate = self;
//        tv.layer.cornerRadius = 20
        tv.scrollEnabled = false
        cv.addSubview(tv)
        self.addSubview(cv)
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 35
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArry.count;
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style:.Default, reuseIdentifier:"mycell")
        
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRectMake(10, 7, 300, 20)
        
        let str:String = self.data(indexPath.row)
        titleLabel.text = "\(titleArry.objectAtIndex(indexPath.row)) : \(str)"
        cell.addSubview(titleLabel)
        return cell;
    }
    func data(index:Int) ->String
    {
        var str:String = ""
        let meg:NSDictionary = megDic.objectForKey("meg") as! NSDictionary
        switch(index)
        {
            case 0:
                str = megDic.objectForKey("dev") as! String
                break;
            case 1:
                str = megDic.objectForKey("dev_num") as! String
                break;
            case 2:
                str = meg.objectForKey("name") as! String
                break;
            case 3:
                str = meg.objectForKey("iphone") as! String
                break;
            case 4:
                str = meg.objectForKey("department") as! String
                break;
            case 5:
                str = meg.objectForKey("data") as! String
                break;
            case 6:
                str = meg.objectForKey("reseason") as! String
                break;
            default:
                break;
        }
        return str
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.removeFromSuperview()
    }
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        let label = UILabel()
        label.frame = CGRectMake(CGRectGetWidth(cv.frame)/2-40,0,80, 40);
//        label.backgroundColor = UIColor.redColor()
        label.layer.cornerRadius = 18
        label.clipsToBounds = true
        label.textAlignment = NSTextAlignment.Center
//        label.font = UIFont.fontWithSize()
        label.text =  megDic.objectForKey("dev") as? String
        cv.addSubview(label)
        
        tv.reloadData()
    }
    
}
