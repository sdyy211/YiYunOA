//
//  meetingApplyTypeView.swift
//  YinYunSystem
//
//  Created by Mac on 16/2/4.
//  Copyright © 2016年 魏辉. All rights reserved.
// 会议申请的类型

import UIKit
@objc protocol meetingApplyTypeDelegate{
   func getMeetingType(type:String)
}

class meetingApplyTypeView: UIView,UITableViewDataSource,UITableViewDelegate{
    
    
    var label = UILabel()
    var label2 = UILabel()
    var tv = UITableView()
    var itemArry = NSArray()
    var delegate  = meetingApplyTypeDelegate?()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
        tv = UITableView(frame: CGRectMake(0, 0,CGRectGetWidth(self.frame),60))
        tv.delegate = self;
        tv.dataSource = self;
        self.addSubview(tv)
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArry.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style:.Default, reuseIdentifier:"myCell")
        cell.textLabel?.text = itemArry.objectAtIndex(indexPath.row) as? String
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let type = itemArry.objectAtIndex(indexPath.row) as! String
        delegate?.getMeetingType(type)
        self.removeFromSuperview()
    }

    override func drawRect(rect: CGRect) {
        itemArry = NSArray(objects: "内部会议","外部会议")
        tv.frame = CGRectMake(0, 0,CGRectGetWidth(self.frame),60)
        tv.reloadData()
    }

}
